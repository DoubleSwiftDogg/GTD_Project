//
//  ActionsViewController.swift
//  GTD_Project
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit
import CoreData

class ActionsViewController: UIViewController {
    
    var isTaskEditing = false // пометка, для проверки необходимости передачи данных Таска на Обработку
    var sendedTaskToEdit: TaskToEdit?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func pressAddButton() {
        performSegue(withIdentifier: "ActionsNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActionsNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Действия"
            if isTaskEditing == true {
                isTaskEditing = false
                targetVC.incomingTaskToEdit = sendedTaskToEdit
                sendedTaskToEdit = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let waitPredicate: NSPredicate = NSPredicate(format: "category == 4")
        fetchRequest.predicate = waitPredicate
        
        do {
            actionsTaskList = try CoreDataContext.sharedInstance.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
}

extension ActionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTaskEditing = true
        sendedTaskToEdit = TaskToEdit(task: actionsTaskList[indexPath.row], categoryString: "Действия")
        performSegue(withIdentifier: "ActionsNewSegue", sender: nil)
    }
}

extension ActionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return actionsTaskList.count
        } else {
            return actionsCompletedTaskList.count
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
            cell.textLabel?.text = actionsTaskList[indexPath.row].title
        }
        
        if indexPath.section == 1 {
            cell.textLabel?.text = actionsCompletedTaskList[indexPath.row].title
        }
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            
            if indexPath.section == 0 {
                CoreDataContext.sharedInstance.context.delete(actionsTaskList[indexPath.row])
                actionsTaskList.remove(at: indexPath.row)
                saveCoreDataContext()
            } else if indexPath.section == 1 {
                CoreDataContext.sharedInstance.context.delete(actionsCompletedTaskList[indexPath.row])
                actionsCompletedTaskList.remove(at: indexPath.row)
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
                actionsTaskList[indexPath.row].isCompleted = true
                actionsCompletedTaskList.append(actionsTaskList[indexPath.row])
                actionsTaskList.remove(at: indexPath.row)
                tableView.reloadData()
                
            } else if indexPath.section == 1 {
                actionsCompletedTaskList[indexPath.row].isCompleted = false
                actionsTaskList.append(actionsCompletedTaskList[indexPath.row])
                actionsCompletedTaskList.remove(at: indexPath.row)
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
