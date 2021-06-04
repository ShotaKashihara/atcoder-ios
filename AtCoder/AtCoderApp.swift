//
//  AtCoderApp.swift
//  AtCoder
//
//  Created by Shota Kashihara on 2021/06/02.
//

import SwiftUI

@main
struct AtCoderApp: App {

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some Scene {
        WindowGroup {
            StreakView(size: .last7Weeks)
                .onChange(of: scenePhase, perform: { value in
                    switch value {
                    case .background:
                        break
                    case .inactive:
                        break
                    case .active:
                        print("active")
                        SharedUserDefaults.userId = "kashihararara"
                        break
                    @unknown default:
                        break
                    }
                })
        }
    }
}
