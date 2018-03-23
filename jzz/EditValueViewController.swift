//
//  EditValueViewController.swift
//  jzz
//
//  Created by wei lu on 24/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftValidator
import PopupDialog
import SwiftyJSON

class EditValueViewController: UIViewController,ValidationDelegate {
    var user:String!
    var textInput:UITextField!
    var value:[String:Any]!
    var key:String!
    let validator = Validator()
    var selection:PopupDialog?
    var server:ServiceDataProcess!
    override func viewDidLoad() {
        super.viewDidLoad()
        initAll()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.textInput.isEnabled = true
    }
    
    func initAll() {
        assert(user != nil, "The EditValueController didn't initilize correct!")
        self.title = "Edit Value"
        self.view.backgroundColor = globalStyle.backgroundColor
        self.textInput = UITextField()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        textInput.text = String(describing: self.value["Value"]!)//String(describing: Array(self.value.attribute.values)[0]["Value"])
        textInput.font = globalStyle.subtitleFont
        self.server = ServiceDataProcess()
        self.registValidator()
        self.prepareUI()
    }
    
    
    fileprivate func prepareUI() {
        textInput.backgroundColor = UIColor.white
        view.addSubview(textInput)
        let paddingView = UIView(frame:CGRect(x:0,y:0,width:25,height:25))
        textInput.leftView = paddingView
        textInput.leftViewMode = UITextFieldViewMode.always
        textInput.layer.borderColor = globalStyle.subtitleColor.cgColor
        textInput.layer.borderWidth = 0.5 
        self.textInput.snp.makeConstraints{(make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(45.0)
        }
    }
    
    @objc fileprivate func saveAction(){
        self.validator.validate(self)
    }

    //Mark Function
    fileprivate func registValidator(){
        switch self.value["Type"] as! EditType {
        case .Text:
            validator.registerField(self.textInput, rules: [RequiredRule(),MinLengthRule()])
        case .Email:
            validator.registerField(self.textInput, rules: [EmailRule()])
        case .Numeric:
            validator.registerField(self.textInput, rules: [RequiredRule(),AlphaNumericRule()])
        case .Selection:
            self.textInput.isEnabled = false
            self.selection = self.configPopupDialog(title: "Please Select Your Gender")
            self.registerGenderSelectionEvent()
        default:
            break
        }
        
        
    }
    
    
    
    //Gender
    //Gender Selection
    fileprivate func configPopupDialog(title:String) -> PopupDialog{
        let popup = PopupDialog(title: title, message: nil, image: nil,transitionStyle:.fadeIn,gestureDismissal:true)
        
        let buttonOne = DefaultButton(title: "Male") {
            self.textInput.text = "Male"
        }
        
        let buttonTwo = DefaultButton(title: "Female") {
            self.textInput.text = "Female"
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        
        return popup
        
    }
    
    fileprivate func registerGenderSelectionEvent(){
        self.textInput.addTarget(self, action: #selector(self.selectEvent), for: .touchDown)
    }
    
    @objc fileprivate func selectEvent(){
        if(self.selection != nil){
            self.present(self.selection!, animated: true, completion: nil)
        }
    }
    
    func validationSuccessful() {
        // submit the form
        //register request
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as? String
        if user == nil{
            return
        }
        let model = ProfileModel(user: user)
        model.update(key:self.key, value: self.textInput.text ?? " ")
        
        let data = httpData()
        data.Httpmethod = .post
        
        data.data = [
            "UserName" : user!,
            self.key:String(self.textInput.text!)!
        ]
        
        self.pleaseWait()
        
        server.httpAct(requestUrl: UPDATE_PROFILE, Senddata: data, completion: {ret in
            
            self.clearAllNotice()
            print(JSON(ret))
                if JSON(ret) == false{
                    self.server.serverError(.serverError, ShowTargert: self)
                }
                else if JSON(ret) == true{
                    self.server.serverSuccess(Showtarget: self,Content: "Successfully Modified",Title: "Success",completion: {ret in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                    
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
}
