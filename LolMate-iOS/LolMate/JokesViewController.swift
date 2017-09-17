
//
//  File.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate


class JokesViewController: UIViewController {
    
    @IBOutlet weak var btnLol: UIButton!
    @IBOutlet weak var btnNeutral: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnLol.layer.cornerRadius = 50.0
        btnNeutral.layer.cornerRadius = 50.0
        btnNo.layer.cornerRadius = 50.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLolClicked(_ sender: Any) {
        print("yes")
        
    }
    
    @IBAction func btnNeutralClicked(_ sender: Any) {
        print("neutral")

    }
    
    @IBAction func btnNoClicked(_ sender: Any) {
        print("no")

    }
    
    func videoCallMatchedUser() {
        let callName = "user2"
        EMClient.shared().callManager.start(EMCallTypeVideo, remoteName: callName, ext: <#T##String!#>, completion: <#T##((EMCallSession?, EMError?) -> Void)!##((EMCallSession?, EMError?) -> Void)!##(EMCallSession?, EMError?) -> Void#>)
    }
    
}

