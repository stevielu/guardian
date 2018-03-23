//
//  PersonalSettingTableViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit

class PersonalSettingTableViewController: UITableViewController {

    var personal:PersonalData!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personal = PersonalData()
        
        self.prepareUI()
        self.tableView.register(PersonalCell.self, forCellReuseIdentifier: "PersonalCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfile()
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
        return personal.attribute == nil ? 0 : personal.attribute.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalCell", for: indexPath) as? PersonalCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = globalStyle.backgroundColor
        let title = Array(personal.attribute.keys)[indexPath.row]
        let value = personal.attribute[title]!["Value"]
        cell.cellTitle.text = title
        cell.cellValue.text = value as? String
        
        if(personal.attribute[title]!["Editable"] as! Bool == false){
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
        }else{
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:"EditPersonalSettingValue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditPersonalSettingValue"){
            
            if let controller = segue.destination as? EditValueViewController{
                controller.user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
                let key = Array(self.personal.attribute.keys)[tableView.indexPathForSelectedRow!.row]
                let array = self.personal.attribute[key]
                controller.value = array
                controller.key = key
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
        let headerView: UIView = UIView(frame: CGRect(x:globalStyle.screenSize.width/2 - 27.5, y:25, width:55, height:95))
        let imageView: UIImageView = UIImageView(frame: CGRect(x:globalStyle.screenSize.width/2 - 25, y:25, width:50, height:50))
        imageView.image = UIImage(named: "4-1")
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        
        self.tableView.tableHeaderView = headerView
        
    }
    
    fileprivate func getProfile(){
        if let user = UserDefaults.standard.object(forKey: "ActiveUser") as? String{
            let model = ProfileModel(user: user)
            if let data = model.get(){
                personal.attribute["FullName"]!["Value"] = data.FullName
                personal.attribute["Gender"]!["Value"] = data.Gender
                personal.attribute["Age"]!["Value"] = String(data.Age)
                personal.attribute["Mobile"]!["Value"] = String(data.Mobile)
                personal.attribute["Email"]!["Value"] = data.Email
                personal.attribute["Address"]!["Value"] = data.Address
                self.tableView.reloadData()
            }
            
        }
        
        
    }

}
