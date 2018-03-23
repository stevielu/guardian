//
//  URL.swift
//  jzz
//
//  Created by wei lu on 2/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation


let BASE_URL = "http://ec2-54-183-27-23.us-west-1.compute.amazonaws.com/api/"

// API PATH
let USER_API = "\(BASE_URL)users/"
let TRACK_API = "\(BASE_URL)track/"
/*
 *
 * Users API
 *
 */


/// Auth Login
let AUTH = "\(USER_API)auth"

/// Register
let REGISTER = "\(USER_API)register"

/// Create Profile
let NEW_PROFILE = "\(USER_API)newprofile"

/// Update Profile
let UPDATE_PROFILE = "\(USER_API)updateprofile"

/// GET Profile
let GET_PROFILE = "\(USER_API)getprofile"

/// GET Avatar
let GET_AVATAR = "\(USER_API)useravatar"

/// Add Contact
let ADD_CONTACT = "\(USER_API)addcontact"

/// Get Contact
let GET_CONTACT = "\(USER_API)getmycontacts"

/// Search Contact
let SEARCH_CONTACT = "\(USER_API)searchfriend"

/// Update Device Token
let UPDATE_DEVICE_TOKEN = "\(USER_API)updateUsrDeviceToken"


/*
 *
 * Track API
 *
 */

/// Update Geo
let UPDATE_GEO = "\(TRACK_API)updategeo"

/// Get Nearby
let GET_NEARBY = "\(TRACK_API)nearby"

/// Make Alert
let MAKE_ALERT = "\(TRACK_API)alert"

/// Get Alert List
let GET_ALERTS = "\(TRACK_API)alertlists"

/// Update Alert List
let UPDATE_ALERTS = "\(TRACK_API)updatealertlist"
