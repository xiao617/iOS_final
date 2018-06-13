//
//  TableView.swift
//  Pikachu_VolleyBall
//
//  Created by 廖莉祺 on 2018/6/7.
//  Copyright © 2018年 廖莉祺. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class TableView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var waitcheck = false
    var ref: DatabaseReference!
    var initloadstat = false
    //Keep self username
    let Username = UserDefaults.standard.object(forKey: "UserName") as! String
    var username = [String]()
    var list = [String]()
    var inuser = [String: Bool]()
    var chosen = ""
    var bechosen = false
    var alertcontroller: UIAlertController!
    
    @IBOutlet var usertableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        usertableview.dataSource = self
        usertableview.delegate = self
        ref = Database.database().reference()
        loaddata()
        
        let swifttorefresh = UISwipeGestureRecognizer(target: self, action: #selector(self.loaddata))
        swifttorefresh.direction = .down
        ref.child("UserList").child(Username).observe( .value, with: {(Snapshot) in
            
            let tvv = Snapshot.value as! NSDictionary
            let State = tvv["ConnectState"] as! Bool
            let Connecter = tvv["Connecter"] as! String
            let Waitt = tvv["Waiting"] as! Bool
            print(self.waitcheck,self.chosen,Connecter,Waitt,State)
            if(self.waitcheck==true && self.chosen == Connecter){
                print("$1")
                self.alertcontroller.dismiss(animated: true, completion: nil)
                //TODO: To next page
                //self.removeName(name: self.Username)
                UserDefaults.standard.set(Connecter , forKey:"Connecter")
                UserDefaults.standard.set(true , forKey:"CTcheck")
                self.performSegue(withIdentifier: "ToARGame", sender: self)
                
            }else if(self.waitcheck && !Waitt){
                print("$5")
                self.alertcontroller.dismiss(animated: true, completion: nil)
                self.chosen = ""
                self.waitcheck = false
            }
            if(!self.waitcheck){
                print("$2")
                if(Waitt){
                    print("$3")
                    self.alertcontroller.dismiss(animated: true, completion: nil)
                }
                if(State){
                    print("$4")
                    self.bechosen = true
                    let connecter = tvv["Connecter"] as! String
                    self.alertcontroller = UIAlertController(title: "連線請求", message: connecter+",想跟您進行遊戲", preferredStyle: .alert)
                    let okbut = UIAlertAction(
                        title: "確認", style: .default, handler: {(action: UIAlertAction!) -> Void in
                            self.ref.child("UserList").child(connecter).updateChildValues(["Connecter":self.Username, "ConnectState": true])
                            //TODO: To next page
                            //self.removeName(name: self.Username)
                            UserDefaults.standard.set(connecter , forKey:"Connecter")
                            UserDefaults.standard.set(false , forKey:"CTcheck")
                            self.performSegue(withIdentifier: "ToARGame", sender: self)
                    })
                    let refbut = UIAlertAction(
                        title: "拒絕", style: .default, handler: {(action: UIAlertAction!) -> Void in
                            self.ref.child("UserList").child(self.Username).updateChildValues(["ConnectState": false,"Connecter": ""])
                            self.ref.child("UserList").child(connecter).updateChildValues(["Waiting":false])
                    })
                    self.alertcontroller.addAction(okbut)
                    self.alertcontroller.addAction(refbut)
                    self.present(self.alertcontroller, animated: true)
                    print("get news")
                }
                else{
                    print("$6")
                    if(self.bechosen){
                        print("$7")
                        self.alertcontroller.dismiss(animated: true, completion: nil)
                        self.bechosen = false
                    }
                }
                
            }
            
            //}
            /*
             else{
             let connect
             }*/
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func removeName(name: String) {
        var tem = [String]()
        self.ref.child("UserName").observeSingleEvent(of: .value, with: {(Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            tem = vv["Name"] as! [String] ?? [String]()
        })
        let inde = tem.index(of: name)
        tem.remove(at: inde!)
        self.ref.child("UserName").updateChildValues(["Name": tem])
    }
    @objc func loaddata() {
        ref.child("UserName").observe( .value , with: { (Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            //self.usertableview.reloadData()
            let tuser = vv["Name"] as! [String] 
            //old version
            //self.username = vv["Name"] as! [String] ?? [String]()
            let totalnum = tuser.count - 1
            var count = 0
            self.username = []
            for name in tuser{
                print("---$$",name)
                if(name == "Default" || name == self.Username){
                    continue
                }
                else{
                    self.ref.child("UserList").child(name).observeSingleEvent(of: .value, with: {
                        (Snapshot) in
                        let tvv = Snapshot.value as! NSDictionary
                        let State = tvv["ConnectState"] as! Bool
                        let Waitt = tvv["Waiting"] as! Bool
                        if(State || Waitt){
                            print("skip",name)
                        }
                        else{
                            self.username.append(name)
                            print(name)
                            DispatchQueue.main.async{
                                self.usertableview.reloadData()
                            }
                        }
                    })
                }
                
            }
 
            
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chosen = username[indexPath.row]
        print(self.chosen)
        //removeName(name: self.chosen)
        //removeName(name: self.Username)
        ref.child("UserList").child(self.chosen).updateChildValues(["ConnectState":true,"Connecter": self.Username])
        self.waitcheck = true
        ref.child("UserList").child(self.Username).updateChildValues(["Waiting":true])
        self.alertcontroller = UIAlertController(title: "等待連線", message: "等待與"+chosen+"進行連線", preferredStyle: .alert)
        let refbut = UIAlertAction(
            title: "取消", style: .destructive, handler: {(action: UIAlertAction!) -> Void in
                self.ref.child("UserList").child(self.chosen).updateChildValues(["ConnectState": false,"Connecter": ""])
                self.ref.child("UserList").child(self.Username).updateChildValues(["Waiting": false])
                self.waitcheck = false
                //self.addName(name: self.chosen)
                //self.addName(name: self.Username)
        })
        self.alertcontroller.addAction(refbut)
        self.present(self.alertcontroller, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return username.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = username[indexPath.row]
        return cell
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
