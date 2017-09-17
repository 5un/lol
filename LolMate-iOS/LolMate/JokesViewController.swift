
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
    
    override func viewDidAppear(_ animated: Bool) {
        // Must handle incoming call
        
        //TODO: check match info
        
        LOLAPI.getNextJoke { (joke) in
            print("--- Next Joke: \(joke)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLolClicked(_ sender: Any) {
        print("yes")
        //TODO: Call the API
        
        callMatchedUser()
        nextJoke()

    }
    
    @IBAction func btnNeutralClicked(_ sender: Any) {
        print("neutral")
        nextJoke()
        

    }
    
    @IBAction func btnNoClicked(_ sender: Any) {
        print("no")
        nextJoke()


    }
    
    func nextJoke() {
        LOLAPI.getNextJoke { (joke) in
            print("--- Next Joke: \(joke)")
        }
    }
    
    func callMatchedUser() {
        self.performSegue(withIdentifier: "callMatchedUser", sender: nil)
        
    }
    
}

