//
//  AppDelegate.swift
//  Agents Partner
//
//  Created by Mohaiminul Islam on 5/18/16.
//  Copyright © 2016 infancyit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    let greenColor = UIColor(red:0, green:0.407, blue:0.215, alpha:1)
    UITextField.appearance().tintColor = greenColor
    UITextView.appearance().tintColor = greenColor
    
    return true
  }
}

extension UINavigationController {
  public override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}

extension UISearchController {
  public override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
}

