//
//  AuthViewController.swift
//  jzz
//
//  Created by wei lu on 20/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftValidator
import SwiftyJSON

class AuthViewController: UIViewController,ValidationDelegate,UITextFieldDelegate {
    var inputUnit:AuthInputUnit!
    var userName:UITextField!
    var userPass:UITextField!
    let validator = Validator()
    
    var authButton = AuthButton(value: "Login")
    let server = ServiceDataProcess()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
        self.registValidator()
        self.hideKeyboardWhenTappedAround()
        self.authButton.addTarget(self, action: #selector(self.didTapNextButton), for: .touchDown)
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
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Login"
        
        
        self.inputUnit = AuthInputUnit()
        self.userName = inputUnit.userNameInput
        self.userPass = inputUnit.passInput
        
        self.userName.delegate = self
        self.userPass.delegate = self
        
        view.addSubview(userName)
        view.addSubview(authButton)
        view.addSubview(userPass)
        
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
        
        
        self.authButton.snp.makeConstraints { (make) in
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
            "Useraccount" : self.userName.text!,
            "Password" : self.userPass.text!
        ]
        
        self.pleaseWait()
        
        server.httpAct(requestUrl: AUTH, Senddata: data, completion: {ret in
            
            self.clearAllNotice()
            print(JSON(ret))
            if ret as? Bool == false{
                    self.server.serverError(.wrongPassword, ShowTargert: self)
            }
            else if ret as? Bool == true{
                    let activeUser = UserDefaults.standard
                    activeUser.set(self.userName.text!, forKey: "ActiveUser")
                
                    ProfileAction.fetchProfile(activeUser: self.userName.text!, handel: {(ret) in
                        let packet = JSON(ret)
                        if(packet == false){
                            self.server.serverError(.serverError, ShowTargert: self)
                        }
                    })
                
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarView") as! JZZTabBarViewController
                    let appDelgate = UIApplication.shared.delegate as! AppDelegate
                    appDelgate.window?.rootViewController = tabBarController
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
        return
    }
    
    //Mark Function
    fileprivate func registValidator(){
        validator.registerField(self.userName, rules: [RequiredRule()])
        validator.registerField(self.userPass, rules: [RequiredRule()])
    }


}
