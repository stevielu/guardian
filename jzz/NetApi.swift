//
//  NetApi.swift
//  jzz
//
//  Created by wei lu on 2/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//


import Foundation
import Alamofire

import SwiftyJSON
import Kingfisher
import RealmSwift
enum TokenType{
    case BASIC
    case BREAR
}

class httpData {
    var data = [String: Any]()
    var error:String = ""
    var Httpmethod:HTTPMethod!
    var targetView:UIViewController?
    var url = ""
    var encodingType = JSONEncoding.default
    var header:[String:String]?
}

class ServiceDataProcess{
    
    func httpAct(requestUrl: String,Senddata data:httpData,RequestTokenType tokenType:TokenType?=nil,completion: ((Any) -> Void)?) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Nil",//\(accessToken.type) \(accessToken.accessToken)
        ]
        
        Alamofire.request(requestUrl, method:data.Httpmethod,parameters: data.data, encoding: data.encodingType,headers:nil).validate().responseJSON{response in
            switch response.result {
            case .success(let data):
                
                if(completion != nil){
                    completion!(data)
                }
            case .failure(let error):
                
                if(completion != nil){
                    let statusCode = response.response?.statusCode
                    if(statusCode == 422){
                        if(response.data != nil){
                            completion!(response.data!)
                        }
                        
                    }else{
                        completion!(false)
                    }
                }
                print("Request failed with error: \(error)")
            }
        }
    }
    

    
//    internal func checkServerDataExistInCache(keyword:String) -> AnyObject{
//        
//        let lists = UserDefaults.standardUserDefaults
//        if let archivedData = lists.objectForKey(keyword) as? NSData{
//            return archivedData
//        }
//        return false
//    }
    
    
    
    
    func retrieveCellImg(ImgURL:String!,image:UIImageView,completion:@escaping (Any?)->Void){
        let src = URL(string: ImgURL)!
        //        let downloader = KingfisherManager.sharedManager.downloader
        //        downloader.requestModifier = { (request: NSMutableURLRequest) in
        //            request.addValue("Access ", forHTTPHeaderField: <#T##String#>)
        //        }
        image.kf.setImage(with: src, placeholder: UIImage(named: "default.png"), options:  [.transition(ImageTransition.fade(1))/*,.Downloader(downloader)*/], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
            print("\(imageURL): Finished")
            completion(error)
        })
        
    }
    

    
    func uploadAvatar(Image media:Data,URL url:URL,completion:@escaping (AnyObject?)->Void){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(media, withName: "avatar", fileName: "default", mimeType: "image/*")
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completion(JSON as AnyObject?)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                completion(encodingError as AnyObject)
            }
            
        }
    }
    
    func serverSuccess(Showtarget:UIViewController,Content:String? = "",Title:String? = "",completion:((UIAlertAction) -> Void)? = nil){
        let controller = UIAlertController(title: Title, message: Content, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: completion))
        Showtarget.present(controller, animated: true, completion: nil)
    }
    func serverError(_ ServerError: ServerError,ShowTargert:UIViewController,ErrorMessage:String? = "") {
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        switch (ServerError) {
        case .addError:
            let controller = UIAlertController(title: "Error", message: "Add Error", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
        case .customeErrorMessage:
            let controller = UIAlertController(title: "Input Error", message: ErrorMessage, preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
        case .fieldsRequired:
            let controller = UIAlertController(title: "Input Error", message: "All Fields Are Required", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
        case .serverError:
            let controller = UIAlertController(title: "Server Error", message: "Can not Connect to Server,Please try again or contact with us", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
        case .userExisted:
            let controller = UIAlertController(title: "Opps", message: "The username has already taken", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
        case .passwordUnmatch:
            let controller = UIAlertController(title: "Input Error", message: "Password and Confirm password is not match", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
            
        case .wrongPassword:
            let controller = UIAlertController(title: "Sorry", message: "Password Or User Name was wrong", preferredStyle: .alert)
            controller.addAction(okAction)
            ShowTargert.present(controller, animated: true, completion: nil)
            break
       
        default: break
        }
    }
}
