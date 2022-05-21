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
    
    // MARK: Editing existing task data
    @Published var editTask: Task?
    
    // MARK: Adding Task To Core Data
    func addTask(context: NSManagedObjectContext) -> Bool{
        // MARK: Updating existing data in core data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
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
    
    // MARK: If edit task is available then setting exisiting data
    func setupTask(){
        if let editTask = editTask{
            taskType = editTask.type ?? "Basica"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}


