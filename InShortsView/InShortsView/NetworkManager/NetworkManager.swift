//
//  NetworkManager.swift
//  MVVM-Assignment
//
//  Created by Deepak Kumar on 23/07/18.
//  Copyright © 2018 Deepak Kumar. All rights reserved.
//

import Foundation

private let newsDataUrlString = "https://api.nytimes.com/svc/topstories/v2/sports.json?api-key=ef81e01863cd4083b327f1a9ff6a9317"
class NetworkManager: NSObject {
    class func newsApiCall(completion: (([Results]?) -> Void)?) {
        guard let url = URL(string: newsDataUrlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
//                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
//                    print("Dict is \(dict)")
//                }
                let json = try JSONDecoder().decode(NewsData.self, from: data)
                completion!(json.results!)
            } catch {
                print("News API Call Failed")
            }
        }
        task.resume()
    }
}
