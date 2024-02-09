//
//  PlannerViewModel.swift
//  Instafilter
//a
//  Created by Филатов Олег Олегович on 11.01.2024.
//

import Foundation
import SwiftUI
import CoreData

final class PlannerViewModel: ObservableObject {
    
    @Published var tasks: [TaskPlanner] = []
    @Published var currentDate: Date = .init()
    
    private var tasksDict: [Date: [TaskPlanner]] = [:]
    
    private let mocContext: NSManagedObjectContext
    
    init(mocContext: NSManagedObjectContext) {
        self.mocContext = mocContext
        //        fetchSavedStories()
    }
    
    @MainActor
    func fetchTasks(by date: Date) async {
        let tasks1 = tasksDict.first(where: { (key: Date, value: [TaskPlanner]) in
            Calendar.current.compare(date, to: key, toGranularity: .day) == .orderedSame
        })
        tasks = tasks1?.value ?? []
    }
    
    
    func addNewTask(_ task: TaskPlanner) {
        if var tasks1 = tasksDict.first(where: { (key: Date, value: [TaskPlanner]) in
            Calendar.current.compare(task.creationDate, to: key, toGranularity: .day) == .orderedSame
        }) {
            tasks1.value.append(task)
            tasksDict[tasks1.key]?.append(task)
            tasksDict[tasks1.key]?.sort(by: {$0.creationDate < $1.creationDate})
        } else {
            tasksDict[task.creationDate] = [task]
        }
        currentDate = task.creationDate
        Task {
            await addNewTaskToCD(task)
        }
    }
    
    func delete(_ task: TaskPlanner) {
        guard let index = tasks.firstIndex(of: task) else {
            return
        }
        if let tasks1 = tasksDict.first(where: { (key: Date, value: [TaskPlanner]) in
            Calendar.current.compare(task.creationDate, to: key, toGranularity: .day) == .orderedSame
        }) {
            tasksDict[tasks1.key]?.remove(at: index)
        }
        tasks.remove(at: index)
        Task {
            await deleteTaskFromCD(task)
        }
    }
    
    func complete(_ task: TaskPlanner) {
        if let tasks1 = tasksDict.first(where: { (key: Date, value: [TaskPlanner]) in
            Calendar.current.compare(task.creationDate, to: key, toGranularity: .day) == .orderedSame
        }) {
            
            guard let index = tasksDict[tasks1.key]?.firstIndex(where: { savedTask in
                savedTask.id == task.id
            }) else {
                print("ERRORRRRRRRRr")
                return
            }
            tasksDict[tasks1.key]?[index].isComleted = task.isComleted
            tasks[index].isComleted = task.isComleted
        }
        Task {
            await completedTaskInCD(task)
        }
    }
}


// MARK: Core data for tasks

extension PlannerViewModel {
    func fetchTasksFromCD() async {
        if let savedTaskDates = try? mocContext.fetch(TaskDateCD.fetchRequest()) {
            for taskDate in savedTaskDates {
                tasksDict[taskDate.wrappedTaskDate] = taskDate.tackCDArray.map { TaskPlanner(id: $0.wrappedid, taskTitle: $0.wrappedTitle, creationDate: $0.wrappedCreationDate, isComleted: $0.wrappedIsCompleted, tint: Color(uiColor: UIColor(hexString: "B0B0B0")))}
            }
        }
    }

    func addNewTaskToCD(_ task: TaskPlanner) async {
        if let savedTaskDates = try? mocContext.fetch(TaskDateCD.fetchRequest()) {
            if savedTaskDates.isEmpty {
                let newTaskDate = TaskDateCD(context: mocContext)
                newTaskDate.taskDate = task.creationDate

                let newTask = TaskCD(context: mocContext)
                newTask.creationDate = task.creationDate
                newTask.id = task.id
                newTask.isCompleted = task.isComleted
                newTask.title = task.taskTitle
                newTask.taskDateCD = newTaskDate
            } else {
                if let savedTaskDate = savedTaskDates.first(where: { taskDate in
                    Calendar.current.compare(taskDate.wrappedTaskDate, to: task.creationDate, toGranularity: .day) == .orderedSame
                }) {
                    let newTask = TaskCD(context: mocContext)
                    newTask.creationDate = task.creationDate
                    newTask.id = task.id
                    newTask.isCompleted = task.isComleted
                    newTask.title = task.taskTitle
                    newTask.taskDateCD = savedTaskDate
                } else {
                    let newTaskDate = TaskDateCD(context: mocContext)
                    newTaskDate.taskDate = task.creationDate
                    
                    let newTask = TaskCD(context: mocContext)
                    newTask.creationDate = task.creationDate
                    newTask.id = task.id
                    newTask.isCompleted = task.isComleted
                    newTask.title = task.taskTitle
                    newTask.taskDateCD = newTaskDate
                }
            }
        }
        if mocContext.hasChanges {
            try? self.mocContext.save()
        }
    }
    
    func completedTaskInCD(_ task: TaskPlanner) async {
        if let savedTaskDates = try? mocContext.fetch(TaskDateCD.fetchRequest()) {
            for savedTaskDate in savedTaskDates {
                if Calendar.current.compare(savedTaskDate.wrappedTaskDate, to: task.creationDate, toGranularity: .day) == .orderedSame {
                    for saveTask in savedTaskDate.tackCDArray {
                        if saveTask.wrappedCreationDate == task.creationDate {
                            saveTask.isCompleted = task.isComleted
                        }
                    }
                }
            }
        }
        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
    
    func deleteTaskFromCD(_ task: TaskPlanner) async {
        if let savedTaskDates = try? mocContext.fetch(TaskDateCD.fetchRequest()) {
            for savedTaskDate in savedTaskDates {
                if Calendar.current.compare(savedTaskDate.wrappedTaskDate, to: task.creationDate, toGranularity: .day) == .orderedSame {
                    for saveTask in savedTaskDate.tackCDArray {
                        if saveTask.wrappedCreationDate == task.creationDate {
                            mocContext.delete(saveTask)
                        }
                    }
                }
            }
        }
        if mocContext.hasChanges {
            try? mocContext.save()
        }
    }
    
    func deleteOldTasks() async {
        if let savedTaskDates = try? mocContext.fetch(TaskDateCD.fetchRequest()) {
            for savedTaskDate in savedTaskDates {
                if Calendar.current.compare(savedTaskDate.wrappedTaskDate, to: .init(), toGranularity: .month) == .orderedAscending {
                    mocContext.delete(savedTaskDate)
                }
            }
        }
        if mocContext.hasChanges {
            try? self.mocContext.save()
        }
    }
}
