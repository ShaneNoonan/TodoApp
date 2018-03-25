//
//  CoreDataStack.swift
//  ToDoApp
//
//  Created by Shane Noonan on 19/03/2018.
//  Copyright © 2018 Shane Noonan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "ToDos")
        container.loadPersistentStores { (container, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
        }
        
        return container
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
