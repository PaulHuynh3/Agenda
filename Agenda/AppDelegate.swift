//
//  AppDelegate.swift
//  Agenda
//
//  Created by Paul on 2019-05-04.
//  Copyright © 2019 PaulsWork. All rights reserved.
//

import UIKit
import AWSAppSync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appSyncClient: AWSAppSyncClient?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAWSAppSync()
        return true
    }

    private func setupAWSAppSync() {
        do {
            let cacheConfiguration = try AWSAppSyncCacheConfiguration()
            let appSyncServiceConfig = try AWSAppSyncServiceConfig()
            let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncServiceConfig: appSyncServiceConfig,
                                                                  cacheConfiguration: cacheConfiguration)
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        } catch {
            print("Error initializing appsync client. \(error)")
        }
    }
    

}

