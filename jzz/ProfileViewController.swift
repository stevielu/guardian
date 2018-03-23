//
//  ProfileViewController.swift
//  jzz
//
//  Created by wei lu on 17/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import RealmSwift

class ProfileViewController: UIViewController {
    var contacts:ContactsReview!
    var avatar:UIImage!
    var button:AddButton!
    var headerView:DetailHearder!
    var content:DetailsContent!
    let server = ServiceDataProcess()
    var myContactId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.headerView = DetailHearder(frame: self.view.frame, profile: avatar, title: contacts.FullName, id: contacts.UserName)
        self.content = DetailsContent(frame: self.view.frame, address: contacts.Address, mobile: contacts.Mobile)
        
        self.prepareUI()
        self.button.addTarget(self, action: #selector(self.didTapAddContacts), for: .touchDown)
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
    
    // MARK: Tap Event
    @objc fileprivate func didTapAddContacts(){
        let user = UserDefaults.standard.object(forKey: "ActiveUser")
        if user == nil{
            return
        }
        
        let data = httpData()
        data.Httpmethod = .post
        data.data = [
                    "UserName":user!,
                    "FriendName":contacts.UserName
                    ]
        self.pleaseWait()
        self.server.httpAct(requestUrl: ADD_CONTACT, Senddata: data, completion: {ret in
            let json = ret as! Bool
            
            self.clearAllNotice()
            
            if(json == true){
                self.server.serverSuccess(Showtarget: self,Content: "You successfully add friend",Title: "Congrats!",completion: {ret in
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            else{
                self.server.serverError(.addError, ShowTargert: self)
            }
        })
    }
    
    // MARK: - Loading UI & SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Details"
        headerView.backgroundColor = UIColor.white
        content.backgroundColor = UIColor.white
        headerView.layer.borderWidth = 0.5
        headerView.layer.borderColor = UIColor(rgb:0xdddddd).cgColor
        content.layer.borderWidth = 0.5
        content.layer.borderColor = UIColor(rgb:0xdddddd).cgColor
        
        if(self.checkExisted() == true){
            self.button = AddButton()
            self.button.alpha = 0
        }else{
            self.button = AddButton(value: "Add to My Contacts")
            
        }
        
        view.addSubview(button)
        view.addSubview(headerView)
        view.addSubview(content)
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(75)
        }
        
        self.content.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(75)
        }
        
        self.button.snp.makeConstraints { (make) in
            make.top.equalTo(self.content.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.height.equalTo(50)
        }
    }

    
    
    
    @objc fileprivate func checkExisted()-> Bool{
        if let contactLists = self.getMyContacts(){
            if(contactLists.count > 0){
                for item in contactLists{
                    if(item.FriUserName == self.contacts.UserName){
                        return true
                    }
                    else{
                        return false
                    }
                }
                
            }
        }
        
        return false
    }
    
    fileprivate func getMyContacts() -> [DBContactDetials]?{
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
        if user.isEmpty{
            return nil
        }
        
        let model = ContactsModel(user: user)
        let contacts = model.get()
        return contacts
    }
}
