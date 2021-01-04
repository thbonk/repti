//
//  AppDelegate.swift
//  Repti
//
//  Created by Thomas Bonk on 03.01.21.
//
//  Copyright 2021 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

import UIKit
import CoreData
import Swinject

var container: Container = {
  let container = Container()

  container.register(PersistentContainer.self) { _ in PersistentContainer() }

  return container
}()

func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service? {
  return container.resolve(serviceType, name: name)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - UIApplicationDelegate

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }


  // MARK: - UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let config = UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)

    config.sceneClass = UIWindowScene.self
    config.delegateClass = SceneDelegate.self
    
    if UIDevice.current.userInterfaceIdiom == .phone {
      config.storyboard = UIStoryboard(name: "Main-iPhone", bundle: nil)
    } else {
      config.storyboard = UIStoryboard(name: "Main-iPad", bundle: nil)
    }

    return config
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

