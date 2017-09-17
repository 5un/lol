//
//  ViewController.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate

protocol MatedViewControllerDelegate {
    
    func matedViewControllerOnPositiveClicked()
    func matedViewControllerOnNegativeClicked()
    
}

class MatedViewController: UIViewController, EMCallManagerDelegate {
    
    var delegate:MatedViewControllerDelegate?
    
    var matchLabel:String?
    var positiveButtonLabel: String?
    var negativeButtonLabel:String?
    
    @IBOutlet weak var lblMatch: UILabel!
    @IBOutlet weak var btnPositive: UIButton!
    @IBOutlet weak var btnNegative: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    
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
        
        btnPositive.layer.cornerRadius = 30.0
        imgProfile.layer.cornerRadius = 75.0
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChatClicked(_ sender: Any) {
        delegate?.matedViewControllerOnPositiveClicked()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLaterClicked(_ sender: Any) {
        delegate?.matedViewControllerOnNegativeClicked()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

