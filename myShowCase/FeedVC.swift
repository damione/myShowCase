//
//  FeedVC.swift
//  myShowCase
//
//  Created by Damion Hanson on 2016-04-14.
//  Copyright © 2016 Damion Hanson. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var posts = [Post]()
    static var imgCache = NSCache()
    var imagePicker: UIImagePickerController!
    var imgSelected = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postText: UITextField!
    @IBOutlet weak var imgSelectorImage: UIImageView!
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func addPostBtn(sender: AnyObject) {
        if let txt = postText.text where txt != "" {
            
            if let img = imgSelectorImage.image where imgSelected {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                
                let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name:"fileupload", fileName:"image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    }, encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in

                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                            
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    print(links)
                                    if let imgLink = links["image_link"] as? String {
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            } else {
                                print(response.description)
                            }
                        }
                        
                    case .Failure(let error):
                        print(error)
                        //Maybe show alert to user and let them try again
                    }
                })
            
            } else {
                postToFirebase(nil)
            }
        }
    }

    @IBAction func LogoutBtn(sender: UIBarButtonItem!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
    }
    
    func postToFirebase(imgUrl: String?) {
        var post: Dictionary<String, AnyObject> = [
            "description": postText.text!,
            "likes": 0
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        } else {
            post["imageUrl"] = ""
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        postText.text = ""
        imgSelectorImage.image = UIImage(named: "camera")
        imgSelected = false
        
        tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 400
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock:  { snapshot in
            print(snapshot.value)
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                self.posts = []
                for snap in snapshots {
                    print("SNAP \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let post = Post(postKey: snap.key, dict: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgSelectorImage.image = image
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imgSelected = true
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print(post.postDesc)
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            cell.request?.cancel()
            var img: UIImage?
            
            //Checks for cached image
            if let url = post.imageUrl {
                img = FeedVC.imgCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        } else {
        
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == "" {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
}
