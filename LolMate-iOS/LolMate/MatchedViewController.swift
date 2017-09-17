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
    
    func matchedViewControllerOnCallClicked()
    func matchedViewControllerOnNoClicked()
    
}

class MatchedViewController: UIViewController, EMCallManagerDelegate {
    
    var callId: String?
    var delegate:MatchedViewControllerDelegate?
    
    var matchLabel:String?
    var positiveButtonLabel: String?
    var negativeButtonLabel:String?
    
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
            btnPositive.titleLabel?.text = positiveButtonLabel!
        }

        if(negativeButtonLabel != nil) {
            btnNegative.titleLabel?.text = negativeButtonLabel!
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCallClicked(_ sender: Any) {
        delegate?.matchedViewControllerOnCallClicked()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNahClicked(_ sender: Any) {
        delegate?.matchedViewControllerOnNoClicked()
        self.dismiss(animated: true, completion: nil)

    }
    
    
}

