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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let callName = "user2"
        EMClient.shared().callManager.add!(self, delegateQueue: nil)
        
        EMClient.shared().callManager.start!(EMCallTypeVoice, remoteName: callName, ext: "") { (session, error) in
            print("started call!")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callDidReceive(_ aSession: EMCallSession!) {
        print("--- callDidReceive")
        let avAudioSession = AVAudioSession.sharedInstance()
        do {
            try avAudioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try avAudioSession.setActive(true)
            
            self.view.addSubview(aSession.localVideoView)
            self.view.addSubview(aSession.remoteVideoView)
        } catch  {
            print("caught error")
        }
        
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        print("--- callDidConnect")
        
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        print("--- callDidAccept")
    }
    
}

