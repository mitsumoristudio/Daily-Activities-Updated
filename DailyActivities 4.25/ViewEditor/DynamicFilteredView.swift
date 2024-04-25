//
//  DynamicFilteredView.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import CoreData
import SwiftUI

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
   
    let content: (T)->Content
    
    // MARK: Building Custom ForEach which will give Coredata object to build View
    init (dateToFilter: Date,@ViewBuilder content: @escaping (T)->Content){
    
        // MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Filter Key
        let filterKey = "taskDate"
        
        // This will fetch task between today and tommorow which is 24 HRS
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
        
        // Intializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \DailyEntity.taskDate, ascending: false)], predicate: predicate)
        self.content = content
       
    }
    
    var body: some View {
        
        Group{
            if request.isEmpty{
                Section {
                    VStack(spacing: 10) {
                        Image(systemName:  "newspaper.circle")
                            .font(.system(size: 160, design: .rounded))
                            .opacity(0.7)
                        
                        Text("No Activities here. Write down with +")
                                     .font(.system(size: 16))
                            .fontWeight(.light)
                            .italic()
                     
                    }
                    Spacer()
                }
                .padding()
            }
            else{
                
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}


struct UpComingFilteredView<Content: View, T> : View where T: NSManagedObject {
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    init(currentTab: String,@ViewBuilder content: @escaping (T)->Content) {
        
        // MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            // Filter Key
            let filterKey = "taskDate"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
         //   predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today,tommorow, 0])
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow,1])
        } else if currentTab == "Upcoming"{
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            // Filter Key
            let filterKey = "taskDate"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
        //    predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today,tommorow,0])
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow, 1])
            
        } else if currentTab == "Failed"{
            
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            // Filter Key
            let filterKey = "taskDate"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past,today,0])
        }
        else{
            // 0-false, 1-true
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        // Intializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \DailyEntity.taskDate, ascending: false)], predicate: predicate)
        self.content = content
    }

    var body: some View {
        Group{
            if request.isEmpty{
                Section {
                    VStack(spacing: 10) {
                        Image(systemName:  "newspaper.circle")
                            .font(.system(size: 160, design: .rounded))
                            .opacity(0.7)
                        
                        Text("No Activities here. Write down with +")
                            .font(.system(size: 16))
                            .fontWeight(.light)
                            .italic()
                        
                    }
                    Spacer()
                }
                .padding()
            }
            else {
                
                ForEach(request,id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
