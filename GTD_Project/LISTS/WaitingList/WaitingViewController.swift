//
//  WaitingViewController.swift
//  GTD_Project
//
//  Created by MacBook on 16/03/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }
    
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WaitingViewController: UITableViewDelegate {
    
}

extension WaitingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WaitingViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WaitingViewCell
        cell.taskNameLabel.text = taskList[indexPath.row].title
        cell.taskExecutorLabel.text = taskList[indexPath.row].executor
        cell.taskTimeLabel.text = taskList[indexPath.row].dateInfo
        
        return cell
    }
    

}

