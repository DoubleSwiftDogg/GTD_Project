//
//  HandleViewController.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import UIKit

class HandleViewController: UIViewController {
    
    var dropView = DropDownTable()
    var result = ResultView() // result
    var height = NSLayoutConstraint()
    var heightResult = NSLayoutConstraint() //heightResult
    var isOpen = false
    var entryTitle = ""
    
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
        //---------------------------------//
        
        
        result = ResultView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        //result = Bundle.main.loadNibNamed("ResultView", owner: self, options: nil)!.first as! ResultView
        result.translatesAutoresizingMaskIntoConstraints = false
        result.isHidden = true
        self.view.addSubview(result)

        result.topAnchor.constraint(equalTo: catButton.bottomAnchor, constant: 17).isActive = true
        result.centerXAnchor.constraint(equalTo: catButton.centerXAnchor).isActive = true
        result.widthAnchor.constraint(equalTo: catButton.widthAnchor).isActive = true
        heightResult = result.heightAnchor.constraint(equalToConstant: 0)
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
        
        //дописываем новые поля в случае выбора нужной категории
        selectedCategory = TaskCategoryListDic[string]
        if selectedCategory == .waiting {

            print("Success!")
            self.view.bringSubviewToFront(result)
            result.isHidden = false
        }
    }
}

//extension HandleViewController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
//}
