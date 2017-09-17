
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
import Alamofire
import AlamofireImage

class JokesViewController: UIViewController, UIViewControllerTransitioningDelegate, MatchedViewControllerDelegate {

    
    @IBOutlet weak var btnLol: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var viewJokeCard: UIView!
    @IBOutlet weak var lblJokeText: UILabel!
    @IBOutlet weak var imgJoke: UIImageView!
    
    
    var dummyJokeIndex = 0
    var mockMatchCount = 0
    
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
        
        lblJokeText.text = "Get ready to LOL!"
        
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
        
        if(mockMatchCount + 1 < 10) {
            mockMatchCount += 1
        } else {
            mockMatchCount = 0
            matchedUser()
        }
        
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
                
                self.imgJoke.isHidden = true
                self.imgJoke.image = nil
                self.imgJoke.alpha = 0.0
                
                let joke = MockData.jokes[self.dummyJokeIndex]
                if(joke["image"] != nil) {
                    Alamofire.request(joke["image"]!).responseImage { response in
                        if let image = response.result.value {
                            self.imgJoke.image = image
                            self.imgJoke.isHidden = false
                            self.imgJoke.alpha = 1.0
                        }
                    }
                    
                } else {
                    self.lblJokeText.text = joke["joke"]
                    

                }
                
                if(self.dummyJokeIndex + 1 < MockData.jokes.count) {
                    self.dummyJokeIndex += 1
                } else {
                    self.dummyJokeIndex = 0
                }
                
                let spring = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
                spring?.toValue = NSValue(cgSize: CGSize(width: 1.0, height: 1.0))
                spring?.springBounciness = 18 // a float between 0 and 20
                spring?.springSpeed = 3
                self.viewJokeCard.layer.pop_add(spring!, forKey: "animSize")
            }
        }
    }
    
    func matchedUser() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "matchedViewController")
        //vc?.transitioningDelegate = self
        if let mvc = vc as? MatchedViewController {
            mvc.delegate = self
            mvc.purpose = "match"
        }
        vc?.modalPresentationStyle = UIModalPresentationStyle.formSheet
        
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimationController()
    }
    
    func matchedViewControllerOnPositiveClickedWithPurpose(purpose: String) {
        if(purpose == "match") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "callViewController") as? CallViewController
            if(vc != nil) {
                vc!.callee = "crystal"
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func matchedViewControllerOnNoClickedWithPurpose(purpose: String) {
        
    }
    
}

