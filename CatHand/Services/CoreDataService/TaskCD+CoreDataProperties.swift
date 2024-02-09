//
//  TaskCD+CoreDataProperties.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 09.02.2024.
//
//

import Foundation
import CoreData


extension TaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCD> {
        return NSFetchRequest<TaskCD>(entityName: "TaskCD")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var taskDateCD: TaskDateCD?
    
    public var wrappedCreationDate: Date {
        creationDate ?? Date()
    }
    public var wrappedid: UUID {
        id ?? UUID()
    }
    public var wrappedIsCompleted: Bool {
        isCompleted
    }
    public var wrappedTitle: String {
        title ?? "Unknown task"
    }

}

extension TaskCD : Identifiable {

}
