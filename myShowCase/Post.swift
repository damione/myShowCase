//
//  Post.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-15.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDesc: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: Firebase!
    
    var postDesc: String {
        return _postDesc
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    var postRef: Firebase {
        return _postRef
    }
    
    func adjustLikes(likeTapped: Bool) {
        if likeTapped {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
    
    init(description: String, imageUrl: String?, username: String) {
        self._postDesc = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dict: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dict["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dict["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let description = dict["description"] as? String {
            self._postDesc = description
        }
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
        
        /*if let username = dict["username"] as? String {
            self._username = username
        }*/
    }
}