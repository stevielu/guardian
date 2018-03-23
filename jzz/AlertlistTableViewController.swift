//
//  AlertlistTableViewController.swift
//  jzz
//
//  Created by wei lu on 21/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class AlertlistTableViewController: UITableViewController {
    var list:[AlertData]!
    var server:ServiceDataProcess!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.list = [AlertData]()
        self.server = ServiceDataProcess()
        
        self.prepareUI()
        self.prepareTable()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getVictmList()
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.list.removeAll()
        self.tableView.reloadData()
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
        if(self.list.count > 0){
            return self.list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as? AlertCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = globalStyle.backgroundColor
        cell.cellTitle.text = self.list?[indexPath.row].FullName
        cell.cellGender.text = self.list?[indexPath.row].Gender
        cell.cellGender.font = globalStyle.tinytitleFont
        cell.cellAge.font = globalStyle.tinytitleFont
        cell.cellAge.text = "Age " + String(self.list![indexPath.row].Age!)
        cell.accessoryType = .disclosureIndicator
        if let avatar = self.list?[indexPath.row].ProfilePhoto{
            if(avatar.isEmpty){
                cell.avatar.image = UIImage(named: "avatar")
            }else{
                let avatarUrl = GET_AVATAR + "/" + avatar
                self.server.retrieveCellImg(ImgURL: avatarUrl, image: cell.avatar, completion: {ret in
                    print(ret!)
                })
            }
            
            
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.deleteAlert(indexPath: indexPath)
            self.list!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showVictim", sender: self.list?[indexPath.row])
    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showVictim"){
            let path = self.tableView.indexPathForSelectedRow!
            let currentCell = self.tableView.cellForRow(at: path) as! AlertCell
            
            if let controller = segue.destination as? VictimViewController{
                controller.data =  self.list![path.row]
                controller.victimAvatar = currentCell.avatar.image
            }
            
        }
    }
        
    // MARK: -  SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        let header = AlertTableHeader(frame: self.view.frame, profile: UIImage(named: "victim_list")!)
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Victim List"
        self.tableView.backgroundColor = globalStyle.backgroundColor
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = header
        
        self.tableView.tableHeaderView?.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.height.equalTo(95)
            
        }
    }
    
    @objc fileprivate func prepareTable(){
        self.tableView.register(AlertCell.self, forCellReuseIdentifier: "AlertCell")
    }
    
    
    
    @objc fileprivate func getVictmList(){
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
        if user.isEmpty{
            return
        }
        
        let data = httpData()
        data.Httpmethod = .post
        data.data = ["UserName":user]
        self.pleaseWait()
        self.server.httpAct(requestUrl: GET_ALERTS, Senddata: data, completion: {ret in
            let json = JSON(ret)
            self.clearAllNotice()
            
            if(json.array == nil){
                return
            }
            
            for value in json.array! {
                let new = AlertData(JSONData: value)
                self.list.append(new)
            }
            self.tableView.reloadData()
            
            
            
        })
    }
    
    @objc fileprivate func deleteAlert(indexPath: IndexPath){
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
        if user.isEmpty{
            return
        }
        
        let data = httpData()
        data.Httpmethod = .post
        data.data = [
            "AlertId":String(describing: self.list[indexPath.row].ID!),
            "Status":"Delete"
        ]
        self.pleaseWait()
        self.server.httpAct(requestUrl: UPDATE_ALERTS, Senddata: data, completion: {ret in
            self.clearAllNotice()
        })
    }

}
