//
//  WebService.swift
//  Movie_App_Intern
//
//  Created by Macbook on 10/03/2021.
//

import Foundation

class WebService {
    // Getting Api By Making Request on Url
    func getApi(ApiKey : ConstantsUrls.ApiKey ,completion : @escaping ([Results]) -> ()) {
        var results = [Results]()
        let url = ConstantsUrls()
        let UrlString =  url.baseUrl(apiKey: ApiKey)
        print(UrlString)
        guard let MovieUrl = URL(string: UrlString) else {
            return
        }
        let Request = URLRequest(url: MovieUrl)
        URLSession.shared.dataTask(with: Request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                if let jsonResults = try? decoder.decode(ApiData.self, from: data){
                    results = jsonResults.results!
                       }
                OperationQueue.main.addOperation {
                    completion(results)
                }}
        }.resume()
    }
 //----------------------------------------------------
}
