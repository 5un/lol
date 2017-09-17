//
//  ViewController.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate

let REUSE_IDENTIFIER = "MatchedUserCell"

class MatchedUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts:[Any]?
    var selectedUser:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        EMClient.shared().contactManager.getContactsFromServer { (contacts, error) in
            print("-- got contacts")
            print("\(contacts!)")
            self.contacts = contacts
            self.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.contacts != nil) {
            return contacts!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER)
        let user = contacts?[indexPath.row]
        print("\(user!)")
        if(cell != nil) {
            if let img = cell?.viewWithTag(1) as? UIImageView {
                img.layer.cornerRadius = 25.0
                img.image = UIImage(named: "dummy-user-f-\(indexPath.row + 1)")
                
            }
            
            if let lbl = cell?.viewWithTag(2) as? UILabel {
                lbl.text = user! as! String
                
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: OpenChat
        let user = contacts?[indexPath.row]
        selectedUser = user as! String
        self.performSegue(withIdentifier: "showConversation", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showConversation") {
            if segue.destination is ChatViewController {
                let vc = segue.destination as! ChatViewController
                vc.conversationId = selectedUser!
            }
        }
    }
    
    

}

