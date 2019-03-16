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
    var waitingView = WaitingView()
    var height = NSLayoutConstraint()
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
            
            waitingView = WaitingView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
            waitingView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(waitingView)
            waitingView.topAnchor.constraint(equalTo: catButton.bottomAnchor).isActive = true
            waitingView.centerXAnchor.constraint(equalTo: catButton.centerXAnchor).isActive = true
            waitingView.widthAnchor.constraint(equalTo: catButton.widthAnchor).isActive = true

            self.view.bringSubviewToFront(waitingView)
        }
    }
}
