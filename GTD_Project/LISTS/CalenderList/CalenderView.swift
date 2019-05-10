//
//  CalenderView.swift
//  GTD_Project
//
//  Created by MacBook on 01/05/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import UIKit

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numberOfDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear  = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    @IBOutlet var calenderView: UIView!
    @IBOutlet weak var monthView: MonthView!
    @IBOutlet weak var daysCollectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        initializeView()
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //Предусматриваем високосный год
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numberOfDaysInMonth[currentMonthIndex] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        monthView?.monthLabel?.text = "\(monthView?.monthsList[currentMonthIndex-1] ?? "Неопределено") \(currentYear)"
    
        daysCollectionView?.delegate = self
        daysCollectionView?.dataSource = self
        daysCollectionView?.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
        daysCollectionView?.reloadData()
        
        monthView?.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor = .clear
        if indexPath.item <= firstWeekDayOfMonth - 3 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+3
            cell.isHidden=false
            cell.dateLbl.text="\(calcDate)"
            
//            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex  {
//                cell.isUserInteractionEnabled=false
//                cell.dateLbl.textColor = UIColor.lightGray
//            } else {
//                cell.isUserInteractionEnabled=true
//            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 6
        let height: CGFloat = 30 //сомнительно
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 1 ? 8 : day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        
        currentMonthIndex = monthIndex+1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numberOfDaysInMonth[monthIndex] = 29
            } else {
                numberOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        daysCollectionView?.reloadData()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        initializeView()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("calenderView", owner: self, options: nil)
        addSubview(calenderView)
        calenderView.frame = self.bounds
        calenderView.translatesAutoresizingMaskIntoConstraints = false
        calenderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        calenderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        calenderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
        bringSubviewToFront(calenderView)
    }
    
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(dateLbl)
        dateLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        dateLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        dateLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        
    }
    
    let dateLbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
