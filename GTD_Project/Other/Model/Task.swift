//
//  Model.swift
//  GTD_Project
//
//  Created by MacBook on 28.10.2018.
//  Copyright © 2018 PB. All rights reserved.
//

//слова из курса: Контроллер знает модель, на её основе создает экземпляр, заполняет его, а затем "потрошит его" чтобы достать какие-то данные
import Foundation
import UIKit //согласно курсу, если в модели появляется UI - значит что-то пошло не так!!!
import CoreData


// ---ЗАДАЧА - КЛАСС
//class Task {
//
//    //СВОЙСТВА
//    var title: String            //название
//    var category: TaskCategory   //категория
//    var executor: String?        //исполнитель
//    var result: String?          //результат
//    var reminder: Date?          //напоминание
//    var taskDate: Date?          //дата задачи(календарь)
//    var project: Project?        //проект (в разработке)
//    var dateInfo: String?        //текстовая инфа по срокам для "Ожидание"
//
//
//    //ИНИЦИАЛИЗАТОРЫ
//    init(title: String, category: TaskCategory, executor: String?, result: String?, reminder: Date?, taskDate: Date?, project: Project?, dateInfo: String?) {
//
//        self.title = title
//        self.category = category
//        self.executor = executor
//        self.result = result
//        self.reminder = reminder
//        self.taskDate = taskDate
//        self.project = project
//        self.dateInfo = dateInfo
//    }
//
//    //МЕТОДЫ
////    func deleteTask(index: Int) {}
////    func completeTask() {}
////    func setProject() {}
////    func changeCategory() {}
////    func editTask() {}
////    func setReminder() {}
////    func setDate() {}
//
//}





// ----------------





//func createTask - необходимость в этой функции пока сомнительна, ведь мегаинициализатор и создает эту задачу.
//init(title: String, category: TaskCategory, executor: String?, result: String?, reminder: Date?, taskDate: Date?, project: Project?, dateInfo: String?)
//Есть мысль о переносе данной функции в контроллер(или вьюшку?), без создания экземпляра Task, и с прсвоением значения полей сразу сущности, минуя инициализацию. Возможно при таком раскладе нам и Класс не понадобится?

//func createTask(title: String, category: TaskCategory, executor: String?, result: String?, reminder: Date?, taskDate: Date?, project: Project?, dateInfo: String?) {
//    let newTask = Task.init(title: title, category: category, executor: executor, result: result, reminder: reminder, taskDate: taskDate, project: project, dateInfo: dateInfo)
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context = appDelegate.persistentContainer.viewContext
//    
//    let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
//    let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
//    taskObject.title = newTask.title
//    taskObject.category = newTask.category
//    taskObject.executor = newTask.executor
//    taskObject.result = newTask.result
//    taskObject.reminder = newTask.reminder
//    taskObject.taskDate = newTask.taskDate
//    taskObject.project = newTask.project
//    taskObject.dateInfo = newTask.dateInfo
//    //рассмотреть возможность деинициализации объекта, т.к. если я правильно понимаю, после создания объекта данные передаются другому объекту
//    
//    do {
//        try context.save()
//        taskList.append(taskObject)
//        print("Saved!")
//    } catch {
//        print(error.localizedDescription)
//    }
//}
