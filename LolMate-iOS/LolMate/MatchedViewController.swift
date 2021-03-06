//
//  ViewController.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate

protocol MatchedViewControllerDelegate {
    
    func matchedViewControllerOnPositiveClickedWithPurpose(purpose: String)
    func matchedViewControllerOnNoClickedWithPurpose(purpose: String)
    
}

class MatchedViewController: UIViewController, EMCallManagerDelegate {
    
    var callId: String?
    var delegate:MatchedViewControllerDelegate?
    
    var matchLabel:String?
    var positiveButtonLabel: String?
    var negativeButtonLabel:String?
    var purpose: String?
    
    @IBOutlet weak var lblMatch: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var btnNegative: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(matchLabel != nil){
            lblMatch.text = matchLabel!
        }
        
        if(positiveButtonLabel != nil) {
            btnPositive.setTitle(positiveButtonLabel!, for: .normal)
        }

        if(negativeButtonLabel != nil) {
            btnNegative.setTitle(negativeButtonLabel!, for: .normal)
        }
        
        btnPositive.layer.cornerRadius = 50.0
        btnNegative.layer.cornerRadius = 50.0
        
        lblTimer.isHidden = true

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCallClicked(_ sender: Any) {
        delegate?.matchedViewControllerOnPositiveClickedWithPurpose(purpose: self.purpose!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNahClicked(_ sender: Any) {
        delegate?.matchedViewControllerOnNoClickedWithPurpose(purpose: self.purpose!)
        self.dismiss(animated: true, completion: nil)

    }
    
    
}

