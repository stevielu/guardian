//
//  CheckPinViewController.swift
//  jzz
//
//  Created by wei lu on 12/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import NexmoVerify
import SnapKit


class CheckPinViewController: UIViewController,UITextFieldDelegate {
    var inputUnit:RegisterInputUnit!
    var checkPin:UITextField!
    var tips:UILabel!
    var nextButton = NextButton(value: "Confrim Your Code")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.prepareUI()
        self.hideKeyboardWhenTappedAround()
        self.checkPin.delegate = self
        self.nextButton.addTarget(self, action: #selector(self.didTapNextButton), for: .touchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearAllNotice()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Loading UI & SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Verify Code"
        
        
        self.inputUnit = RegisterInputUnit()
        self.checkPin = inputUnit.smsCodeInput
        self.tips = inputUnit.tips
        self.tips.text = "We sent a text message to your phone. Please enter verification code to continue"
        view.addSubview(checkPin)
        view.addSubview(nextButton)
        view.addSubview(tips)
        
        checkPin.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(125)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        tips.snp.makeConstraints{(make) in
            make.top.equalTo(self.checkPin.snp.bottom).offset(12.5)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
    }
    
    /*
     Delegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: Event
    //MARK: - Button Evetn
    @objc fileprivate func didTapNextButton(){
        if let code = checkPin.text{
            self.pleaseWait()
            VerifyClient.checkPinCode(code)
            
        }else{
            self.noticeInfo("Can not be Empty!", autoClear: true, autoClearTime: 3)
        }
        
    }
}
