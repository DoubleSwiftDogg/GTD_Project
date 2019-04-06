//
//  CoreDataFuncs.swift
//  GTD_Project
//
//  Created by MacBook on 06/04/2019.
//  Copyright © 2019 PB. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public func saveCoreDataContext() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    do {
        try context.save()
        print("Saved!")
    } catch {
        print(error.localizedDescription)
    }
}
