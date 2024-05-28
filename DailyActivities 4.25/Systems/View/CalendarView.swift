//
//  CalendarView.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI

struct CalenderView: View {
    @StateObject var taskModel = DailyActivityViewModel()
    @Namespace var animation
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editButton
    @State var showBottomSheet: Bool = false
    @State var showIcon: Bool = false
    @State var showEditScreen: Bool = false
    var ispendingTask: Bool = false
    
    @Environment(\.self) var environmentSave
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: LazyStack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    ZStack {
//                        Image("pexels")
//                            .ignoresSafeArea()
//                            .frame(width: 800, height: 760)
//                        
                        VStack(spacing: 5) {
                            taskView
                            Spacer()
                        }
                        
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .frame(width: 400, height: 760, alignment: .center)
                        // use height 1400
                        .cornerRadius(20)
                        .shadow(color: Color.black, radius: 20, x: 5, y: 10)
                    }

                    // MARK: - Add TasksView
              //      taskView
                    
                } header: {
                    headerViewCalenderView()
                }
                .offset(y: -5)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .offset(y: -90)
        // MARK: Add Button
        
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                taskModel.addNewActivity.toggle()
               // taskModel.addNewTask.toggle()
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
     //       taskModel.editTask = nil
        } content: {
            CategoryTask()
                .presentationDetents([.fraction(0.55), .medium])
                .presentationDragIndicator(.visible)
                .environmentObject(taskModel)
        }
        

//        .sheet(isPresented: $showEditScreen, content: {
//      //      EditTaskView()
//                .environmentObject(DailyActivityViewModel())
//                .presentationDetents([.fraction(0.40), .medium])
//                .presentationDragIndicator(.visible)
//                .environmentObject(taskModel)
//        })
        
    }
}

struct CalenderView_Preview : PreviewProvider {
    static var previews: some View {
        CalenderView()
    }
}

extension CalenderView {
    @ViewBuilder
    var taskView: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: DailyEntity) in
                // MARK: add taskcardView here
                taskCardView(task: object)
            }
        }
    }
    @ViewBuilder
    func taskCardView(task: DailyEntity) -> some View {
        // MARK: Since CoreData Values will Give Optinal data
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top,spacing: 20) {
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active {
                // Edit Button for Current and Future Tasks
                VStack(spacing: 10) {
                    
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
            else {
                VStack(spacing: 10){
                    HStack(spacing: 10) {
                        
                        Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                            .foregroundStyle(.gray)
                            .fontWeight(.light)
                            .font(.headline)
                            .lineLimit(2)
                        
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(taskModel.categoryColor ?? "lightGreen" ))
                        .frame(width: 10, height: 68)

                 }
                }
                .padding(.horizontal, 10)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack() {
                    Button(action: {
                        task.isCompleted.toggle()
                        
                      //  taskModel.editTask?.isCompleted.toggle()
                        // MARK: - add save context here for checkmark square to work
                        saveContext()
                    }
                           , label: {
                        Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                            .font(.title2)
                            .foregroundColor(Color.blue)
                    })
                    .buttonStyle(.plain)
                    
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
extension CalenderView {
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

extension CalenderView {
    @ViewBuilder
    func headerViewCalenderView() -> some View {
        VStack(alignment: .leading, spacing: -8) {
            HStack(spacing: 5) {
                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 20)
//
//                Image(systemName: "calendar")
//                    .font(.title)
//                    .foregroundColor(Color.gray)
//                    .overlay {
//                        DatePicker("", selection: $taskModel.currentDay, displayedComponents: [.date])
//                            .blendMode(.destinationOver)
//                    }
                
                Button(action: {
                    taskModel.backwardToLastWeek()
                }, label: {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 36, design: .rounded))
                        .fontWeight(.light)
                        .foregroundStyle(Color.black).opacity(0.5)
                        .shadow(radius: 5)
                })
                .padding(.horizontal, 10)
                
                Text("\(taskModel.fetchMonthName(from: taskModel.currentDay))")
                    .font(.title)
                    .fontWeight(.medium)
                    .lineLimit(2)
                //    .offset(x: 50)
                 
                
                Button(action: {
                    taskModel.forwardToNextWeek()
                }, label: {
                    Image(systemName: "chevron.right.circle")
                        .font(.system(size: 36, design: .rounded))
                        .fontWeight(.light)
                        .foregroundStyle(Color.black).opacity(0.5)
                        .shadow(radius: 5)
                })
                      .offset(x: 10)
       
            }
            .padding(.vertical, -6)
            // MARK: Set the Today, Calender down
            
            .padding(.horizontal, 20)
            
            HStack() {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
                    .font(.title3)
                    .padding(.horizontal, 42)
                
                    .padding(.vertical, 16)
        
            }
            
            // MARK: Weekly Calender HStack
            HStack(alignment:.center, spacing: 19) {
                ForEach(taskModel.currentWeek, id: \.self) { calendar in
                    VStack(spacing: 12) {
                        if taskModel.isToday(date: calendar) {
                            
                            Text(calendar.toString("EEE").uppercased())
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .foregroundColor(Color.black)
                            
                            Text(calendar.toString("dd"))
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.yellow)
                            
                                .overlay {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 50, height: 50)
                                        .opacity(0.2)
                                }
                            HStack {
//                                    Circle()
//                                        .fill(Color(#colorLiteral(red: 0.188606687, green: 0.8337081755, blue: 0.2263193202, alpha: 1)))
//                                        .frame(width: 10, height: 10)
//                                        .padding(.horizontal, 10)
                                    Circle()
                                  //  .fill(Color(taskModel.editTask?.categoryColor ?? ""))
                                    .fill(Color(.lightBlue))
                                       // .fill(Color(taskModel.categoryColor))
                                        .frame(width: 10, height: 10)
                                        .offset(x:0)
                                
                            }
                        } else {
                            Text(calendar.toString("EEE").uppercased())
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)

                            Text(calendar.toString("dd"))
                                .font(.title)
                                .fontWeight(.medium)
                            
                            // MARK: Add color category here
                            HStack() {
                                Circle()
                                    .fill(.clear)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .foregroundColor(taskModel.isToday(date: calendar) ? .yellow : .secondary)
                    // MARK: Capsule Shape
                
                    .contentShape(Capsule())
                    .onTapGesture {
                        taskModel.currentDay = calendar
                    }
                }
            }
            .padding(.leading)
            .padding(.horizontal , 40)
        }
    
        
        .frame(width: 460, height: 230, alignment: .bottomLeading)
        // MARK: Ipad frame and dimension
     //   .frame(minWidth: 600, minHeight: 230, alignment:. leading)
     
        .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
        
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        .ignoresSafeArea(.all, edges: .top)
        .padding()
    

    }
}


