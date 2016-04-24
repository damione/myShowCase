//
//  PostCell.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-14.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    var post: Post!
    var request: Request?
    var likesRef: Firebase!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    @IBOutlet weak var postDescTxt: UITextView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likesImg.addGestureRecognizer(tap)
        likesImg.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showCaseImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        likesRef = DataService.ds.REF_CURRENT_USER.childByAppendingPath("likes").childByAppendingPath(post.postKey)

        self.postDescTxt.text = "\(post.postDesc) \(post.imageUrl)"
        self.likesLbl.text = "\(post.likes)"
        
        //self.usernameLbl.text = post.username
        
        if post.imageUrl != nil {
            
            if img != nil {
                self.showCaseImg.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showCaseImg.image = img
                        FeedVC.imgCache.setObject(img, forKey: post.imageUrl!)
                    } else {
                        print(err?.description)
                        self.showCaseImg.hidden = true
                    }
                })
            }
            
        } else {
            self.showCaseImg.hidden = true
        }
        
        likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if (snapshot.value as? NSNull) != nil { //Firebase only returns NSNull as null value
                self.likesImg.image = UIImage(named: "heart-empty")
            } else {
                self.likesImg.image = UIImage(named: "heart-full")
            }
        })
    }

    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull { //Firebase only returns NSNull as null value
                self.likesImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likesRef.setValue(true)
            } else {
                self.likesImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likesRef.removeValue()
            }
        })
    }
}
