//
//  DynamicFilteredView.swift
//  Task Manager
//
//  Created by Felipe Araujo on 21/05/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    // MARK: Building Custom ForEach which will give Coredata object to build view
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content){
        
        // MARK: Predicate to Filter current data Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Hoje" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day,value: 1, to: today)!
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
            
        }else if currentTab == "Por vir" {
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day,value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
            
        } else if currentTab == "Fracassado" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
            
        }
        else{
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)],
                                predicate: predicate)
        
        self.content = content
    }
    
    var body: some View {
        Group{
            if request.isEmpty{
                Text("Nenhuma tarefa encontrada")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                }
            }
        }
    }
}
