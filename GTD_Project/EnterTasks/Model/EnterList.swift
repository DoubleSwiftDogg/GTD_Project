//
//  EnterList.swift
//  GTD_Project
//
//  Created by MacBook on 06/01/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import Foundation

//СписокВхода - массив с записями входящих
var enterList: [String] = ["Тестовая запись1", "Тестовая запись2", "333"] //Значения по умолчанию при первом входе

func addEnterItem(item:String) {
    enterList.append(item)
    saveEnterList()
}

func removeEnterItem(at index: Int) {
    enterList.remove(at: index)
    saveEnterList()
}
