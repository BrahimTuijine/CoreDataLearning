//
//  CoreDataLearningApp.swift
//  CoreDataLearning
//
//  Created by MacBook on 24/10/2024.
//

import SwiftUI

@main
struct CoreDataLearningApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
