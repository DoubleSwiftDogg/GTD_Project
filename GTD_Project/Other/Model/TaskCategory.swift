//
//  TaskCategory.swift
//  GTD_Project
//
//  Created by MacBook on 29/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import Foundation

enum TaskCategory {
    case suspended
    case waiting
    case calendar
    case action
    //case project = "Проект"
}

let TaskCategoryListDic: [String: TaskCategory] = ["Когда-нибудь/Может быть": .suspended , "Ожидание": .waiting , "Календарь": .calendar , "Действия": .action ] //в будущем добавить сюда "Проект"

let TaskCategoryList: [String] = ["Когда-нибудь/Может быть", "Ожидание", "Календарь", "Действия"]
//var selectedCategory: TaskCategory?

protocol dropDownProtocol {
    func dropDownPressed (string: String)
}
