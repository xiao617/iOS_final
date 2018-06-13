//
//  ViewController.swift
//  Pikachu_VolleyBall
//
//  Created by 廖莉祺 on 2018/5/30.
//  Copyright © 2018年 廖莉祺. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class ViewController: UIViewController {
    @IBOutlet var Enter: UIButton!
    @IBOutlet var UserEnterName: UITextField!
    //Firebase Databasse
    var ref: DatabaseReference!
    
    //store firebase data
    var UserName: String?
    var UserInFirebase = [String]()
    
    @IBOutlet var warningfield: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        //Firebase Database
        ref = Database.database().reference()
        //initDatabase()
        
        ref.child("UserName").observe( .value , with: { (Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            self.UserInFirebase = vv["Name"] as? [String] ?? [String]()
            //print("usf",self.UserInFirebase.count,self.UserInFirebase)
        })
        Enter.isEnabled = false
        
    }
    @IBAction func Textfieldcg(_ sender: Any) {
        //Get Username from TextField
        UserName = UserEnterName.text
        
        Enter.isEnabled = false
        if(UserName == ""){
            warningfield.text = "此欄位不得空白"
        }
        else if(self.UserInFirebase.contains(UserName!)){
            warningfield.text = "此暱稱已被使用"
            Enter.isEnabled = false
        }
        else{
            warningfield.text = "此暱稱可使用"
            Enter.isEnabled = true
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func initDatabase() {
        let UploadUserData = ["Character": 0, "ConnectState": true, "Connecter": "" , "Waiting": false,"done":false] as [String : Any]
        
        //Upload User Data to Firebase
        ref.child("UserList").child("Default").setValue(UploadUserData)
        /*
         ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
         let vv = Snapshot.value as! NSDictionary
         self.UserInFirebase = vv["Name"] as? [String] ?? [String]()
         print("usf",self.UserInFirebase.count)
         })
         */
        ref.child("UserName").setValue(["Name":["Default"] ])
    }
    @IBAction func SendUserData (_ sender: UIButton) {
        //Get Username from TextField
        //UserName = UserEnterName.text
        
        //Use dict to save info
        let UploadUserData = ["Character": 0, "ConnectState": false, "Connecter": "" , "Waiting": false,"done":false] as [String : Any]
        
        //Upload User Data to Firebase
        ref.child("UserList").child(UserName!).setValue(UploadUserData)
        
        
        
        UserInFirebase.append(UserName!)
        //print("uF",UserInFirebase)
        ref.child("UserName").updateChildValues(["Name":UserInFirebase])
        
        
        UserDefaults.standard.set(UserName , forKey:"UserName")
    }
}
