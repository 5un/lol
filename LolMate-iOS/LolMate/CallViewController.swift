//
//  ViewController.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate
import AVFoundation

class CallViewController: UIViewController, EMCallManagerDelegate {
    
    var callId: String?
    var callee: String?
    
    @IBOutlet weak var lblCalleeName: UILabel!
    @IBOutlet weak var lblTimeCountDown: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        EMClient.shared().callManager.add!(self, delegateQueue: nil)
        lblCalleeName.text = self.callee!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        EMClient.shared().callManager.start!(EMCallTypeVoice, remoteName: self.callee, ext: "") { (session, error) in
            print("started call!")
            
            self.callId = session?.callId
            DispatchQueue.main.async() {
                self.lblTimeCountDown.text = "Dailing..."
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLeaveClicked(_ sender: Any) {
        if(callId != nil) {
            EMClient.shared().callManager.endCall!(callId!, reason: EMCallEndReasonHangup)
            
            // Send something to notification controller if matched
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func callDidReceive(_ aSession: EMCallSession!) {
        print("--- callDidReceive")
        DispatchQueue.main.async() {
            let avAudioSession = AVAudioSession.sharedInstance()
            do {
                try avAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try avAudioSession.setActive(true)
                
                self.lblTimeCountDown.text = "10.00"
                
                self.view.addSubview(aSession.localVideoView)
                self.view.addSubview(aSession.remoteVideoView)
            } catch  {
                print("caught error")
            }

        }
        
        
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        print("--- callDidConnect")
        
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        print("--- callDidAccept")
    }
    
    
    
}

