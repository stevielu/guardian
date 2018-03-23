//
//  PeripheralsListTableViewController.swift
//  jzz
//
//  Created by wei lu on 19/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore
import SnapKit

class PeripheralsListTableViewController: UITableViewController {
    var nearbyPeripherals : [CBPeripheral] = []
    var nearbyPeripheralInfos : [CBPeripheral:Dictionary<String, AnyObject>] = [CBPeripheral:Dictionary<String, AnyObject>]()
    var bluetoothManager:BluetoothManager!
    var connectingView : ConnectingView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.register(NearbyPeripheralCell.self, forCellReuseIdentifier: "NearbyPeripheralCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.layer.cornerRadius = 6.0
        self.tableView.clipsToBounds = true
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
        if section == 0 {
            return nearbyPeripherals.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = nearbyPeripherals[(indexPath as NSIndexPath).row]
        connectingView = ConnectingView.showConnectingView()
        connectingView?.tipNameLbl.text = peripheral.name
        bluetoothManager.connectPeripheral(peripheral)
        bluetoothManager.stopScanPeripheral()
        self.buttonTapped()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyPeripheralCell") as? NearbyPeripheralCell
            let peripheral = nearbyPeripherals[(indexPath as NSIndexPath).row]
            let peripheralInfo = nearbyPeripheralInfos[peripheral]
            
            cell?.yPeripheralNameLbl.text = peripheral.name == nil || peripheral.name == ""  ? "Unnamed" : peripheral.name
            
            let serviceUUIDs = peripheralInfo!["advertisementData"]!["kCBAdvDataServiceUUIDs"] as? NSArray
//            if serviceUUIDs != nil && serviceUUIDs?.count != 0 {
//                cell?.yServiceCountLbl.text = "\((serviceUUIDs?.count)!) service" + (serviceUUIDs?.count > 1 ? "s" : "")
//            } else {
//                cell?.yServiceCountLbl.text = "No service"
//            }
            
            // The signal strength img icon and the number of signal strength
            let RSSI = peripheralInfo!["RSSI"]! as! NSNumber
           // cell?.ySignalStrengthLbl.text = "\(RSSI)"
            switch labs(RSSI.intValue) {
            case 0...40:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_5")
            case 41...53:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_4")
            case 54...65:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_3")
            case 66...77:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_2")
            case 77...89:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_1")
            default:
                cell?.ySignalStrengthImg.image = UIImage(named: "signal_strength_0")
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50.0
//    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = tableView.frame
        
        
        let DoneBut: UIButton = UIButton() //
        DoneBut.setTitle("Close", for: .normal)
        DoneBut.setTitleColor(globalStyle.buttonFillColorBlue, for: .normal)
//        DoneBut.setImage(UIImage(named:"closebutton"), for: .normal)
//        DoneBut.imageView?.contentMode = .scaleAspectFit
        DoneBut.layer.zPosition = 99
        DoneBut.addTarget(self, action: #selector(self.buttonTapped), for: .touchDown)
        
        
        
        
        let headerView: UIView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:tableView.frame.size.height))
        headerView.backgroundColor = globalStyle.backgroundColor
        headerView.addSubview(DoneBut)
        
        DoneBut.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView.snp.centerY)
            make.right.equalTo(headerView.snp.right).offset(-12.5)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
            
        return headerView
    }
    
    
    func buttonTapped(){
        self.view.removeFromSuperview()
    }
    // The tableview group header view
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
//        
//        let lblTitle = UILabel(frame: CGRect(x: 20, y: 2, width: 120, height: 21))
//        lblTitle.font = UIFont.boldSystemFont(ofSize: 12)
//        lblTitle.text = "Peripherals Nearby"
//        headerView.backgroundColor = UIColor.white
//        headerView.addSubview(lblTitle)
//        return headerView
//    }

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

}
