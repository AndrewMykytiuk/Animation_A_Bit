//
//  NetworkManager.swift
//  AnimationX
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation


class NetworkManager: NSObject {
    
    class func getData(_ completion: @escaping(_ dict: [String:[[String]]], _ errorMsg: String?)->Void) {
        
        var dictionary: [String:[[String]]] = [:]
        
        guard let url = URL(string: "https://itunes.applikator.dk/ios_task/tenants.json") else {return}
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        //request.httpMethod = HTTPMethod.get.rawValue
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    
                    var ret:[[String:Any]]?
                    var names:[String] = []
                    var securityTypes:[[String]] = []
                    
                    ret = json["tenants"] as? [[String : Any]]
                    
                    // handle json...
                    //dictionary = json["tenants"]
                    for x in ret ?? [] {
                        
                        let securityType = x["security_types"] as! [String]
                        let name = x["name"] as! String
                        
                        
                        names.append(name)
                        securityTypes.append(securityType)
                    }
                    dictionary["name"] = [names]
                    dictionary["security_types"] = securityTypes
                }
                completion(dictionary, nil)
            } catch let error {
                print(error.localizedDescription)
                completion([:], error.localizedDescription)
            }
            
            
        })
        task.resume()
    }
    
}
