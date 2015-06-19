//
//  Appearance.swift
//  Pretto
//
//  Created by Francisco de la Pena on 6/18/15.
//  Copyright (c) 2015 Pretto. All rights reserved.
//

import UIKit

class GlobalAppearance {
    class func setNavBarAppearance() {
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barStyle = UIBarStyle.Default
//        UINavigationBar.appearance().barTintColor = UIColor.prettoWhite()
        
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navBarBackground")!, forBarMetrics: .Default)
//        UINavigationBar.appearance().backgroundColor = UIColor.orangeColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    
    class func setTabBarAppearance() {
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barStyle = UIBarStyle.Default
//        UITabBar.appearance().barTintColor = UIColor.orangeColor()
        
        
        UITabBar.appearance().tintColor = UIColor.prettoRed()

       UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().backgroundColor = UIColor.orangeColor()
//        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "TabBarSelected")

    }
    
    class func setTableViewAppearance() {
        UISearchBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        UISearchBar.appearance().translucent = false
        UISearchBar.appearance().barTintColor = UIColor.clearColor()
        UISearchBar.appearance().backgroundColor = UIColor.clearColor()

    }
    
    class func setAll() {
        setNavBarAppearance()
        setTabBarAppearance()
        setTableViewAppearance()
    }
}

extension UIColor {
    class func prettoWhite() -> UIColor {
//        return UIColor(red: (224.0 / 255.0), green: (226.0 / 255.0), blue: (212.0 / 255.0), alpha: 1)
        return UIColor(red: (255.0 / 255.0), green: (255.0 / 255.0), blue: (255.0 / 255.0), alpha: 1)
    }
    
    class func prettoRed() -> UIColor {
        return UIColor(red: (255.0 / 255.0), green: (104.0 / 255.0), blue: (79.0 / 255.0), alpha: 1)
    }
}