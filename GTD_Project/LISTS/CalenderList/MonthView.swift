//
//  MonthView.swift
//  GTD_Project
//
//  Created by MacBook on 01/05/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

protocol MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int, dest: String)
}

class MonthView: UIView {
    
    @IBOutlet weak var monthLabel: UILabel?
    
    var monthsList = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    var currentYear: Int = 0
    var currentMonthIndex: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        monthLabel?.text = "\(monthsList[currentMonthIndex]) \(currentYear)"
    }
    
    @IBAction func pressLeftButton() {
        let dest = "Left"
        currentMonthIndex -= 1
        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }
        changeMonthLabel(dest: dest)
    }
    
    @IBAction func pressRightButton() {
        let dest = "Right"
        currentMonthIndex += 1
        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }
        changeMonthLabel(dest: dest)
    }
    
    func changeMonthLabel(dest: String) {
        monthLabel?.text = "\(monthsList[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear, dest: dest)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        monthLabel?.text = "\(monthsList[currentMonthIndex]) \(currentYear)"
    }


}
