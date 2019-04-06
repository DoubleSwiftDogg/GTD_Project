//
//  HandleViewController.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class HandleViewController: UIViewController {
    
    var dropView = DropDownTable()
    var waitingView = WaitingView()
    var height = NSLayoutConstraint()
    var isOpen = false
    var entryTitle = ""
    var categoryStringSegue: String?
    //var selectedCategory: TaskCategory
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var catButton: UIButton!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        
        titleTextField.text = entryTitle
        
        dropView = DropDownTable(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dropView)
        self.view.bringSubviewToFront(dropView)
        
        dropView.topAnchor.constraint(equalTo: catButton.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: catButton.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: catButton.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
        
        if categoryStringSegue != nil {
            handleChosenCategory(string: categoryStringSegue!)
            catButton.setTitle(categoryStringSegue, for: .normal)
        }
    }
    
    //функция нажатия кнопки выбора категории
    @IBAction func chooseCatButton() {
        self.view.bringSubviewToFront(dropView)
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if self.dropView.tableView.contentSize.height > 500 {
                self.height.constant = 500
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func pressReadyButton() {
        
        //Сначала нужно проверить, заполнены ли нужные для категории поля
        //Затем убедившись в этом, присвоить неким переменным значения полей
        //И только потом инициализировать нашу задачу
        
        let readyData: Bool
        let selectedCategory: TaskCategory?
        
        if categoryStringSegue == nil {
            readyData = false
            selectedCategory = nil
        } else {
            readyData = checkForArguments(string: categoryStringSegue!)
            selectedCategory = TaskCategoryListDic[categoryStringSegue!]
        }
        
        //let selectedCategory = TaskCategoryListDic[categoryStringSegue!]
        
        if readyData == true  {
            if selectedCategory == .waiting {
                createTask(title: titleTextField.text!, category: selectedCategory!, executor: waitingView.executorTextField.text!, result: waitingView.resultTextField.text!, dateInfo: waitingView.periodTextField.text!)
            }
            if selectedCategory == .action {
                createTask(title: titleTextField.text!, category: selectedCategory!)
            }
            if selectedCategory == .suspended {
                createTask(title: titleTextField.text!, category: selectedCategory!)
            }
            
            if entryTitle != "" {
                let item = enterList.index(of: entryTitle) as! Int
                removeEnterItem(at: item)
            }
            
        self.dismiss(animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Данные не указаны", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Я передумал", style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                ac.dismiss(animated: false, completion: nil)
                
            }))
            ac.addAction(UIAlertAction(title: "Понятно", style: .cancel, handler: { (action) in
                ac.dismiss(animated: true, completion: nil)
            }))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func createTask(title: String, category: TaskCategory, executor: String? = nil, result: String? = nil, reminder: NSDate? = nil, taskDate: NSDate? = nil, project: Project? = nil, dateInfo: String? = nil) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        
        taskObject.title = title
        taskObject.category = category.rawValue as NSObject
        taskObject.executor = executor
        taskObject.result = result
        taskObject.reminder = reminder
        taskObject.taskDate = taskDate
        //taskObject.project = project
        taskObject.dateInfo = dateInfo
        
            do {
                try context.save()
                print("Saved!")
            } catch {
                print(error.localizedDescription)
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleChosenCategory(string: String) {
        
        //дописываем новые поля в случае выбора нужной категории
        let selectedCategory = TaskCategoryListDic[string]!
        if selectedCategory == .waiting {
            
            waitingView = WaitingView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            waitingView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(waitingView)
            waitingView.topAnchor.constraint(equalTo: catButton.bottomAnchor).isActive = true
            waitingView.centerXAnchor.constraint(equalTo: catButton.centerXAnchor).isActive = true
            waitingView.widthAnchor.constraint(equalTo: catButton.widthAnchor).isActive = true
            
            self.view.bringSubviewToFront(waitingView)
        }
    }
    
    func checkForArguments(string: String) -> Bool {
        
        let selectedCategory: TaskCategory
        selectedCategory = TaskCategoryListDic[string]!
        
        switch selectedCategory {
        case .waiting:
            if waitingView.executorTextField.text! == "" {
                return false
            } else {
                return true
            }
        case .suspended:
            if titleTextField.text! == "" {
                return false
            } else {
                return true
            }
        case .calendar:
            break
        case .action:
            if titleTextField.text! == "" {
                return false
            } else {
                return true
            }
        }
        return false
    }
}

extension HandleViewController: dropDownProtocol {
    func dropDownPressed(string: String) {
        catButton.setTitle(string, for: .normal)
        
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        
        categoryStringSegue = string
        handleChosenCategory(string: categoryStringSegue!)
    }
}
