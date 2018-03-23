//
//  AlvaViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class AlvaViewController: UIViewController {
    var icon:SettingIcon!
    var mySwitch = UISwitch()
    var server:ServiceDataProcess!
    let bluetoothManager = BluetoothManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.icon = SettingIcon()
        self.server = ServiceDataProcess()
        self.prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.object(forKey: "Alarm") as? String{
            if(value == "True"){
                self.mySwitch.setOn(true, animated: true)
                self.mySwitch.isEnabled = true
            }
            else{
                self.mySwitch.setOn(false, animated: true)
                self.mySwitch.isEnabled = false
            }
        }else{
            self.mySwitch.setOn(false, animated: true)
            self.mySwitch.isEnabled = false
        }
        
    }
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
        self.navigationItem.title = "Alva Status"
        self.view.backgroundColor = globalStyle.backgroundColor
        let alarmLabel = self.icon.alarmaLabel
        view.addSubview(self.icon.head)
        view.addSubview(alarmLabel)
        view.addSubview(mySwitch)
        
        mySwitch.center = view.center
        mySwitch.setOn(false, animated: false)
        mySwitch.tintColor = globalStyle.backgroundColor
        mySwitch.onTintColor = globalStyle.buttonFillColorBlue
        mySwitch.backgroundColor = UIColor.gray
        mySwitch.layer.cornerRadius = 16.0
        mySwitch.thumbTintColor = UIColor.white
        mySwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.touchUpInside)
        
        
        self.icon.head.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(25)
            make.width.height.equalTo(65)
            
        }
        
        alarmLabel.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.icon.head.snp.bottom).offset(45)
            make.width.equalTo(105)
            make.height.equalTo(35)
            
        }
        
        mySwitch.snp.makeConstraints{(make) in
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.top.equalTo(self.icon.head.snp.bottom).offset(45)
            
        }
    }
    
    @objc fileprivate func switchChanged(){
            self.mySwitch.setOn(true, animated: true)
            self.popUpInput()
    }

    func popUpInput(){
        let alertController = UIAlertController(title: "Disable Alarm", message: "Please input your password to disable alarm", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if (alertController.textFields?[0]) != nil {
                // post your data
                let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
                self.verifyPass(userName: user, pass: alertController.textFields![0].text!)
            } else {
                // user did not fill field
                alertController.dismiss(animated: true, completion: nil)
                self.mySwitch.setOn(true, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.mySwitch.setOn(true, animated: true)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func verifyPass(userName:String,pass:String){
        let data = httpData()
        data.Httpmethod = .post
        data.data = [
            "Useraccount" : userName,
            "Password" : pass
        ]
        
        self.pleaseWait()
        
        server.httpAct(requestUrl: AUTH, Senddata: data, completion: {ret in
            
            self.clearAllNotice()
            print(JSON(ret))
            if ret as? Bool == false{
                self.mySwitch.setOn(true, animated: true)
                self.server.serverError(.wrongPassword, ShowTargert: self)
            }
            else if ret as? Bool == true{
                self.disableDeviceAlarm()
            }
        })
    }
    
    func disableDeviceAlarm(){
        if (self.bluetoothManager.connected == true && characteristicGlobal != nil){
            var hexString = WR_DISABLE_ALARM.substring(from: WR_DISABLE_ALARM.characters.index(WR_DISABLE_ALARM.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                        hexString = "0" + hexString
                    }
            let data = hexString.dataFromHexadecimalString()
            self.bluetoothManager.writeValue(data: data!, forCharacteristic: characteristicGlobal!, type: .withoutResponse)
            self.mySwitch.setOn(false, animated: true)
            self.mySwitch.isEnabled = false
            UserDefaults.standard.set("False", forKey: "Alarm")
            
        }else{
            self.server.serverError(.customeErrorMessage, ShowTargert: self,ErrorMessage:"You havn't connected with the Alva device")
        }
    }

}
