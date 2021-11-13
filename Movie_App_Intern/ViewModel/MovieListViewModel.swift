//
//  MovieListViewModel.swift
//  Movie_App_Intern
//
//  Created by Macbook on 10/03/2021.
//

import Foundation
class MovieListViewModels {
    private let ImagesUrl = "http://image.tmdb.org/t/p/w185"
    private var webservice : WebService 
    private var MovieViewModel : [Results] = [Results]()
    var popular_chk : Bool = true // Boolean Used To check either you are on popular view or not
    var toprated_chk : Bool = false // Boolean Used To check either you are on top_rated view or not
    private var completion : () -> () = { }
    init(ApiKey : ConstantsUrls.ApiKey, completion : @escaping () -> ()) {
        self.webservice = WebService()
        self.completion = completion
        self.populateMovies(ApiKey: ApiKey)
    }
    private func populateMovies (ApiKey : ConstantsUrls.ApiKey) {
    self.webservice.getApi(ApiKey: ApiKey) { (results) in
        self.MovieViewModel = results
        self.completion()
    }}
    func SourceAt(index : IndexPath) -> MovieViewModel {
        let MovieVm = Movie_App_Intern.MovieViewModel()
        MovieVm.title = MovieViewModel[index.row].title
        MovieVm.backdrop_path = MovieViewModel[index.row].backdrop_path
        MovieVm.poster_path = MovieViewModel[index.row].poster_path
        MovieVm.release_date = MovieViewModel[index.row].release_date
        MovieVm.overview = MovieViewModel[index.row].overview
        MovieVm.vote_average = MovieViewModel[index.row].vote_average
        return MovieVm
    }
    func ListNumber() -> Int {
        return MovieViewModel.count
    }
    func PosterImage(index : IndexPath) -> String {
        return ImagesUrl + MovieViewModel[index.row].poster_path!
    }
    func DetailCell (MovieVm : Results) -> MovieDetailsTableViewCell {
        let cell = MovieDetailsTableViewCell()
        cell.Name.text = MovieVm.title
        cell.Rate.text = String(MovieVm.vote_average!)
        cell.Release_Data.text = MovieVm.release_date
        cell.Poster_Image.downloaded(from: ImagesUrl + MovieVm.poster_path!)
        return cell
    }
    func Toggle(choice:String, completion : @escaping () -> ()) {
        switch choice {
        case "popular":
            if !self.popular_chk {
                self.popular_chk = true
                self.toprated_chk = false
                self.webservice = WebService()
                self.completion = completion
                self.populateMovies(ApiKey: .popular)
            }
        default:
            if !self.toprated_chk{
            self.toprated_chk = true
            self.popular_chk = false
            self.webservice = WebService()
            self.completion = completion
            self.populateMovies(ApiKey: .top_rated)
        }}
}}
