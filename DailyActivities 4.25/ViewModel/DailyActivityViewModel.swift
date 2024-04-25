//
//  DailyActivityViewModel.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI
import CoreData

class DailyActivityViewModel: ObservableObject {
    // Current Week Days
    @Published var currentWeek: [Date] = []
    // Current Day
    @Published var currentDay: Date = Date()
    // Filtering Todays Tasks
    @Published var filteredActivites: [DailyEntity]?
    // Add next activities
    @Published var addNewActivity: Bool = false
    // MARK: Edit Data
    @Published var editActivity: DailyEntity?
    
    @Published var currentTab: String = "Today"
    
    // MARK: Set categoryColor
    @Published var categoryColor: String = "lightBlack"
    
    init() {
        fetchWeeks(Date())
        
    }
    
    var isCurrentWeekContainsToday: Bool {
        let calendar = Calendar.current
        
        return currentWeek.contains { day in
            calendar.isDateInToday(day)
        }
    }
    
    func fetchMonthName(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
        
    }
    
    func forwardToNextWeek() {
        let calendar = Calendar.current
        if let lastWeekDay = currentWeek.last, let nextWeekStartDay = calendar.date(byAdding: .day, value: 1, to: lastWeekDay) {
            fetchWeeks(nextWeekStartDay)
            currentDay = nextWeekStartDay
        }
    }
    
    func backwardToLastWeek() {
        let calendar = Calendar.current
        if let firstWeekDay = currentWeek.first, let lastWeekStartDay = calendar.date(byAdding: .day, value: -7, to: firstWeekDay) {
            withAnimation(.easeInOut(duration: 0.3)) {
                fetchWeeks(lastWeekStartDay)
                currentDay = lastWeekStartDay
                
                if let day = currentWeek.first(where: { day in
                    calendar.isDateInToday(day)
                }) {
                    currentDay = day
                }
            }
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
        
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
        
    }
    
    // MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date)->Bool{
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour && isToday)
    }
    
    
    func fetchWeeks(_ start: Date) {
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: start)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        currentWeek = []
        (0..<7).forEach { days in
            if let weekday = calendar.date(byAdding: .day, value: days, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
        
    }
}
