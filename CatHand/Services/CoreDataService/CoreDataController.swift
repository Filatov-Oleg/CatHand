//
//  CoreDataController.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 09.02.2024.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataService")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
