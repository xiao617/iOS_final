//
//  UserTable.swift
//  Basketball
//
//  Created by 廖莉祺 on 2018/5/30.
//  Copyright © 2018年 廖莉祺. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class UserTable: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var usertableview: UITableView!
    
    var ref: DatabaseReference!
    //Keep self username
    let Username = UserDefaults.standard.object(forKey: "UserName")
    
    //Set timer to refresh
    var timer: Timer!
    var username = [String]()
    var list = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //ref.keepSynced(true)
        usertableview.dataSource = self
        usertableview.delegate = self
        //timer = Timer.scheduledTimer(timeInterval: 1.0 , target: self, selector: "refreshcycle", userInfo: nil, repeats: true)
        //loadusername()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            self.usertableview.beginUpdates()
            self.username = vv["Name"] as! [String] ?? [String]()
            //DispatchQueue.main.async {
            //    self.usertableview.reloadData()
            //}
            self.usertableview.endUpdates()
            
        })
        //self.usertableview.reloadData()
        
        //DispatchQueue.main.async {
        //    self.usertableview.reloadData()
        //}
        print("it",self.username)
    }
    func loadusername(){
        ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
            let vv = Snapshot.value as! NSDictionary
            self.username = vv["Name"] as! [String] ?? [String]()
            //self.UserTable.reloadData()
            //print(self.username)
            //self.usertableview.reloadData()
            /*
            DispatchQueue.main.async {
                self.usertableview.reloadData()
            }*/
        })
        print(username)
        
    }
    //func refreshcycle() {
    
    //}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(username.count)
        return username.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        /*
         var username = [String]()
         ref.child("UserName").observeSingleEvent(of: .value , with: { (Snapshot) in
         let vv = Snapshot.value as! NSDictionary
         username = vv["Name"] as! [String] ?? [String]()
         })
         for name in username{
         
         }*/
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
