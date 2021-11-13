//
//  Constants.swift
//  Movie_App_Intern
//
//  Created by Macbook on 13/03/2021.
//

import Foundation

class ConstantsUrls {
    
    enum ApiKey : String {
        case popular = "popular"
        case top_rated = "top_rated"
    }
    func baseUrl (apiKey : ApiKey) -> String {
        return "https://api.themoviedb.org/3/movie/\(apiKey)?api_key=6ba7581f4330b87ceabc4ef8212ed72b"
    }
    func ImagesUrl (ImgString : String) -> String {
        return "http://image.tmdb.org/t/p/w185" + ImgString
    }
}
