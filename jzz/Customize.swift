//
//  CustomeTextInputField.swift
//  jzz
//
//  Created by wei lu on 5/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

class customUITextField:UITextField{
    
    var placeholderText:String?
    //var sortViewBorder:UIView
    
    init(frame: CGRect,placeholder: String,boderNeeded:Bool) {
        super.init(frame: frame)
        self.placeholderText = placeholder
        self.placeholder = placeholder
        self.font = globalStyle.titleFont
        if(boderNeeded){
            self.layer.addBorder(edge: .bottom, color: globalStyle.titleColor, thickness: 0.5)
        }
        //self.returnKeyType = UIReturnKeyDone
    }
    
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset:CGRect = CGRect(x:bounds.origin.x+120, y:bounds.origin.y, width:bounds.size.width, height:50);
        return inset;
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect(x:bounds.origin.x+120, y:bounds.origin.y, width:120, height:50);
        return inset;
    }
    
    override func textRect(forBounds bounds:CGRect) -> CGRect
    {
        //return CGRectInset(bounds, 50, 0);
        let inset:CGRect = CGRect(x:bounds.origin.x+120, y:bounds.origin.y, width:bounds.size.width, height:bounds.size.height);
        return inset;
        
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset:CGRect = CGRect(x:120, y:bounds.origin.y, width:bounds.size.width,height:50);
        return inset;
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}



extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness,width:self.bounds.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
