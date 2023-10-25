//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Felipe Araujo on 21/05/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    private let center = UNUserNotificationCenter.current()
    
    init(){
        self.center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                
            case .notDetermined:
                self.center.requestAuthorization(options: [.sound,.alert,.carPlay,.badge]) { authorized, error in
                    print("O usuario autorizou?\(authorized)")
                }
            case .denied:
                print("denied")
            case .authorized:
                print("authorized")
            case .provisional:
                print("provisional")
            case .ephemeral:
                print("ephemeral")
            @unknown default:
                print("@unknown")
            }
        }
        
        self.center.requestAuthorization(options: [.sound,.alert,.carPlay,.badge]) { authorized, error in
            print("O usuario autorizou? \(authorized)")
        }
        
        let confirmAction = UNNotificationAction(identifier: NotificationIdentifier.confirm, title: "Já estudei 👍🏻", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: NotificationIdentifier.cancel, title: "Cancelar", options: [.foreground])
        let category = UNNotificationCategory(identifier: NotificationIdentifier.category, actions: [confirmAction,cancelAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    @Published var currentTab: String = "today"
    
    // MARK: New task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "basic"
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
            createNotification(task)
            return true
        }
        return false
    }
    
    // MARK: Resetting Data
    func resetTaskData(){
        taskType = "basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    // MARK: If edit task is available then setting exisiting data
    func setupTask(){
        if let editTask = editTask{
            taskType = editTask.type ?? "basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
    
    func createNotification(_ task: Task) {
        let content = UNMutableNotificationContent()
        content.title = task.type?.localizedCapitalized ?? ""
        content.subtitle = task.title ?? ""
        content.body = task.deadline!.formatted(date: .abbreviated,time: .omitted) + ", " + task.deadline!.formatted(date: .omitted,time: .shortened)
        content.categoryIdentifier = NotificationIdentifier.category
        
        let calendar = Calendar.current
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: taskDeadline), repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
    }
}

class NotificationIdentifier {
    static let confirm: String = "Confirm"
    static let cancel: String = "Cancel"
    static let category: String = "Category"
    static let confirmation: String = "Confirmation"
}
