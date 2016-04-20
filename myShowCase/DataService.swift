//
//  DataService.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-12.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://burning-inferno-8676.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_CURRENT_USER: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(_REF_USERS)").childByAppendingPath(uid)
        
        return user!
    }
    
    func creatFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}