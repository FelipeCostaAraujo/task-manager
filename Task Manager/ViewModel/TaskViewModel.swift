//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Felipe Araujo on 21/05/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Hoje"
    
    // MARK: New task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basica"
    @Published var showDatePicker: Bool = false
    
    // MARK: Adding Task To Core Data
    func addTask(context: NSManagedObjectContext) -> Bool{
        let task = Task(context: context)
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    // MARK: Resetting Data
    func resetTaskData(){
        taskType = "Basica"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
}


