//
//  SuspendedViewController.swift
//  GTD_Project
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SuspendedViewController: UIViewController {

    var isTaskEditing = false // пометка, для проверки необходимости передачи данных Таска на Обработку
    var sendedTaskToEdit: TaskToEdit?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func pressAddButton() {
        
        performSegue(withIdentifier: "SuspendedNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SuspendedNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Когда-нибудь/Может быть"
            if isTaskEditing == true {
                isTaskEditing = false
                targetVC.incomingTaskToEdit = sendedTaskToEdit
                sendedTaskToEdit = nil
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let waitPredicate: NSPredicate = NSPredicate(format: "category == 1")
        fetchRequest.predicate = waitPredicate
        
        do {
            suspendedTaskList = try CoreDataContext.sharedInstance.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension SuspendedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTaskEditing = true
        sendedTaskToEdit = TaskToEdit(task: suspendedTaskList[indexPath.row], categoryString: "Когда-нибудь/Может быть")
        performSegue(withIdentifier: "SuspendedNewSegue", sender: nil)
    }
    
}

extension SuspendedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return suspendedTaskList.count
        } else {
            return suspendedCompletedTaskList.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Выполненные"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
             cell.textLabel?.text = suspendedTaskList[indexPath.row].title
        }
        
        if indexPath.section == 1 {
             cell.textLabel?.text = suspendedCompletedTaskList[indexPath.row].title
        }
       
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            
            if indexPath.section == 0 {
                CoreDataContext.sharedInstance.context.delete(suspendedTaskList[indexPath.row])
                suspendedTaskList.remove(at: indexPath.row)
                saveCoreDataContext()
            } else if indexPath.section == 1 {
                CoreDataContext.sharedInstance.context.delete(suspendedCompletedTaskList[indexPath.row])
                suspendedCompletedTaskList.remove(at: indexPath.row)
                saveCoreDataContext()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        delete.image = #imageLiteral(resourceName: "Удалить")
        delete.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ready = UIContextualAction(style: .normal, title: "Готово") { (action, view, CompletionHandler) in
            
            if indexPath.section == 0 {
               suspendedTaskList[indexPath.row].isCompleted = true
                suspendedCompletedTaskList.append(suspendedTaskList[indexPath.row])
                suspendedTaskList.remove(at: indexPath.row)
                tableView.reloadData()
                
            } else if indexPath.section == 1 {
                suspendedCompletedTaskList[indexPath.row].isCompleted = false
                suspendedTaskList.append(suspendedCompletedTaskList[indexPath.row])
                suspendedCompletedTaskList.remove(at: indexPath.row)
                tableView.reloadData()
            }
            
            saveCoreDataContext()
            CompletionHandler(true)
        }
        ready.image = #imageLiteral(resourceName: "Готово")
        ready.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6784313725, blue: 0.0431372549, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [ready])
    }
}
