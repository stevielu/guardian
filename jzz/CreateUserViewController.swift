//
//  CreateUserViewController.swift
//  jzz
//
//  Created by wei lu on 12/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import NexmoVerify
import SnapKit
import SwiftValidator
import SwiftyJSON

class CreateUserViewController: UIViewController,ValidationDelegate,UITextFieldDelegate {
    var inputUnit:RegisterInputUnit!
    var userName:UITextField!
    var userPass:UITextField!
    var confirmPass:UITextField!
    var phoneNum = ""
    var CountryCode = ""
    var nextButton = NextButton(value: "Next")
    let validator = Validator()
    let server = ServiceDataProcess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
        self.registValidator()
        self.hideKeyboardWhenTappedAround()
        self.nextButton.addTarget(self, action: #selector(self.didTapNextButton), for: .touchDown)
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
    // MARK: - Loading UI & SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Registration"
        
        
        self.inputUnit = RegisterInputUnit()
        self.userName = inputUnit.userNameInput
        self.userPass = inputUnit.passInput
        self.confirmPass = inputUnit.confirmInput
        
        self.userName.delegate = self
        self.userPass.delegate = self
        self.confirmPass.delegate = self
        
        view.addSubview(userName)
        view.addSubview(nextButton)
        view.addSubview(userPass)
        view.addSubview(confirmPass)
        
        userName.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(125)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        userPass.snp.makeConstraints{(make) in
            make.top.equalTo(self.userName.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        confirmPass.snp.makeConstraints{(make) in
            make.top.equalTo(self.userPass.snp.bottom).offset(25)
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
    
    func validationSuccessful() {
        // submit the form
        //register request
        let data = httpData()
        data.Httpmethod = .post
        data.data = [
            "UserName" : self.userName.text!,
            "Password" : self.userPass.text!,
            "Mobile" : Int(self.phoneNum) ?? 0,
            "Nation" : self.CountryCode
        ]
        
        self.pleaseWait()
        
        server.httpAct(requestUrl: REGISTER, Senddata: data, completion: {ret in
            
            self.clearAllNotice()
            if let result = ret as? Bool{
                if result == false{
                    self.server.serverError(.serverError, ShowTargert: self)
                }
                else if result == true{
                    let activeUser = UserDefaults.standard
                    activeUser.set(self.userName.text!, forKey: "ActiveUser")
                    self.performSegue(withIdentifier: "createProfile", sender: self)
                }
                
                
            }
            else{
                let result = JSON(ret)
                if(result["UserName"] != nil){
                    self.server.serverError(.userExisted, ShowTargert: self)
                }
                
            }
        })
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            self.server.serverError(.customeErrorMessage, ShowTargert: self,ErrorMessage: error.errorMessage)
            return
        }
    }
    
    
    
    //MARK: Event
    //MARK: - Button Evetn
    @objc fileprivate func didTapNextButton(){
        self.validator.validate(self)
        if self.userPass.text != self.confirmPass.text{
            server.serverError(.passwordUnmatch, ShowTargert: self)
            return
        }
    }
    
    //Mark Function
    fileprivate func registValidator(){
        validator.registerField(self.userName, rules: [RequiredRule(),MinLengthRule()])
        validator.registerField(self.userPass, rules: [RequiredRule(),PasswordRule()])
    }
}
