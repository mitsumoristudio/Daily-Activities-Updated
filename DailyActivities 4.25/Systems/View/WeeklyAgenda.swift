//
//  WeeklyAgenda.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI

struct WeeklyAgenda: View {
    @StateObject var taskModel = DailyActivityViewModel()
    @Namespace var animation
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editButton
    @State var showBottomSheet: Bool = false
    @State var showIcon: Bool = false
    @State var showEditScreen: Bool = false
    var ispendingTask: Bool = false
    
    // MARK: Fetching categoryTasks
    // MARK: Fetching Task
    @FetchRequest(entity: DailyEntity.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DailyEntity.taskDate, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<DailyEntity>
    
    @Environment(\.self) var environmentSave
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: LazyStack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    ZStack {
                        Image("pexels")
                            .ignoresSafeArea()
                            .frame(width: 400, height: 1100)
                        
                        VStack(spacing: 5) {
                            // MARK: add taskView here
                            
                            
                            upComingTaskView
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .frame(width: 400, height: 1400)
                        // use height 1400
                        .cornerRadius(20)
                        .shadow(color: Color.black, radius: 20, x: 5, y: 10)
                    }

                    // MARK: - Add TasksView
              //      taskView
                    
                } header: {
                    headerViewCalenderView()
                }
             
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .offset(y: -80)
        // MARK: Add Button
        
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                taskModel.addNewActivity.toggle()
                
                saveContext()
          //      showBottomSheet.toggle()
            }, label: {
                Image(systemName: "plus")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.black, in: Circle())
                    .font(.system(size: 36, design: .rounded))
            })
            .padding()
        }
        
        // MARK: Add action item for sheet
        .sheet(isPresented: $taskModel.addNewActivity) {
            taskModel.editActivity = nil
        } content: {
            CategoryTask()
                .presentationDetents([.fraction(0.55), .medium])
                .presentationDragIndicator(.visible)
                .environmentObject(taskModel)
        }
        

        .sheet(isPresented: $showEditScreen, content: {
            EditTaskView()
                .environmentObject(DailyActivityViewModel())
                .presentationDetents([.fraction(0.40), .medium])
                .presentationDragIndicator(.visible)
                .environmentObject(taskModel)
        })
        
    }
}

struct DuplicateCalenderView_Preview : PreviewProvider {
    static var previews: some View {
        WeeklyAgenda()
    }
}

extension WeeklyAgenda {
    @ViewBuilder
    var upComingTaskView: some View {
        LazyVStack(spacing: 20) {
            UpComingFilteredView(currentTab: taskModel.currentTab, content: { (task : DailyEntity) in
                taskCardView(task: task)
            })
            // MARK: Need to rewrite the formula for tomorrow for this to work
            }
        .padding()
    }
    @ViewBuilder
    func taskCardView(task: DailyEntity) -> some View {
        // MARK: Since CoreData Values will Give Optinal data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top,spacing: 20) {
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active {
                // Edit Button for Current and Future Tasks
                VStack(alignment: .leading, spacing: 10){
                    
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()){
                        
                        Button {
                            taskModel.editActivity = task
                            taskModel.addNewActivity.toggle()
                     
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        // MARK: Deleting Task
                        context.delete(task)
                        
                        // Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
            }
            else{
                VStack(spacing: 10){
                    Circle()
                        .fill(Color(taskModel.categoryColor ?? "lightGreen"))
                        .frame(width: 16, height: 16)
                 
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack() {
                    Button(action: {
                        task.isCompleted.toggle()
                        
                        taskModel.editActivity?.isCompleted.toggle()
            
                        // MARK: - add save context here for checkmark square to work
                        saveContext()
                    }
                           , label: {
                    //    Buttonbox()
                        Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                            .font(.title2)
                            .foregroundColor(Color.blue)
                    })
                    .buttonStyle(.plain)
                    
                    Image(systemName: "alarm.fill")
                        .font(.subheadline)
                        .foregroundColor(Color.pink)
                    
                    Text(task.taskDate?.formatted(date: .abbreviated.self, time: .omitted) ?? "")
                        .foregroundStyle(.blue)
                        .font(.headline)
                    
                  
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                        .foregroundStyle(.blue)
                        .font(.headline)
                }
                .hLeading()
                
                
                VStack(alignment: .leading, spacing: 0) {
                    if task.isCompleted == true {
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            .strikethrough(!ispendingTask, pattern: .solid, color: .primary)
                            .foregroundStyle(Color.black)
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .strikethrough(!ispendingTask, pattern: .solid, color: .primary)
                            .foregroundStyle(.black)
                    } else {
                        
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                            .foregroundStyle(Color.black)
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.black)
                    }
            }
            
                }
            .frame(alignment: .leading)

            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom,taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background {
                
            }
        }
        .padding(.horizontal, 10)
        .hLeading()
        
    }
}

// MARK: - Dynamic FilteredView
extension WeeklyAgenda {
    
    @ViewBuilder
    func dynamicListView() -> some View {
        LazyVStack(spacing: 10) {
            DynamicFilteredView(dateToFilter: taskModel.currentDay, content: {(object: DailyEntity) in
                
                //      taskView(task: object)})
            })
        }
    }
        func saveContext() {
            do {
                try environmentSave.managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
}

// MARK: - Header View

extension WeeklyAgenda{
    @ViewBuilder
    func headerViewCalenderView() -> some View {
        
        VStack(alignment: .leading, spacing: -12) {
            HStack(spacing: 5) {
                Text("Weekly Agenda")
                
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 20)
            }
            HStack(spacing: 20) {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.secondary)
                        .font(.title3)
                        .padding(.horizontal, 20)
                    
                        .padding(.vertical, 16)
                    
//                    EditButton()
//                        .padding(.horizontal, 20)
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .offset(x: 120)
                }
                .padding(.vertical, 5)
            
          
           
            // MARK: Add CustomSegmentedBar
            CustomSegmentedBar()
            
            .padding(.horizontal, 10)
            
            }
            
        .frame(width: 400, height:140, alignment: .bottomLeading)
            .padding(.vertical)
            
            //   .background(Color.black.opacity(0.5))
            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
            .ignoresSafeArea(.all, edges: .top)
            .padding()
          
        }
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar()->some View{
        // In Case if we Missed the Task
        let tabs = ["Today","Upcoming","Completed"]
        HStack(spacing: 0){
            ForEach(tabs,id: \.self){tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .padding(.vertical,6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab{
                            Capsule()
                                .fill(Color.indigo)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
            }
        }
    }
    
    }

