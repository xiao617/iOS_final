//
//  ViewController.swift
//  Basketball
//
//  Created by 廖莉祺 on 2018/5/29.
//  Copyright © 2018年 廖莉祺. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
//Firebase Structure
struct UploadInfo {
    var ConnectState: Bool?
    var Character: Int?
}

class ViewController: UIViewController {
    @IBOutlet var Enter: UIButton!
    //Firebase Database
    var ref: DatabaseReference!
    var UserName: String?
    
    var UserInFirebase = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Firebase Database
        ref = Database.database().reference()
        
        //下一行可以換背景顏色
        //self.view.backgroundColor = UIColor(red:0.94, green:0.97, blue:0.97, alpha:1.0)
        
        //按鈕圖片
        let button_image = UIImage(contentsOfFile: "/Users/cxliao/Desktop/swift/hw3/Basketball/Basketball/image/enter.png")
        Enter.setImage(button_image, for: UIControlState.normal)
        //initDatabase()
        ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            self.UserInFirebase = vv["Name"] as? [String] ?? [String]()
            //print("usf",self.UserInFirebase.count,self.UserInFirebase)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var UserEnterName: UITextField!
    func initDatabase() {
        let UploadUserData = ["Character": 0, "ConnectState": true] as [String : Any]
        
        //Upload User Data to Firebase
        ref.child("UserList").child("Default").setValue(UploadUserData)
        /*
         ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
         let vv = Snapshot.value as! NSDictionary
         self.UserInFirebase = vv["Name"] as? [String] ?? [String]()
         print("usf",self.UserInFirebase.count)
         })
         */
        UserInFirebase.append("Default")
        ref.child("UserName").setValue(["Name":UserInFirebase])
    }
    @IBAction func SendUserData (_ sender: UIButton) {
        //Get Username from TextField
        UserName = UserEnterName.text
        
        //Use dict to save info
        let UploadUserData = ["Character": 0, "ConnectState": false] as [String : Any]
        
        //Upload User Data to Firebase
        ref.child("UserList").child(UserName!).setValue(UploadUserData)
        
        
        
        UserInFirebase.append(UserName!)
        print("uF",UserInFirebase)
        ref.child("UserName").updateChildValues(["Name":UserInFirebase])
        
        
        UserDefaults.standard.set(UserName , forKey:"UserName")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}
