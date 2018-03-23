//
//  AddFriendsViewController.swift
//  jzz
//
//  Created by wei lu on 15/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import PopupDialog

class AddFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var nextButton = NextButton(value: "Start")
    var addButton = AddNewButton()
    var table:UITableView!
    var friends:[ContactsReview]?
    var fromSetting:Bool = false
    let server = ServiceDataProcess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.table = UITableView()
        self.table.delegate = self
        self.table.dataSource = self
        self.prepareUI()
        
        self.prepareTable()
        
        self.addButton.addTarget(self, action: #selector(self.didTapAddContacts), for: .touchDown)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getMyContacts()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.fromSetting = false
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
        self.performSegue(withIdentifier: "searchFriends", sender: self)
    }
    @objc fileprivate func didTapStart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarView") as! JZZTabBarViewController
        let appDelgate = UIApplication.shared.delegate as! AppDelegate
        appDelgate.window?.rootViewController = tabBarController
    }
    
    // MARK: - Loading UI & SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        self.navigationItem.title = "Add Contacts"
        self.table.backgroundColor = UIColor.white
        self.table.tableFooterView = UIView()
        if(self.fromSetting == true){
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(didTapStart))
        }
        
        view.addSubview(nextButton)
        view.addSubview(addButton)
        view.addSubview(table)
        
        
        
        self.addButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(35)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-25)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.height.equalTo(50)
        }
        
        self.table.snp.makeConstraints { (make) in
            make.top.equalTo(self.addButton.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(globalStyle.screenSize.height)
        }
    }
    
    
    @objc fileprivate func prepareTable(){
        self.table.register(ContactsCell.self, forCellReuseIdentifier: "ContactsCell")
    }
    
    
    
    @objc fileprivate func getMyContacts(){
        let user = UserDefaults.standard.object(forKey: "ActiveUser") as! String
        if user.isEmpty{
            return
        }
        
        let data = httpData()
        data.Httpmethod = .post
        data.data = ["UserName":user]
        self.pleaseWait()
        self.server.httpAct(requestUrl: GET_CONTACT, Senddata: data, completion: {ret in
            var list = [ContactsReview]()
            let json = JSON(ret)
            let model = ContactsModel(user: user)
            
            self.clearAllNotice()
            
            if(json.array == nil){
                return
            }
            
            for value in json.array! {
                let new = ContactsReview(JSONData: value)
                list.append(new)
                model.flush()
                model.store(data: new)
            }

            self.friends = list
            self.table.reloadData()
            
            
            
        })
    }
    
    //MARK: Delegate
    
    //Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.friends != nil){
            return (self.friends?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as? ContactsCell else {
            return UITableViewCell()
        }
        
        cell.cellTitle.text = self.friends?[indexPath.row].FullName
        
        if let avatar = self.friends?[indexPath.row].ProfilePhoto{
            if(avatar.isEmpty){
                cell.avatar.image = UIImage(named: "avatar")
            }else{
                let avatarUrl = GET_AVATAR + "/" + avatar
                self.server.retrieveCellImg(ImgURL: avatarUrl, image: cell.avatar, completion: {ret in
                    print(ret!)
                })
            }
           
            
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFriend", sender: self.friends?[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFriend"){
            let path = self.table.indexPathForSelectedRow!
            let currentCell = self.table.cellForRow(at: path) as! ContactsCell

            if let controller = segue.destination as? ProfileViewController{
                controller.contacts =  self.friends![path.row]
                controller.avatar = currentCell.avatar.image
            }
        }
    }
}
