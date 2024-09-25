//
//  MusicaApp.swift
//  Musica
//
//  Created by Michail on 25.09.24.
//

import SwiftUI

@main
struct MusicaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
