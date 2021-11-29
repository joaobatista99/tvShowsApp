//
//  AppDelegate.swift
//  MovieApp
//
//  Created by João Victor Batista on 25/11/21.
//

import UIKit
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let showsNavigationController = UINavigationController()
        let showsListViewController = TvShowsListViewController(nibName: String(describing: TvShowsListViewController.self), bundle: nil)
        showsNavigationController.viewControllers = [showsListViewController]
        
        let favoriteShowsNavigationController = UINavigationController()
        let favoriteShowsViewController = FavoriteTvShowsViewController(nibName: String(describing: FavoriteTvShowsViewController.self), bundle: nil)
        favoriteShowsViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "heartIcon"), selectedImage: UIImage(named: "selectedHeartIcon"))
        favoriteShowsNavigationController.viewControllers = [favoriteShowsViewController]
        
        let peopleNavigationController = UINavigationController()
        let peopleViewController = PeopleViewController()
        peopleViewController.tabBarItem = UITabBarItem(title: "People", image: UIImage(named: "peopleIcon"), selectedImage: UIImage(named: "selectedPeopleIcon"))
        peopleNavigationController.viewControllers = [peopleViewController]

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [showsNavigationController, favoriteShowsNavigationController, peopleNavigationController]
        
        let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Allow the app to use TouchID to authenticate."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        if success {
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            self.window?.backgroundColor = UIColor.white
                            
                            if #available(iOS 13.0, *) {
                                self.window?.overrideUserInterfaceStyle = .light
                            }
                            
                            self.window?.rootViewController = tabBarController
                            self.window?.makeKeyAndVisible()
                        } else {
                            
                        }
                    }
                }
            } else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.backgroundColor = UIColor.white
                if #available(iOS 13.0, *) {
                    self.window?.overrideUserInterfaceStyle = .light
                }
                self.window?.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }

        return true
    }


}

