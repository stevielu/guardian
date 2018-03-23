//
//  LoginViewController.swift
//  jzz
//
//  Created by wei lu on 4/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
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
    
    
    
    /*
     *   Lazy ui element
     *   Content of Login Page
     */

    fileprivate lazy var Connect: UIButton = {
        let connect = UIButton()
        connect.backgroundColor = globalStyle.buttonFillColorBlue
        connect.tintColor = globalStyle.buttonTitleColor
        connect.layer.cornerRadius = 6.0
        connect.layer.borderWidth = 1.0
        connect.layer.borderColor = globalStyle.buttonFillColorBlue.cgColor
        connect.clipsToBounds = true
        connect.addTarget(self, action: #selector(self.didTapConnect), for: .touchUpInside)
        connect.setTitle("Connect Device", for: .normal)
        connect.titleLabel?.font = globalStyle.titleFont
        return connect
    }()
    
    fileprivate lazy var Register: RegisterButton = {
        let connect = RegisterButton()
        connect.backgroundColor = globalStyle.backgroundColor
        connect.setTitleColor(globalStyle.buttonFillColorBlue, for: .normal)
        connect.layer.cornerRadius = 6.0
        connect.layer.borderWidth = 1.0
        connect.layer.borderColor = globalStyle.buttonFillColorBlue.cgColor
        connect.clipsToBounds = true
        connect.addTarget(self, action: #selector(self.didTapRegister), for: .touchUpInside)
        connect.setTitle("Register Device", for: .normal)
        connect.titleLabel?.font = globalStyle.titleFont
        return connect
    }()
    
    fileprivate lazy var Logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "Logo")!)
        logo.frame = CGRect(x: globalStyle.screenSize.width/2 - 100, y: 100, width: 200, height: 200)
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    
    // MARK: - Tap Event
    @objc fileprivate func didTapConnect(sender:UIButton){
        self.performSegue(withIdentifier: "auth", sender: self)//RegisterView

    }
    
    @objc fileprivate func didTapRegister(sender:UIButton){
        self.performSegue(withIdentifier: "RegisterView", sender: self)//RegisterView
    }
    
    // MARK: - Loading UI
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(self.Logo)
        view.addSubview(self.Connect)
        view.addSubview(self.Register)

        self.Connect.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.Logo.snp.bottom).offset(40)
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).offset(-50)
            make.height.equalTo(50)
        }
        
        self.Register.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.Connect.snp.bottom).offset(15)
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).offset(-50)
            make.height.equalTo(50)
        }
        
        
        
        
        

    }
}
