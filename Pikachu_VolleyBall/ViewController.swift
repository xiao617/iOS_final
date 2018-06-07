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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func initDatabase() {
        let UploadUserData = ["Character": 0, "ConnectState": true, "Connecter": "" , "Waiting": false,"winOrloss":0,"forceVectorX":0,"forceVectorY":0,"forceVectorZ":0,"positionVectorX":0,"positionVectorY":0,"positionVectorZ":0] as [String : Any]
        
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
        UserName = UserEnterName.text
        
        //Use dict to save info
        let UploadUserData = ["Character": 0, "ConnectState": true, "Connecter": "" , "Waiting": false,"winOrloss":0,"forceVectorX":0,"forceVectorY":0,"forceVectorZ":0,"positionVectorX":0,"positionVectorY":0,"positionVectorZ":0] as [String : Any]
        
        //Upload User Data to Firebase
        ref.child("UserList").child(UserName!).setValue(UploadUserData)
        
        
        
        UserInFirebase.append(UserName!)
        //print("uF",UserInFirebase)
        ref.child("UserName").updateChildValues(["Name":UserInFirebase])
        
        
        UserDefaults.standard.set(UserName , forKey:"UserName")
    }
}
