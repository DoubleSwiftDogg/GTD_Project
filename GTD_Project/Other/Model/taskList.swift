//
//  taskList.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//

import Foundation

var waitingTaskList: [Task] = []
var waitingCompletedTaskList: [Task] = []

var actionsTaskList: [Task] = []
var actionsCompletedTaskList: [Task] = []

var suspendedTaskList: [Task] = []
var suspendedCompletedTaskList: [Task] = []

var calenderTaskList: [Task] = []
var calenderCompletedTaskList: [Task] = []

struct TaskToEdit {
    var task: Task?
    var categoryString: String?
}
