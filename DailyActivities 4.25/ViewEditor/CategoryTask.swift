//
//  CategoryTask.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI


struct CategoryTask: View {
    var backgroundGradientlight =  Color(#colorLiteral(red: 0.6353988978, green: 0.7347068722, blue: 0.756063881, alpha: 0.6174461921))
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var dateSelect: Date = Date()
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var taskModel: DailyActivityViewModel
    @State var animate: Bool = false
    @Environment(\.dismiss) var dismiss
    
    // MARK: Color selection
         let colors: [String] = ["lightBlue", "lightGreen", "lightOrange", "lightPurple", "lightRed", "lightYellow"]
    
    func TitleView(_ value: String, _ color: Color = .white.opacity(0.7)) -> some View {
        Text(value)
            .font(.system(size: 16))
            .foregroundColor(color)
            .fontWeight(.semibold)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradientlight
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    TitleView("Daily Activity")
                    
                    TextField("Enter Activity", text: $taskTitle)
                        .font(.headline)
                        .padding(.top, 2)
                        .foregroundColor(Color.white)
                        .modifier(TextFieldClearButton(nextText: $taskTitle))
                    
                    Rectangle()
                        .fill(.white.opacity(0.8))
                        .frame(height: 1)
                    
                    TitleView("Description")
                    
                    TextField("Enter Description", text: $taskDescription)
                        .font(.headline)
                        .padding(.top, 2)
                        .foregroundColor(Color.white)
                        .modifier(TextFieldClearButton(nextText: $taskDescription))
                    
                    Rectangle()
                        .fill(.white.opacity(0.8))
                        .frame(height: 1)
                    
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 15) {
                        ForEach(colors, id: \.self) { color in
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(color))
                                .frame(width: 25, height: 25)
                                .background {
                                    if taskModel.categoryColor == color {
                                        Circle()
                                            .strokeBorder( Color.blue)
                                            .padding(-5)
                                            .fontWeight(.bold)
                                    }
                                }
                                .contentShape(RoundedRectangle(cornerRadius: 20))
                                .onTapGesture {
                                    taskModel.categoryColor = color
                                }
                        }
                    }
                    
                    
                    TitleView("Date")
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        HStack(spacing: 12) {
                            Text(dateSelect.toString("EEEE dd, MMMM"))
                                .font(.subheadline)
                            
                            Image(systemName: "calendar")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .overlay {
                                    DatePicker("", selection: $dateSelect, displayedComponents: [.date])
                                        .blendMode(.destinationOver)
                                }
                        }
                        .offset(y: -5)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.white.opacity(0.8))
                                .frame(height: 1)
                                .offset(y: 5)
                            
                        }
                        
                        HStack(spacing: 12) {
                            Text(dateSelect.toString("hh:mm a"))
                                .font(.subheadline)
                            
                            Image(systemName: "clock")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .overlay {
                                    DatePicker("", selection: $dateSelect, displayedComponents: [.hourAndMinute])
                                        .blendMode(.destinationOver)
                                }
                        }
                        .offset(y: -5)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(.white.opacity(0.8))
                                .frame(height: 1)
                                .offset(y: 5)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            // MARK: This must be added to edit the task
                            if let task = taskModel.editActivity {
                                task.taskTitle = taskTitle
                                task.taskDescription = taskDescription
                                
                            } else {
                                let task = DailyEntity(context: context)
                                task.taskTitle = taskTitle
                                task.taskDescription = taskDescription
                                task.taskDate = dateSelect
                            }
        
                            // MARK: Save Data
                            try? context.save()
                         
                            print(taskTitle)
                            print(taskDescription)
                            print(dateSelect)
                            
                            dismiss()
                            
                        }, label: {
                            Text("Submit")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.white)
                                .frame(width: 160, height: 46, alignment: .center)
                                .background(.black)
                                .cornerRadius(20)
                                .padding(.vertical, 5)
                        })
                        .disabled(taskDescription == "" || animate)
                        .opacity(taskDescription == "" ? 0.5: 1)
                    }
                    .padding()
                    .padding(.horizontal, 80)
                   Spacer()

                }
                .padding()
            }
        }
        // MARK: - Edit Items from taskDescription
        .onAppear {
            if let tasks = taskModel.editActivity {
                taskTitle = tasks.taskTitle ?? ""
                taskDescription = tasks.taskDescription ?? ""
            }
        }
        
        
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss()
            }, label: {
              Image(systemName: "x.circle.fill")
                    .foregroundColor(Color.white)
                    .padding()
                    .font(.system(size: 32, design: .rounded))
                  
            }
            )
            .offset(y: -10)
           
        }
        
    }
    }

struct CategoryTask_Preview: PreviewProvider {
    static var previews: some View {
        CategoryTask().environmentObject(DailyActivityViewModel())
    }
}

