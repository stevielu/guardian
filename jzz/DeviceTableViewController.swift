//
//  DeviceTableViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit

class DeviceTableViewController: UITableViewController {
    var device:DeviceData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.device = DeviceData()
        self.prepareTable()
        self.prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.device.attribute.count > 0){
            return self.device.attribute.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DeviceCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = globalStyle.backgroundColor
        cell.cellTitle.text = self.device.attribute[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.device.attribute[indexPath.row], sender: self)
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
    
    // MARK: -  SetUp
    @objc fileprivate func prepareTable(){
        self.tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
    }

    
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Device Setting"
        self.tableView.tableFooterView = UIView()
        var headerView: UIView = UIView(frame: CGRect(x:globalStyle.screenSize.width/2 - 27.5, y:25, width:55, height:95))
        var imageView: UIImageView = UIImageView(frame: CGRect(x:globalStyle.screenSize.width/2 - 25, y:25, width:50, height:50))
        imageView.image = UIImage(named: "3-1")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        
        self.tableView.tableHeaderView = headerView

    }

}
