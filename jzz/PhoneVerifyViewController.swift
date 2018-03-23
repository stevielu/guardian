//
//  UserRegisterViewController.swift
//  jzz
//
//  Created by wei lu on 4/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import NexmoVerify

class PhoneVerifyViewController: UIViewController,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var inputUnit:RegisterInputUnit!
    var countryCodeElement:UITextField!
    var phoneElement:UITextField!
    var nextButton = NextButton(value: "Send Verification Code")
    var currentCountry = Countries.list[2] as [String : AnyObject]
    var checkViewController:CheckPinViewController!
    var countryCode:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
        self.hideKeyboardWhenTappedAround()
        self.nextButton.addTarget(self, action: #selector(self.didTapNextButton), for: .touchDown)
        self.countryCodeElement.delegate = self
        self.phoneElement.delegate = self
        
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
        self.navigationItem.title = "Verify"
        
        let countryPickerView = UIPickerView()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        countryPickerView.showsSelectionIndicator = true
        countryPickerView.backgroundColor = globalStyle.buttonFillColorBlue
        
        self.inputUnit = RegisterInputUnit()
        self.countryCodeElement = inputUnit.countryCodeInput
        self.phoneElement = inputUnit.phoneInput
        self.countryCodeElement.inputView = countryPickerView
       
        view.addSubview(countryCodeElement)
        view.addSubview(phoneElement)
        view.addSubview(nextButton)
        
        countryCodeElement.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(125)
            make.left.equalTo(self.view.snp.left).offset(37.5)
            make.width.equalTo(110)
        }
        
        phoneElement.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(125)
            make.left.equalTo(countryCodeElement.snp.right).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-12.5)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
    }
    
    
    @objc fileprivate func didTapNextButton(){
        self.pleaseWait()
        self.sendPhoneVerify()
    }
    
    @objc fileprivate func sendPhoneVerify(){
        VerifyClient.getVerifiedUser(countryCode: self.countryCode, phoneNumber: self.phoneElement.text!,
                                     onVerifyInProgress: onVerifyInProgress,
                                     onUserVerified: onUserVerified,
                                     onError: onError
        )
    }
    
    /*
     Delegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.countryCodeElement){
            return false
        }else{
            return true
        }
        
    }
    
    // Mark:
    // Mark: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Countries.list.count
    }
    
    
    
    // Mark: Override
    // Mark: - Next View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Checkpin"){
            if let controller = segue.destination as? CheckPinViewController{
                self.checkViewController = controller
            }
        }
        
        if(segue.identifier == "createUser"){
            if let controller = segue.destination as? CreateUserViewController{
                controller.phoneNum = self.phoneElement.text!
                controller.CountryCode = self.countryCode
            }
        }
    }
    
    // Mark:
    // Mark: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: Countries.list[row]["country"] as! String, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCountry = Countries.list[row]
        self.countryCodeElement.text = describeCountry(currentCountry)
    }
    
    func describeCountry(_ country: [String : AnyObject]) -> String {
        if let prefix_list = country["int_prefix"] as? NSArray{
            if prefix_list.count > 0{
                if let int_prefix = prefix_list[0] as? String {
                    self.countryCode = country["country_code"] as! String
                    return int_prefix
                }
            }
            
        }
        
        return country["country_code"] as! String
    }
    
    
    // MARK: Verify PhoneNum
    // MARK: Callback
    
    fileprivate func onVerifyInProgress() {
        self.nextButton.stopAnimate()
        self.performSegue(withIdentifier: "Checkpin", sender: self)
        
    }
    
    fileprivate func onUserVerified() {
        //save phone number
        UserDefaults.standard.set(self.phoneElement.text! + self.countryCodeElement.text!, forKey: "ActivePhone")
        //toCheckPage
        self.clearAllNotice()
        self.performSegue(withIdentifier: "createUser", sender: self)
        
    }
    
    fileprivate func onError(_ verifyError: VerifyError) {
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        self.nextButton.stopAnimate()
        switch (verifyError) {
        case .invalidNumber:
            let controller = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .invalidPinCode:
            let controller = UIAlertController(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.checkViewController.present(controller, animated: true, completion: nil)
        case .invalidCodeTooManyTimes:
            let controller = UIAlertController(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", preferredStyle: .alert)
            controller.addAction(okAction)
            self.checkViewController.present(controller, animated: true, completion: nil)
        case .invalidCredentials:
            let controller = UIAlertController(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .userExpired:
            let controller = UIAlertController(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .userBlacklisted:
            let controller = UIAlertController(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .quotaExceeded:
            let controller = UIAlertController(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .sdkRevisionNotSupported:
            let controller = UIAlertController(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .osNotSupported:
            let controller = UIAlertController(title: "iOS version not supported", message: "This iOS version is not supported", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .verificationAlreadyStarted:
            let controller = UIAlertController(title: "Verification already started", message: "A verification is already in progress!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        default: break
        }
        
        // other errors can be silenced for the test app
        print("some error \(verifyError.rawValue)")
    }
    
}
