//
//  CreateProfileViewController.swift
//  jzz
//
//  Created by wei lu on 14/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftValidator
import SwiftyJSON
import PopupDialog

class CreateProfileViewController: UIViewController,ValidationDelegate,UITextFieldDelegate {
    var inputUnit:RegisterInputUnit!
    var email:UITextField!
    var fullName:UITextField!
    var gender:UITextField!
    var age:UITextField!
    var homeAddress:UITextField!
    var activeField: UITextField?
    var popUpSelection:PopupDialog!
    var nextButton = NextButton(value: "Next")
    let validator = Validator()
    let server = ServiceDataProcess()
    var scrollView = UIScrollView()
    var tapTerm:UITapGestureRecognizer = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
        self.registerGenderSelectionEvent()
        self.registValidator()
        self.hideKeyboardWhenTappedAround()
        self.nextButton.addTarget(self, action: #selector(self.didTapNextButton), for: .touchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deregisterFromKeyboardNotifications()
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
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Create Profile"
        
        scrollView.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width, height:450)
        scrollView.contentSize = CGSize(width:self.view.bounds.size.width, height:375);
        scrollView.isScrollEnabled = true;
        view.addSubview(scrollView)
        
        self.inputUnit = RegisterInputUnit()
        self.email = inputUnit.emailInput
        self.fullName = inputUnit.fullNameInput
        self.age = inputUnit.ageInput
        self.gender = inputUnit.genderInput
        self.homeAddress = inputUnit.homeAddressInput
        self.popUpSelection = self.configPopupDialog(title: "Select Gender")
        
        
        self.email.delegate = self
        self.fullName.delegate = self
        self.age.delegate = self
        self.gender.delegate = self
        self.homeAddress.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(email)
        scrollView.addSubview(fullName)
        scrollView.addSubview(age)
        scrollView.addSubview(gender)
        scrollView.addSubview(homeAddress)
        scrollView.addSubview(nextButton)
        
        email.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(75)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        fullName.snp.makeConstraints{(make) in
            make.top.equalTo(self.email.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        gender.snp.makeConstraints{(make) in
            make.top.equalTo(self.fullName.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        age.snp.makeConstraints{(make) in
            make.top.equalTo(self.gender.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        homeAddress.snp.makeConstraints{(make) in
            make.top.equalTo(self.age.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.homeAddress.snp.bottom).offset(70)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
    }
    
    
    //Gender Selection
    fileprivate func configPopupDialog(title:String) -> PopupDialog{
        let popup = PopupDialog(title: title, message: nil, image: nil,transitionStyle:.fadeIn,gestureDismissal:true)
        
        let buttonOne = DefaultButton(title: "Male") {
            self.gender.text = "Male"
        }
        
        let buttonTwo = DefaultButton(title: "Female") {
            self.gender.text = "Female"
        }
        
        popup.addButtons([buttonOne, buttonTwo])
    
        return popup

    }
    
    fileprivate func registerGenderSelectionEvent(){
        self.gender.isUserInteractionEnabled = true
        tapTerm = UITapGestureRecognizer(target: self, action: #selector(selectEvent))
        self.gender.addGestureRecognizer(tapTerm)
//        self.gender.addTarget(self.scrollView, action: #selector(self.selectEvent), for: .touchDown)
    }
    
    @objc fileprivate func selectEvent(){
        if(self.popUpSelection != nil){
            self.present(self.popUpSelection, animated: true, completion: nil)
        }
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        if let activeField = self.activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 75.0-12.5, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height+10.0);
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.isScrollEnabled = true
    }
    
    
    
    
    
    /*
     Delegate
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if(textField == self.gender){
            self.selectEvent()
            self.view.endEditing(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.gender){
            return false
        }else{
            return true
        }
        
    }
    
    func validationSuccessful() {
        // submit the form
        //register request
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as? String
        if user == nil{
            return
        }
        
        let data = httpData()
        data.Httpmethod = .post
        
        data.data = [
            "UserName" : user!,
            "Fullname" : self.fullName.text!,
            "Gender" : self.gender.text!,
            "Age" : Int(self.age.text!)!,
            "Address":self.homeAddress.text!,
            "Email":self.email.text ?? "default@null.com"
        ]
        
        self.pleaseWait()
        
        server.httpAct(requestUrl: NEW_PROFILE, Senddata: data, completion: {ret in
            
            self.clearAllNotice()
            if let result = ret as? Bool{
                if result == false{
                    self.server.serverError(.serverError, ShowTargert: self)
                }
                else if result == true{
                    self.server.serverSuccess(Showtarget: self,Content: "You have successfully registered for Alva.",Title: "Registration successful",completion: {ret in
                        
                        ProfileAction.fetchProfile(activeUser: user!, handel: {(ret) in
                        
                        })
                        self.performSegue(withIdentifier: "addFri", sender: self)
                        
                    })
                }
                
                
            }
            else{
                
                
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
    }
    
    //Mark Function
    fileprivate func registValidator(){
        validator.registerField(self.fullName, rules: [FullNameRule()])
        validator.registerField(self.gender, rules: [RequiredRule()])
        validator.registerField(self.age, rules: [RequiredRule(),AlphaNumericRule()])
        validator.registerField(self.email, rules: [EmailRule()])
        validator.registerField(self.homeAddress, rules: [RequiredRule()])
    }

}
