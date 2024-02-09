//
//  TaskDateCD+CoreDataProperties.swift
//  CatHand
//
//  Created by Филатов Олег Олегович on 09.02.2024.
//
//

import Foundation
import CoreData


extension TaskDateCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskDateCD> {
        return NSFetchRequest<TaskDateCD>(entityName: "TaskDateCD")
    }

    @NSManaged public var taskDate: Date?
    @NSManaged public var taskCD: Set<TaskCD>?

    public var wrappedTaskDate: Date {
        taskDate ?? Date()
    }
    
    public var tackCDArray: [TaskCD] {
        let set = taskCD ?? []
        return set.sorted { $0.wrappedCreationDate < $1.wrappedCreationDate }
    }
}

// MARK: Generated accessors for taskCD
extension TaskDateCD {

    @objc(addTaskCDObject:)
    @NSManaged public func addToTaskCD(_ value: TaskCD)

    @objc(removeTaskCDObject:)
    @NSManaged public func removeFromTaskCD(_ value: TaskCD)

    @objc(addTaskCD:)
    @NSManaged public func addToTaskCD(_ values: NSSet)

    @objc(removeTaskCD:)
    @NSManaged public func removeFromTaskCD(_ values: NSSet)

}

extension TaskDateCD : Identifiable {

}
