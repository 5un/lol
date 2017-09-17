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

class CallViewController: UIViewController, EMCallManagerDelegate, MatchedViewControllerDelegate, MatedViewControllerDelegate {
    
    var callId: String?
    var callee: String?
    
    @IBOutlet weak var lblCalleeName: UILabel!
    @IBOutlet weak var lblTimeCountDown: UILabel!
    
    var callCountDownDuration = 30
    var timer = Timer()
    var callCountDown = 30
    var callEnded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        EMClient.shared().callManager.add!(self, delegateQueue: nil)
        lblCalleeName.text = self.callee!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if(!callEnded) {
            EMClient.shared().callManager.start!(EMCallTypeVoice, remoteName: self.callee, ext: "") { (session, error) in
                print("started call!")
                
                self.callId = session?.callId
                DispatchQueue.main.async() {
                    self.lblTimeCountDown.text = "Dailing..."
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLeaveClicked(_ sender: Any) {
        if(callId != nil) {
            callEnded = true
            EMClient.shared().callManager.endCall!(callId!, reason: EMCallEndReasonHangup)
            self.respondToUser()

            // Send something to notification controller if matched
        }
    }
    
    func callDidReceive(_ aSession: EMCallSession!) {
        print("--- callDidReceive")
        DispatchQueue.main.async() {
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
        
        
    }
    
    func callDidConnect(_ aSession: EMCallSession!) {
        print("--- callDidConnect")
        DispatchQueue.main.async() {
            self.lblTimeCountDown.text = "\(self.callCountDownDuration)"
            self.callCountDown = self.callCountDownDuration
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (tmr) in
                if(self.callCountDown - 1 > 0) {
                    self.callCountDown -= 1
                    self.lblTimeCountDown.text = "\(self.callCountDown)"
                } else {
                    self.callCountDown = 0
                    self.callEnded = true
                    EMClient.shared().callManager.endCall!(self.callId!, reason: EMCallEndReasonHangup)
                    self.respondToUser()
                }
            })
        }
        
    }
    
    func callDidAccept(_ aSession: EMCallSession!) {
        print("--- callDidAccept")
    }
    
    func respondToUser() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "matchedViewController")
        //vc?.transitioningDelegate = self
        if let mvc = vc as? MatchedViewController {
            mvc.delegate = self
            mvc.matchLabel = "How would you rate your time with \(self.callee!)"
            mvc.positiveButtonLabel = "Cool"
            mvc.purpose = "rateCall"
        }
        vc?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    func matchedViewControllerOnPositiveClickedWithPurpose(purpose: String) {
        // TODO show match!!
        if(purpose == "rateCall") {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "matedViewController")
                //vc?.transitioningDelegate = self
                if let mvc = vc as? MatedViewController {
                    mvc.delegate = self
                    mvc.matchLabel = "You and \(self.callee!) are now mates."
                }
                vc?.modalPresentationStyle = UIModalPresentationStyle.formSheet
                
                self.navigationController?.present(vc!, animated: true, completion: nil)
            }

        }
    }
    
    func matchedViewControllerOnNoClickedWithPurpose(purpose: String) {
        // TODO Dismiss
        if(purpose == "rateCall") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func matedViewControllerOnPositiveClicked() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController")
        if let cvc = vc as? ChatViewController {
            cvc.conversationId = callee!
            self.navigationController?.pushViewController(cvc, animated: true)
        }
    }
    
    func matedViewControllerOnNegativeClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

