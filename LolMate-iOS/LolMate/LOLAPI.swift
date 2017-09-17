//
//  LOLAPI.swift
//  LolMate
//
//  Created by Sun on 9/16/2560 BE.
//  Copyright © 2560 TCDisrupt. All rights reserved.
//

import Foundation
import Alamofire

// https://monik.localhost.run/get_joke/1/?user_id=1

class LOLAPI {

    static func getNextJoke(completion: @escaping ([String:Any]?) -> Void) {
        Alamofire.request(
            URL(string: "\(AppConstants.APIURL)/get_joke/1")!,
            method: .get,
            parameters: ["user_id": "1"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching joke: \(response.result.error)")
                    completion(nil)
                    return
                }
                
                if let value = response.result.value as? [String: Any] {
                    completion(value)
                }
                
        }
    }
    
    static func respondToJoke() {
        
    }
    
    static func respondToUser() {
        
    }
}
