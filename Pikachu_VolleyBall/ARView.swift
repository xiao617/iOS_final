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
    @IBOutlet var areaques: UILabel!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    var ref: DatabaseReference!
    let Username = UserDefaults.standard.object(forKey: "UserName") as! String
    let Connecter = UserDefaults.standard.object(forKey: "Connecter") as! String
    let CTcheck = UserDefaults.standard.object(forKey: "CTcheck") as! Bool
    var chd: Int = 0
    var donebt = false
    var alertcontroller: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if(CTcheck){
            removeName(name1: Username,name2: Connecter)
        }
        let Qlist = ["點擊皮卡丘","點擊排球"]
        chd = Int(arc4random_uniform(UInt32(Qlist.count)))
        areaques.text = Qlist[chd]
        ref.child("UserList").child(Connecter).observe(.value, with: {(Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            let donbt = vv["done"] as! Bool
            if(donbt){
                self.alertcontroller = UIAlertController(title: "遊戲結束", message: "您輸了這場比賽", preferredStyle: .alert)
                let quitbut = UIAlertAction(
                    title: "回到主畫面", style: .default, handler: {(action: UIAlertAction!) -> Void in
                        self.performSegue(withIdentifier: "ToMain", sender: self)
                })
                self.alertcontroller.addAction(quitbut)
                self.present(self.alertcontroller, animated: true)
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func b1chosn() {
        print("pika")
        if(chd == 0){
            ref.child("UserList").child(Username).updateChildValues(["done":true])
            self.alertcontroller = UIAlertController(title: "遊戲結束", message: "您贏了這場比賽", preferredStyle: .alert)
            let quitbut = UIAlertAction(
                title: "回到主畫面", style: .default, handler: {(action: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "ToMain", sender: self)
            })
            self.alertcontroller.addAction(quitbut)
            self.present(self.alertcontroller, animated: true)
        }
    }
    @IBAction func b2chosen() {
        print("ball")
        if(chd == 1){
            ref.child("UserList").child(Username).updateChildValues(["done":true])
            self.alertcontroller = UIAlertController(title: "遊戲結束", message: "您贏了這場比賽", preferredStyle: .alert)
            let quitbut = UIAlertAction(
                title: "回到主畫面", style: .default, handler: {(action: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "ToMain", sender: self)
            })
            self.alertcontroller.addAction(quitbut)
            self.present(self.alertcontroller, animated: true)
        }
    }
    func removeName(name1: String,name2: String) {
        var tem = [String]()
        var newtt = [String]()
        let q1 = DispatchQueue(label: "FIFO", qos: .default, attributes: .initiallyInactive)
        self.ref.child("UserName").observeSingleEvent(of: .value, with: {(Snapshot) in
                let vv = Snapshot.value as! NSDictionary
                tem = (vv["Name"] as? [String])!
                let tnum = tem.count - 1
                var coun  = 0
                for namee in tem{
                    if(namee == name1 || namee==name2){
                        print("do nothing")
                    }
                    else{
                        newtt.append(namee)
                    }
                    if(coun == tnum){
                        q1.activate()
                    }
                    coun += 1
                }
            })
        q1.async {
            print("write")
            self.ref.child("UserName").updateChildValues(["Name":newtt])
            UserDefaults.standard.set("" , forKey:"Connecter")
            print("w_done")
        }
        
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
