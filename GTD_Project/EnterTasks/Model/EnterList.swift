//
//  EnterList.swift
//  GTD_Project
//
//  Created by MacBook on 06/01/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import Foundation

//СписокВхода - массив с записями входящих
var enterList: [String] = ["Это тестовая запись во Входящие", "Для удаления свайпните задачу вправо", "Для обработки - влево", "Спасибо за использование этого органайзера"] //Значения по умолчанию при первом входе

func addEnterItem(item:String) {
    enterList.append(item)
    saveEnterList()
}

func removeEnterItem(at index: Int) {
    enterList.remove(at: index)
    saveEnterList()
}
