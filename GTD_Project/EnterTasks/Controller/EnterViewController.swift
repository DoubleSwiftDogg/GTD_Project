//
//  EnterViewController.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import UIKit

class EnterViewController: UIViewController {

    var titleBuffer: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func pressAddButton() {
        //предлагаю позднее выводить алерт контроллер стиля actionSheet, и в нем выбирать Быструю запись или сразу обрабатываемую
        let ac = UIAlertController(title: "Новая запись", message: "Введите запись", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.textFields![0].autocapitalizationType = .sentences
        let accept = UIAlertAction(title: "Принять", style: .default) { (action) in
            if ac.textFields![0].text?.isEmpty == false {
                addEnterItem(item: ac.textFields![0].text!)
                self.tableView.reloadData()
            } else {
                ac.dismiss(animated: true, completion: nil)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            ac.dismiss(animated: true, completion: nil)
        }
        ac.addAction(accept)
        ac.addAction(cancel)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func pressEditButton() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadEnterList()
        tableView.reloadData()
        //tableView.allowsSelection = false  - после теста на реальном телефоне-удалить!
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "handleSegue" {
//            let handleTargetVC = segue.destination as! HandleViewController
//            handleTargetVC.entryTitle = self.titleBuffer
//        }
//    }
    
    
}

extension EnterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = enterList[indexPath.row]
        cell.textLabel?.textColor = .blue
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let from = enterList[fromIndexPath.row]
        enterList.remove(at: fromIndexPath.row)
        enterList.insert(from, at: to.row)
        saveEnterList()
        tableView.reloadData()
    }
}

extension EnterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            removeEnterItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        delete.image = #imageLiteral(resourceName: "Удалить")
        delete.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0, blue: 0, alpha: 1)

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ready = UIContextualAction(style: .normal, title: "Готово") { (action, view, CompletionHandler) in
            removeEnterItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        ready.image = #imageLiteral(resourceName: "Готово")
        ready.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6784313725, blue: 0.0431372549, alpha: 1)
        
        let handle = UIContextualAction(style: .normal, title: "Обработка") { (action, view, CompletionHandler) in
            print("Handle")
            self.titleBuffer = enterList[indexPath.row]
            //self.performSegue(withIdentifier: "handleSegue", sender: nil)
            let callingHandleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HandleViewController") as! HandleViewController
            callingHandleVC.delegate = self
            callingHandleVC.entryTitle = self.titleBuffer
            self.present(callingHandleVC, animated: true, completion: nil)
            CompletionHandler(true)
        }
        handle.image = #imageLiteral(resourceName: "Обработка")
        handle.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.6196078431, blue: 0.01176470588, alpha: 1)
        return UISwipeActionsConfiguration(actions: [ready, handle])
    }
}

extension EnterViewController: EnterTableDelegate {
    func reloadEnterTable() {
        let item = enterList.firstIndex(of: self.titleBuffer)
        removeEnterItem(at: item!)
        self.tableView.reloadData()
    }
}
