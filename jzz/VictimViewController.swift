//
//  VictimViewController.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

class VictimViewController: UIViewController {
    
    var data:AlertData!
    var victimAvatar:UIImage!
    var avatar:UIImageView!
    var name:UILabel!
    var address:UILabel!
    var navButton:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
        self.loadContent()
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
    // MARK: -  SetUp
    @objc fileprivate func prepareUI() {
        view.backgroundColor = globalStyle.backgroundColor
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Victim Detail"
        self.avatar = UIImageView()
        self.name = UILabel()
        self.address = UILabel()
        self.navButton = UIButton()
        let icon = UIImageView(image: UIImage(named: "location"))
        icon.contentMode = .scaleAspectFit
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = 6.0
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFit
        avatar.image = UIImage(named: "")
        
        name.textAlignment = .center
        name.font = globalStyle.subtitleFont
        name.textColor = globalStyle.titleColor
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        
        address.textAlignment = .center
        address.numberOfLines = 0
        address.lineBreakMode = .byWordWrapping
        address.font = globalStyle.subtitleFont
        address.textColor = globalStyle.subtitleColor

        
        navButton.setTitleColor(globalStyle.buttonFillColorBlue, for: .normal)
        navButton.layer.cornerRadius = 6.0
        navButton.layer.borderWidth = 1.0
        navButton.backgroundColor = globalStyle.backgroundColor
        navButton.layer.borderColor = globalStyle.buttonFillColorBlue.cgColor
        navButton.clipsToBounds = true
        navButton.setTitle("Direction", for: .normal)
        navButton.titleLabel?.font = globalStyle.titleFont
        navButton.addTarget(self, action: #selector(didTapNavButton), for: .touchDown)
        
        
        view.addSubview(avatar)
        view.addSubview(name)
        view.addSubview(icon)
        view.addSubview(address)
        view.addSubview(navButton)
        
        avatar.snp.makeConstraints{(make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(55)
            make.right.equalTo(self.view.snp.centerX).offset(-35)
            make.width.height.equalTo(55)
        }
        
        name.snp.makeConstraints{(make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.left.equalTo(self.avatar.snp.right).offset(25)
            make.width.equalTo(95)
        }
        
        
        address.snp.makeConstraints{(make) in
            make.top.equalTo(avatar.snp.bottom).offset(55)
            make.left.equalTo(self.view.snp.left).offset(55)
            make.right.equalTo(self.view.snp.right).offset(-25)
        }
        
        icon.snp.makeConstraints{(make) in
            make.centerY.equalTo(address.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.height.width.equalTo(25)
        }
        
        navButton.snp.makeConstraints{(make) in
            make.top.equalTo(address.snp.bottom).offset(55)
            make.centerX.equalTo(self.view.snp.centerX).offset(-35)
            make.left.equalTo(self.view.snp.left).offset(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
        }
    }
    
    fileprivate func loadContent(){
        avatar.image = self.victimAvatar
        name.text = self.data!.FullName + " " + data!.Gender + ",Age " + String(data!.Age!)
        address.text = data!.Address
    }
    
    fileprivate func addPaddingForLeftView(image:UIImageView) -> UIView{
        let leftView = UIView()
        leftView.addSubview(image)
        leftView.frame = CGRect(x:0, y:0, width:0, height:20)
        image.frame = CGRect(x:-25, y:0, width:15, height:20)
        return leftView
    }
    
    @objc fileprivate func didTapNavButton(){
        if let latitude:CLLocationDegrees = Double(data.Lat),let longitude: CLLocationDegrees = Double(data.Lon){
            let regiondistance:CLLocationDistance = 2000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionspan  = MKCoordinateRegionMakeWithDistance(coordinates, regiondistance, regiondistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionspan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionspan.span)
            ]
            
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapitem = MKMapItem(placemark: placemark)
            mapitem.name = data.FullName
            mapitem.openInMaps(launchOptions: options)
        }
        
        
    }
}
