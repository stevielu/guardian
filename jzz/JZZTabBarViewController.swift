//
//  JZZTabBarViewController.swift
//  jzz
//
//  Created by wei lu on 4/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit

class JZZTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UINavigationBar.appearance().barTintColor = globalStyle.backgroundColor
        UIApplication.shared.statusBarStyle = .lightContent
        

        
        
        let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: "TrackView") as! TrackViewController
        let homeNavController = UINavigationController(rootViewController:homeViewController)
        
        homeNavController.tabBarItem.image = UIImage(named: "1-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeNavController.tabBarItem.selectedImage = UIImage(named: "1-2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        let victmsViewController = self.storyboard!.instantiateViewController(withIdentifier: "VictimView") as! AlertlistTableViewController
        let victmmNavController = UINavigationController(rootViewController:victmsViewController)
        
        victmmNavController.tabBarItem.image = UIImage(named: "2-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        victmmNavController.tabBarItem.selectedImage = UIImage(named: "2-2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        victmmNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        let deviceViewController = self.storyboard!.instantiateViewController(withIdentifier: "DeviceView") as! DeviceTableViewController
        let deviceNavController = UINavigationController(rootViewController:deviceViewController)
        
        deviceNavController.tabBarItem.image = UIImage(named: "3-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        deviceNavController.tabBarItem.selectedImage = UIImage(named: "3-2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        deviceNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)

        let settingViewController = self.storyboard!.instantiateViewController(withIdentifier: "Setting") as! SettingTableViewController
        let settingNavController = UINavigationController(rootViewController:settingViewController)
        
        settingNavController.tabBarItem.image = UIImage(named: "4-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        settingNavController.tabBarItem.selectedImage = UIImage(named: "4-2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        settingNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)

        
       viewControllers = [homeNavController,victmmNavController,deviceNavController,settingNavController]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
