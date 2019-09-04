//
//  Defaults.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import Foundation

//Загрузка из дефолтов СпискаВхода ИЛИ создание дефолтов из стандартного СпискаВхода (при первом открытии)
func loadEnterList() {
    
    let defaults = UserDefaults.standard
    
    if defaults.array(forKey: "enterList") == nil {
        defaults.set(enterList, forKey: "enterList")
    } else {
        enterList = defaults.array(forKey: "enterList") as! [String]
    }
    
    if defaults.array(forKey: "enterCompletedList") == nil {
        defaults.set(enterCompletedList, forKey: "enterCompletedList")
    } else {
        enterCompletedList = defaults.array(forKey: "enterCompletedList") as! [String]
    }
}

func saveEnterList() {
    let defaults = UserDefaults.standard
    defaults.set(enterList, forKey: "enterList")
    defaults.set(enterCompletedList, forKey: "enterCompletedList")
    defaults.synchronize()
}
