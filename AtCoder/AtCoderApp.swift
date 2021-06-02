//
//  AtCoderApp.swift
//  AtCoder
//
//  Created by Shota Kashihara on 2021/06/02.
//

import SwiftUI

@main
struct AtCoderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
