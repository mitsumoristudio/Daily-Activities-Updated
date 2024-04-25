//
//  MainTabView.swift
//  DailyActivities 4.25
//
//  Created by Satoshi Mitsumori on 4/25/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        NavigationStack {
            VStack() {
                TabView {
                    CalenderView()
                        .tabItem {
                            VStack() {
                                Image(systemName: "calendar.circle.fill")
                                Text("Weekly Calendar")
                            }
                        }
                        .tag(0)
                    
                    WeeklyAgenda()
                        .tabItem {
                            VStack() {
                                Image(systemName: "list.bullet.circle")
                                Text("Upcoming")
                            }
                        }
                        .tag(1)
                }
            }
        }
    }
}
