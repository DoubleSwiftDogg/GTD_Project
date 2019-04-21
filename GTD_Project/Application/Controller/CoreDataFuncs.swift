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

public class CoreDataContext {
    
    static let sharedInstance = CoreDataContext()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
}

public func saveCoreDataContext() {
    
    do {
        try CoreDataContext.sharedInstance.context.save()
        print("Saved!")
    } catch {
        print(error.localizedDescription)
    }
}
