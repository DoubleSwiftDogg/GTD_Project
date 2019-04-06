//
//  ActionsViewController.swift
//  GTD_Project
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ActionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func pressAddButton() {
        
        performSegue(withIdentifier: "ActionsNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActionsNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Действия"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let waitPredicate: NSPredicate = NSPredicate(format: "category == 4")
        fetchRequest.predicate = waitPredicate
        
        do {
            actionsTaskList = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }

}

extension ActionsViewController: UITableViewDelegate {}

extension ActionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionsTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = actionsTaskList[indexPath.row].title
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(actionsTaskList[indexPath.row])
            actionsTaskList.remove(at: indexPath.row)
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(actionsTaskList[indexPath.row])
            actionsTaskList.remove(at: indexPath.row)
            saveCoreDataContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        ready.image = #imageLiteral(resourceName: "Готово")
        ready.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6784313725, blue: 0.0431372549, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [ready])
    }
}
