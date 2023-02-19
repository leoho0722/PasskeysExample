//
//  SceneDelegate.swift
//  PasskeysExample
//
//  Created by Leo Ho on 2022/9/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        /* 純用 Xib 設計畫面要加下面這幾行，來指定第一個畫面 */
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootVC = PasskeysViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {

    // 當 App 有在後台時，才會觸發這個 Function
    // App 從後台滑掉，則不會觸發，需改用 willConnectTo 的方法來觸發
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        continueWithUniversalLinks(scene: scene, continue: userActivity)
    }
    
    func continueWithUniversalLinks(scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
            guard let webpageURL = userActivity.webpageURL else { return }
            print("webPageURL：", webpageURL.absoluteString)
            
            guard let components = NSURLComponents(url: webpageURL, resolvingAgainstBaseURL: true) else {
                print("Invalid components")
                return
            }
            guard let path = components.path else {
                print("Invalid components.path")
                return
            }
            guard let queryItems = components.queryItems else {
                print("Invalid components.queryItems")
                return
            }
            guard let uid = queryItems[0].value else {
                print("Invalid components.queryItems[0].value")
                return
            }
            guard let domain = queryItems[1].value else {
                print("Invalid components.queryItems[1].value")
                return
            }
            #if DEBUG
            print("path：\(path)")
            print("uid：\(uid)")
            print("domain：\(domain)")
            #endif
            
            Alert.showAlertWith(title: path,
                                message: "uid：\(uid)\ndomain：\(domain)",
                                vc: UIApplication.shared.topMostVisibleViewController!,
                                confirmTitle: "Close",
                                confirm: nil)
        }
    }
}
