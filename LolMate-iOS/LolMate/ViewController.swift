//
//  ViewController.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        let username = "johndoe"
        let password = "password"
        
        // TODO Login with read acc
        EMClient.shared().login(withUsername: username, password: password) { (username, error) in
            //MBProgressHUD.hide(for: weakSelf?.view, animated: true)
            
            if error == nil {
                EMClient.shared().options.isAutoLogin = true
                //TODO: got to another page
                
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue:KNOTIFICATION_LOGINCHANGE), object: NSNumber(value: true))
                self.performSegue(withIdentifier: "enterApp", sender: nil)
                
            } else {
                var alertStr = ""
                switch error!.code {
                case EMErrorUserNotFound:
                    alertStr = error!.errorDescription
                    break
                case EMErrorNetworkUnavailable:
                    alertStr = error!.errorDescription
                    break
                case EMErrorServerNotReachable:
                    alertStr = error!.errorDescription
                    break
                case EMErrorUserAuthenticationFailed:
                    alertStr = error!.errorDescription
                    break
                case EMErrorServerTimeout:
                    alertStr = error!.errorDescription
                    break
                default:
                    alertStr = error!.errorDescription
                    break
                }
                
                let alertView = UIAlertView.init(title: nil, message: alertStr, delegate: nil, cancelButtonTitle: "okay")
                alertView.show()
            }
        }

    }


}

