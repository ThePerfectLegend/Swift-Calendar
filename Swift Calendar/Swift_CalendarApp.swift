//
//  Swift_CalendarApp.swift
//  Swift Calendar
//
//  Created by Nizami Tagiyev on 19.01.2023.
//

import SwiftUI

@main
struct Swift_CalendarApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem { Label("Calendar", systemImage: "calendar") }
                    .tag(0)
                StreakView()
                    .tabItem { Label("Streak", systemImage: "swift") }
                    .tag(1)
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
