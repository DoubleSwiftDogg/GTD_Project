//
//  WaitingViewController.swift
//  GTD_Project
//
//  Created by MacBook on 16/03/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit
import CoreData


class WaitingViewController: UIViewController {
    
    var isTaskEditing = false // пометка, для проверки необходимости передачи данных Таска на Обработку
    var sendedTaskToEdit: TaskToEdit?
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func pressAddButton() {
        performSegue(withIdentifier: "WaitingNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitingNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Ожидание"
            if isTaskEditing == true {
                isTaskEditing = false
                targetVC.incomingTaskToEdit = sendedTaskToEdit
                sendedTaskToEdit = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let waitPredicate: NSPredicate = NSPredicate(format: "category == 2")
        fetchRequest.predicate = waitPredicate
        
        do {
            waitingTaskList = try CoreDataContext.sharedInstance.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
}

extension WaitingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTaskEditing = true
        sendedTaskToEdit = TaskToEdit(task: waitingTaskList[indexPath.row], categoryString: "Ожидание")
        performSegue(withIdentifier: "WaitingNewSegue", sender: nil)
    }
    
}

extension WaitingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return waitingTaskList.count
        } else {
            return waitingCompletedTaskList.count
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
        let cell:WaitingViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaitingViewCell
        if indexPath.section == 0 {
            cell.taskNameLabel.text = waitingTaskList[indexPath.row].title
            cell.taskExecutorLabel.text = waitingTaskList[indexPath.row].executor
            cell.taskTimeLabel.text = waitingTaskList[indexPath.row].dateInfo
        }
        
        if indexPath.section == 1 {
            cell.taskNameLabel.text = waitingCompletedTaskList[indexPath.row].title
            cell.taskExecutorLabel.text = waitingCompletedTaskList[indexPath.row].executor
            cell.taskTimeLabel.text = waitingCompletedTaskList[indexPath.row].dateInfo
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            if indexPath.section == 0 {
                CoreDataContext.sharedInstance.context.delete(waitingTaskList[indexPath.row])
                waitingTaskList.remove(at: indexPath.row)
                saveCoreDataContext()
            } else if indexPath.section == 1 {
                CoreDataContext.sharedInstance.context.delete(waitingCompletedTaskList[indexPath.row])
                waitingCompletedTaskList.remove(at: indexPath.row)
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
                waitingTaskList[indexPath.row].isCompleted = true
                waitingCompletedTaskList.append(waitingTaskList[indexPath.row])
                waitingTaskList.remove(at: indexPath.row)
                tableView.reloadData()
                
            } else if indexPath.section == 1 {
                waitingCompletedTaskList[indexPath.row].isCompleted = false
                waitingTaskList.append(waitingCompletedTaskList[indexPath.row])
                waitingCompletedTaskList.remove(at: indexPath.row)
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

