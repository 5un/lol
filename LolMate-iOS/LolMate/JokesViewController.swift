
//
//  File.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import UIKit
import Hyphenate
import pop

class JokesViewController: UIViewController {
    
    @IBOutlet weak var btnLol: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var viewJokeCard: UIView!
    @IBOutlet weak var lblJokeText: UILabel!
    
    var dummyJokeIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btnLol.layer.cornerRadius = 50.0
        btnNo.layer.cornerRadius = 50.0
        viewJokeCard.layer.cornerRadius = 10.0
        
        viewJokeCard.layer.shadowColor = UIColor.black.cgColor
        viewJokeCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewJokeCard.layer.shadowOpacity = 0.3
        viewJokeCard.layer.shadowRadius = 4.0
        
        lblJokeText.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Must handle incoming call
        
        //TODO: check match info
        
        nextJoke()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLolClicked(_ sender: Any) {
        //TODO: Call the API
        
        let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        spring?.fromValue  = NSValue(cgSize: CGSize(width: 0.9, height: 0.9))
        spring?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        spring?.springBounciness = 18 // a float between 0 and 20
        spring?.springSpeed = 5
        btnLol.layer.pop_add(spring!, forKey: "animSize")
        
        // callMatchedUser()
        nextJoke()

    }
    
    
    @IBAction func btnNoClicked(_ sender: Any) {
        let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        spring?.fromValue  = NSValue(cgSize: CGSize(width: 0.9, height: 0.9))
        spring?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
        spring?.springBounciness = 18 // a float between 0 and 20
        spring?.springSpeed = 5
        btnNo.layer.pop_add(spring!, forKey: "animSize")
        
        nextJoke()


    }
    
    func nextJoke() {
        LOLAPI.getNextJoke { (joke) in
            print("--- Next Joke: \(joke)")
            
            let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            spring?.toValue = NSValue(cgSize: CGSize(width: 0.1, height: 0.1))
            spring?.springBounciness = 5 // a float between 0 and 20
            spring?.springSpeed = 8
            self.viewJokeCard.layer.pop_add(spring!, forKey: "animSize")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                if(joke == nil) {
                    self.lblJokeText.text = MockData.jokes[self.dummyJokeIndex]["joke"]
                    if(self.dummyJokeIndex + 1 < MockData.jokes.count) {
                        self.dummyJokeIndex += 1
                    } else {
                        self.dummyJokeIndex = 0
                    }
                }
                
                let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
                spring?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
                spring?.springBounciness = 18 // a float between 0 and 20
                spring?.springSpeed = 3
                self.viewJokeCard.layer.pop_add(spring!, forKey: "animSize")
            }
        }
    }
    
    func callMatchedUser() {
        self.performSegue(withIdentifier: "callMatchedUser", sender: nil)
        
    }
    
}

