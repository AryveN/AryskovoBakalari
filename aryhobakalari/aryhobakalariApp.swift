//
//  aryhobakalariApp.swift
//  aryhobakalari
//
//  Created by Krystof Hugo Maly on 09.09.2022.
//
//

import SwiftUI
import BackgroundTasks
import os

func scheduleBackgroundTask() {
    // Request type aligned with background notifications
    let request = BGAppRefreshTaskRequest(identifier: "com.aryven.uwuzvrh_notifications")
    request.earliestBeginDate = .now.addingTimeInterval(10)
    do {
        try? BGTaskScheduler.shared.submit(request)
        print("Background Task Scheduled (identifier: \(request.identifier))")
    } catch {
        print("Error scheduling background task: \(error.localizedDescription)")
    }
}

@main
struct aryhobakalariApp: App {   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .background: scheduleBackgroundTask()
            default: break
            }
        }
        .backgroundTask(.appRefresh("com.aryven.uwuzvrh_notifications")) {
            let logger = Logger()
            let notif = NotificationScheduler()
            notif.scheduleNotificationsBackgroundTask()
        }
    }
}
