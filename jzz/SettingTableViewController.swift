//
//  SettingTableViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
class SettingTableViewController: UITableViewController {
    var setting:SettingData!
    var head:SettingHead!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting = SettingData()
        
        self.prepareUI()
        self.tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            if (setting != nil) {
                return setting.attribute[0].count
            } else {
                return 0
            }
        }
        return setting.attribute == nil ? 0 : setting.attribute[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = globalStyle.backgroundColor
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.cellTitle.text = setting.attribute[0][indexPath.row]
            cell.accessoryType = .disclosureIndicator
        } else {
            let attribute = setting.attribute[indexPath.section][(indexPath as NSIndexPath).row]
            cell.cellTitle.text = attribute
            
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            self.performSegue(withIdentifier: self.setting.attribute[indexPath.section][indexPath.row], sender: self)
        }else{
            let logout = LogoutAlert()
            LogoutAlert.showLogoutAlert("Logout", message: "Are you sure to log out", cancelTitle: "Cancel", viewController: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Emergency Contact"){
            
            if let controller = segue.destination as? AddFriendsViewController{
                controller.fromSetting = true
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc fileprivate func prepareUI() {
        self.view.backgroundColor = globalStyle.backgroundColor
        self.navigationItem.title = "Setting"
        //head = SettingHead(frame: self.tableView.frame, profile: UIImage(named:"4-1")!)
        self.tableView.tableFooterView = UIView()
        var headerView: UIView = UIView(frame: CGRect(x:globalStyle.screenSize.width/2 - 27.5, y:25, width:55, height:95))
        var imageView: UIImageView = UIImageView(frame: CGRect(x:globalStyle.screenSize.width/2 - 25, y:25, width:50, height:50))
        imageView.image = UIImage(named: "4-1")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        
        self.tableView.tableHeaderView = headerView

    }
}
