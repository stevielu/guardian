//
//  DeviceSettingViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit

class DeviceSettingViewController: UIViewController {

    var icon:SettingIcon!
    let bluetoothManager = BluetoothManager.getInstance()
    var check1:CheckboxButton!
    var check2:CheckboxButton!
    var check3:CheckboxButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.icon = SettingIcon()
        self.check1 = CheckboxButton()
        self.check2 = CheckboxButton()
        self.check3 = CheckboxButton()
        
        self.prepareUI()
        self.loadConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        self.navigationItem.title = "Device Gesture"
        self.view.backgroundColor = globalStyle.backgroundColor
        self.check1.addTarget(self, action: #selector(click1), for: .valueChanged)
        self.check2.addTarget(self, action: #selector(click2), for: .valueChanged)
        self.check3.addTarget(self, action: #selector(click3), for: .valueChanged)
        view.addSubview(self.icon.head)
        view.addSubview(self.icon.one)
        view.addSubview(self.icon.two)
        view.addSubview(self.icon.three)
        view.addSubview(self.check1)
        view.addSubview(self.check2)
        view.addSubview(self.check3)
        
        
        self.icon.head.snp.makeConstraints{(make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(25)
            make.width.height.equalTo(65)
            
        }
    
        self.icon.one.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.icon.head.snp.bottom).offset(45)
            make.width.equalTo(105)
            make.height.equalTo(35)
            
        }
        
        self.icon.two.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.icon.one.snp.bottom).offset(25)
            make.width.equalTo(105)
            make.height.equalTo(35)
            
        }
        
        self.icon.three.snp.makeConstraints{(make) in
            make.left.equalTo(self.view.snp.left).offset(25)
            make.top.equalTo(self.icon.two.snp.bottom).offset(25)
            make.width.equalTo(105)
            make.height.equalTo(35)
        }
        
        self.check1.snp.makeConstraints{(make) in
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.centerY.equalTo(self.icon.one.snp.centerY)
            make.height.width.equalTo(35)
        }
        
        self.check2.snp.makeConstraints{(make) in
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.centerY.equalTo(self.icon.two.snp.centerY)
            make.height.width.equalTo(35)
        }
        
        self.check3.snp.makeConstraints{(make) in
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.centerY.equalTo(self.icon.three.snp.centerY)
            make.height.width.equalTo(35)
        }
    }
    

    func loadConfig(){
        if let config = UserDefaults.standard.object(forKey: "DeviceConfig") as? [String:Any]{
            if let value = config["PressGesture"] as? [String:Bool]{
                self.check1.on = value["Press1"]!
                self.check2.on = value["Press2"]!
                self.check3.on = value["Press3"]!
            }
            
        }else{
            self.check1.on = true
            self.check2.on = false
            self.check3.on = false
        }
    }
    
    @objc fileprivate func click1(){
        self.check2.on = false
        self.check3.on = false
        setDeviceConfig()
    }
    
    @objc fileprivate func click2(){
        self.check1.on = false
        self.check3.on = false
        setDeviceConfig()
    }
    
    @objc fileprivate func click3(){
        self.check1.on = false
        self.check2.on = false
        setDeviceConfig()
    }
    
    fileprivate func resetGestureConfig(){
        let config = ["PressGesture":["Press1":self.check1.on,"Press2":self.check2.on,"Press3":self.check3.on]]
        UserDefaults.standard.set(config, forKey: "DeviceConfig")
    }
    
    func setDeviceConfig() {
        let config = ["PressGesture":["Press1":self.check1.on,"Press2":self.check2.on,"Press3":self.check3.on]]
        UserDefaults.standard.set(config, forKey: "DeviceConfig")
        let value = self.check1.on == true ? WR_CONFIG_PRESS_ONE:self.check2.on == true ? WR_CONFIG_PRESS_TWO:self.check3.on == true ? WR_CONFIG_PRESS_THREE:WR_CONFIG_PRESS_ONE
        setDeviceGesture(value: value)
    }
    
    func setDeviceGesture(value:String){
        if (self.bluetoothManager.connected == true && characteristicGlobal != nil){
            var hexString = value.substring(from: value.characters.index(value.startIndex, offsetBy: 2))
            if hexString.characters.count % 2 != 0 {
                hexString = "0" + hexString
            }
            let data = hexString.dataFromHexadecimalString()
            self.bluetoothManager.writeValue(data: data!, forCharacteristic: characteristicGlobal!, type: .withoutResponse)

            
        }else{
            let server = ServiceDataProcess()
            server.serverError(.customeErrorMessage, ShowTargert: self,ErrorMessage:"You havn't connected with the Alva device")
            self.resetGestureConfig()
        }
    }

}
