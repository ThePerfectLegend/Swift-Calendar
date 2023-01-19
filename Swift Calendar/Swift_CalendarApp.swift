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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
