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
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func pressAddButton() {
        performSegue(withIdentifier: "WaitingNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitingNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Ожидание"
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

extension WaitingViewController: UITableViewDelegate {}

extension WaitingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waitingTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WaitingViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaitingViewCell
        cell.taskNameLabel.text = waitingTaskList[indexPath.row].title
        cell.taskExecutorLabel.text = waitingTaskList[indexPath.row].executor
        cell.taskTimeLabel.text = waitingTaskList[indexPath.row].dateInfo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            CoreDataContext.sharedInstance.context.delete(waitingTaskList[indexPath.row])
            waitingTaskList.remove(at: indexPath.row)
            saveCoreDataContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        delete.image = #imageLiteral(resourceName: "Удалить")
        delete.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ready = UIContextualAction(style: .normal, title: "Готово") { (action, view, CompletionHandler) in
            CoreDataContext.sharedInstance.context.delete(waitingTaskList[indexPath.row])
            waitingTaskList.remove(at: indexPath.row)
            saveCoreDataContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        ready.image = #imageLiteral(resourceName: "Готово")
        ready.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6784313725, blue: 0.0431372549, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [ready])
    }

}

