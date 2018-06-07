//
//  ARView.swift
//  Pikachu_VolleyBall
//
//  Created by 廖莉祺 on 2018/6/7.
//  Copyright © 2018年 廖莉祺. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class ARView: UIViewController {
    //Firebase Databasse
    var ref: DatabaseReference!
    let Username = UserDefaults.standard.object(forKey: "UserName") as! String
    let Connecter = UserDefaults.standard.object(forKey: "Connecter") as! String
    let CTcheck = UserDefaults.standard.object(forKey: "CTcheck") as! Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        ref = Database.database().reference()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readUserdata(){
        ref.child("UserList").child(Username).observe(.value, with: {(Snapshot) in
            //Add what you want to get
        })
    }
    func readConnecterData(){
        ref.child("UserList").child(Connecter).observe(.value, with: {(Snapshot) in
            //Add what you want to get
        })
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
