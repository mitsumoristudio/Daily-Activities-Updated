//
//  EditTaskView.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI


struct EditTaskView: View {
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var taskModel: DailyActivityViewModel
    @State var animate: Bool = false
    @Environment(\.dismiss) var dismiss
    var backgroundGradientlight =  Color(#colorLiteral(red: 0.904727757, green: 0.9161171317, blue: 0.9159168601, alpha: 1))
    @Environment(\.editMode) var editButton
    
    
    // MARK: Fixed Properties
    var todaysDate: String = "4/16/24"
    var datetime: String = "8:00 AM"
    var categorytitle: String = "Daily Task"
    var subcategorytitle: String = "Finish the edit button"
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradientlight
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 15) {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(#colorLiteral(red: 0.7179782391, green: 0.7243052721, blue: 0.7161567807, alpha: 1)))
                            .overlay {
                                Image(systemName: "alarm.fill")
                                    .foregroundColor(Color.cyan)
                                    .font(.title)
                            }
                        Text("Configure Activity")
                            .font(.title3)
                            .fontWeight(.bold)
                     
                        VStack(alignment: .leading, spacing: 5) {
                            taskHeader(tasks: DailyEntity(context: context))
                        
                        }
                    }
                    Rectangle()
                        .fill(.black.opacity(0.8))
                        .frame(height: 1)
                        
                        .padding()
                    
                  // MARK: Add Custom bottom font here
                    HStack(alignment: .center, spacing: 16) {
                        
                        Button(action: {
                            EditButton()
                            
                        }, label: {
                            buttonStyleCustom(withplaceholder: "Edit Activity", imageName: "pencil.tip.crop.circle.badge.plus")
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            buttonStyleCustom(withplaceholder: "Finish", imageName: "checkmark.square.fill")
                        })
                        
                        Button(action: {
                            
                        }, label: {
                          
                            buttonStyleCustom(withplaceholder: "Erase", imageName: "trash.circle")
                        })
   
                    }
                Spacer()
                }
                
                .padding()
            }
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss()
            }, label: {
              Image(systemName: "x.circle.fill")
                    .foregroundColor(Color.black)
                    .opacity(0.8)
                    .padding()
                    .font(.system(size: 32, design: .rounded))
                  
            }
            )
            .offset(y: -10)
        }
    }
}

struct EditTask_Preview: PreviewProvider {
    static var previews: some View {
        EditTaskView().environmentObject(DailyActivityViewModel())
    }
}

extension EditTaskView {
    @ViewBuilder
    func buttonStyleCustom(withplaceholder placeholder: String, imageName: String) -> some View {
 
            VStack(alignment: .center, spacing: 10) {
                
                Image(systemName: imageName)
                    .font(.system(size: 30, design: .rounded))
                    .foregroundColor(Color.indigo)
                Text(placeholder)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.black)
                    .lineLimit(2)
            }
            
            .frame(width: 110, height: 100)
            .background(VisualEffectBlur(blurStyle: .systemChromeMaterial))
            .shadow(radius: 5)
            .clipShape(RoundedRectangle(cornerRadius: 30))
      
    }
    
    @ViewBuilder
    var dynamicView: some View {
        LazyVStack(spacing: 10) {
       
        }
    }
    
    @ViewBuilder
    func taskHeader(tasks: DailyEntity) -> some View {
        HStack() {
            Text(tasks.taskDate?.formatted(date: .abbreviated, time: .omitted) ?? "")
                .fontWeight(.light)
                .foregroundStyle(Color.secondary)
                .font(.callout)
            Text(tasks.taskDate?.formatted(date: .omitted, time: .standard) ?? "")
                .fontWeight(.light)
                .foregroundStyle(Color.secondary)
                .font(.callout)
        }
        Text(tasks.taskTitle ?? "")
            .font(.title3)
            .fontWeight(.bold)
        
        Text(tasks.taskDescription ?? "")
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundStyle(Color.secondary)
        
    }
    
}

