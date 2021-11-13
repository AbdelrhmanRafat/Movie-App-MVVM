//
//  FavouriteListViewModel.swift
//  Movie_App_Intern
//
//  Created by Macbook on 13/03/2021.
//

import Foundation
import CoreData
import UIKit
class FavouriteListViewModels : NSObject , NSFetchedResultsControllerDelegate {
    var chk_fav : Bool?
    // Data Fetching
   private var favourites : [Fav_Mov_MO]! // Array Catch Data of Core Data And Display it
   private var fav : Fav_Mov_MO!
   private var completion : () -> () = { }
   private var fetchResultsController: NSFetchedResultsController<Fav_Mov_MO>!
    // Start Fetching Data From Core Data And Put it in favourites Array
    func FetchingData () {
    let fetchRequest : NSFetchRequest<Fav_Mov_MO> = Fav_Mov_MO.fetchRequest()
    let sortDiscriptor = NSSortDescriptor(key: "movie_name", ascending: true)
    fetchRequest.sortDescriptors = [sortDiscriptor]
   if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
       let context = appdelegate.persistentContainer.viewContext
       fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchResultsController.performFetch()
            if let fetchedobject = fetchResultsController.fetchedObjects{
                favourites = fetchedobject}}
        catch {
            print(error)
        }}}
    //--------------------------------------------------------------------
    func HeartButtonCheck(MovieName : String) -> Bool {
                FetchingData()
                for favourite in favourites {
                    if MovieName == favourite.movie_name {
                        chk_fav = favourite.is_fav
                        break
                    }}
                if chk_fav == nil {
                   return false
                }
        return chk_fav!
    }
    override init() {
        super.init()
        FetchingData()
    }
    //--------------------------------------------------------------------------
    func HeartButtonAction (MovieVm : MovieViewModel) -> Bool {
         switch chk_fav {
              case false:
                          chk_fav = true
                  if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                                  let favourite = Fav_Mov_MO(context: appdelegate.persistentContainer.viewContext)
                    favourite.movie_name = MovieVm.title
                      favourite.is_fav = true
                    favourite.poster_image = MovieVm.poster_path
                    favourite.backDrop_image = MovieVm.backdrop_path
                    favourite.rating = String (MovieVm.vote_average!)
                    favourite.release_date = MovieVm.release_date
                    favourite.summary = MovieVm.overview
                      appdelegate.saveContext()
                              }
              case true:
                        chk_fav = false
                  if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                                 let context = appdelegate.persistentContainer.viewContext
                      for favourite in favourites {
                        if MovieVm.title == favourite.movie_name {
                              fav = favourite
                              break
                          }}
                      guard let indexpath = self.fetchResultsController.indexPath(forObject: fav) else { return true }
                      let favouriteToDelete = self.fetchResultsController.object(at: indexpath)
                                 context.delete(favouriteToDelete)
                                 appdelegate.saveContext()
                             }
             case nil:
                         chk_fav = true
                if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                                let favourite = Fav_Mov_MO(context: appdelegate.persistentContainer.viewContext)
                  favourite.movie_name = MovieVm.title
                    favourite.is_fav = true
                  favourite.poster_image = MovieVm.poster_path
                  favourite.backDrop_image = MovieVm.backdrop_path
                  favourite.rating = String (MovieVm.vote_average!)
                  favourite.release_date = MovieVm.release_date
                  favourite.summary = MovieVm.overview
                    appdelegate.saveContext()
         }
              default:
                  print("Error")
         }
        FetchingData()
        return chk_fav ?? false
              }
    
    func SourceAt(indexpath : IndexPath) -> Fav_Mov_MO {
        FetchingData()
        return favourites[indexpath.row]
    }
    func ListNumber () -> Int {
        FetchingData()
        return favourites.count
    }
    func DeleteAll () {
        FetchingData()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
        for favourite in self.favourites {
            context.delete(favourite)
            appDelegate.saveContext()
    }}}
    func DeleteCellAt(indexpath : IndexPath) {
        if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appdelegate.persistentContainer.viewContext
            let favouriteToDelete = favourites[indexpath.row]
            context.delete(favouriteToDelete)
            appdelegate.saveContext()
        }}
    func MakeMovieModel (indexpath : IndexPath) -> MovieViewModel {
        FetchingData()
        let MovieVm = Movie_App_Intern.MovieViewModel()
        MovieVm.title = favourites[indexpath.row].movie_name ?? ""
        MovieVm.release_date = favourites[indexpath.row].release_date
        MovieVm.vote_average = Double(favourites[indexpath.row].rating ?? "")
        MovieVm.overview = favourites[indexpath.row].summary
        MovieVm.backdrop_path = favourites[indexpath.row].backDrop_image
        MovieVm.poster_path = favourites[indexpath.row].poster_image
        return MovieVm
    }
    
}

