//
//  CalenderViewController.swift
//  GTD_Project
//
//  Created by MacBook on 10/05/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit
import CoreData
//import Foundation

class CalenderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calenderView: CalenderView!
    
    @IBAction func pressAddButton() {
        
        performSegue(withIdentifier: "CalenderNewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalenderNewSegue" {
            let targetVC = segue.destination as! HandleViewController
            targetVC.categoryStringSegue = "Календарь"
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        let waitPredicate: NSPredicate = NSPredicate(format: "category == 3")
//        fetchRequest.predicate = waitPredicate
//        
//        do {
//            calenderTaskList = try CoreDataContext.sharedInstance.context.fetch(fetchRequest)
//        } catch {
//            print(error.localizedDescription)
//        }
//        tableView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        tableView.reloadData()
    }
}

extension CalenderViewController: UITableViewDelegate {}

extension CalenderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calenderTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = calenderTaskList[indexPath.row].title
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, CompletionHandler) in
            CoreDataContext.sharedInstance.context.delete(calenderTaskList[indexPath.row])
            calenderTaskList.remove(at: indexPath.row)
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
            CoreDataContext.sharedInstance.context.delete(suspendedTaskList[indexPath.row])
            calenderTaskList.remove(at: indexPath.row)
            saveCoreDataContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
            CompletionHandler(true)
        }
        ready.image = #imageLiteral(resourceName: "Готово")
        ready.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.6784313725, blue: 0.0431372549, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [ready])
    }
}

extension CalenderViewController: CalenderDelegate {
    func didTapDate(date: Date) {
        let NSChosenDate = date as NSDate
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let waitPredicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "category = 3"),
            NSPredicate(format: "taskDate = %@", NSChosenDate)
            ])
        //let waitPredicate: NSPredicate = NSPredicate(format: "category = 3 AND taskDate = \(NSChosenDate))")
        fetchRequest.predicate = waitPredicate
        
        do {
            calenderTaskList = try CoreDataContext.sharedInstance.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
}
