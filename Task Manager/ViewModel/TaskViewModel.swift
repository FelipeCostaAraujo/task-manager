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
    
    //MARK: New task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basica"
}


