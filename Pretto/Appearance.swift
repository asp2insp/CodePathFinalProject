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
        UINavigationBar.appearance().barTintColor = UIColor.prettoBlue()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBarBGBlue")!, forBarMetrics: .Default)
//        UINavigationBar.appearance().backgroundColor = UIColor.orangeColor()
        UINavigationBar.appearance().shadowImage = UIImage()
        
    }
    
    class func setTabBarAppearance() {
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barStyle = UIBarStyle.Default
//        UITabBar.appearance().barTintColor = UIColor.orangeColor()
        
        
        UITabBar.appearance().tintColor = UIColor.prettoBlue()

       UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().backgroundColor = UIColor.orangeColor()
//        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "TabBarSelectedBlue")

    }
    
    class func setTableViewAppearance() {
        UISearchBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        UISearchBar.appearance().translucent = false
        UISearchBar.appearance().barTintColor = UIColor.clearColor()
        UISearchBar.appearance().backgroundColor = UIColor.clearColor()

    }
    
    class func setSearchBarAppearance() {
        UISearchBar.appearance().backgroundColor = UIColor.prettoBlue()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        
        
        UISearchBar.appearance().setImage(UIImage(named: "TabBarSearchIcon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        UISearchBar.appearance().setImage(UIImage(named: "TabBarSearchIcon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Highlighted)
        UISearchBar.appearance().setImage(UIImage(named: "CancelSearchButton"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Normal)
        UISearchBar.appearance().setImage(UIImage(named: "CancelSearchButton"), forSearchBarIcon: UISearchBarIcon.Clear, state: UIControlState.Highlighted)
    }
    
    class func setAll() {
        setNavBarAppearance()
        setTabBarAppearance()
        setTableViewAppearance()
        setSearchBarAppearance()
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
    
    class func prettoBlue() -> UIColor {
        return UIColor(red: (81.0 / 255.0), green: (179.0 / 255.0), blue: (193.0 / 255.0), alpha: 1)
    }
    
    class func prettoDarkBlue() -> UIColor {
        return UIColor(red: (54.0 / 255.0), green: (158.0 / 255.0), blue: (72.0 / 255.0), alpha: 1)
    }
    
    class func prettoIntroBlue() -> UIColor {
        return UIColor(red: (74.0 / 255.0), green: (144.0 / 255.0), blue: (226.0 / 255.0), alpha: 1)
    }
    
    class func prettoOrange() -> UIColor {
        return UIColor(red: (245.0 / 255.0), green: (166.0 / 255.0), blue: (35.0 / 255.0), alpha: 1)
    }
    
    class func prettoIntroOrange() -> UIColor {
        return UIColor(red: (253.0 / 255.0), green: (172.0 / 255.0), blue: (81.0 / 255.0), alpha: 1)
    }
    
    class func prettoIntroGreen() -> UIColor {
        return UIColor(red: (64.0 / 255.0), green: (186.0 / 255.0), blue: (145.0 / 255.0), alpha: 1)
    }
    
    class func prettoLightGrey() -> UIColor {
        return UIColor(red: (238.0 / 255.0), green: (238.0 / 255.0), blue: (238.0 / 255.0), alpha: 1)
    }
}