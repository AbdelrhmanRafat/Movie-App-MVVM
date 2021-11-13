//
//  FavouriteViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 08/02/2021.
//

import UIKit
import CoreData
class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var no_fav_view : UIView!
    @IBOutlet weak var DeleteAll: UIBarButtonItem!
    var favouriteVm : FavouriteListViewModels!
    var imageUrl = ConstantsUrls()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = no_fav_view
        no_fav_view.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = .white // make backButton Color white
        DeleteAll.tintColor = UIColor.clear
        favouriteVm = FavouriteListViewModels()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if favouriteVm.ListNumber() == 0 {
                tableView.separatorStyle = .none
                no_fav_view.isHidden = false
                DeleteAll.tintColor = UIColor.clear
                return 0
            }
            else {
                tableView.separatorStyle = .singleLine
                no_fav_view.isHidden = true
                DeleteAll.tintColor = UIColor.white
            }
            return favouriteVm.ListNumber()
        }
    @IBAction func Delete_All_Tap() {
        if favouriteVm.ListNumber() == 0 {
            return
        }
            let alertController = UIAlertController(title: "Are You Sure to Delete All Favourites", message: "", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { (action) in
                self.favouriteVm.DeleteAll()
                self.tableView.reloadData()
            }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(CancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender: self)
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fav_cell") as! FavouriteTableViewCell
            let favourite = favouriteVm.SourceAt(indexpath: indexPath)
            cell.Name.text = favourite.movie_name
            cell.Rate.text = favourite.rating
            cell.Release_Data.text = favourite.release_date
            cell.Poster_Image.downloaded(from: imageUrl.ImagesUrl(ImgString: favourite.poster_image!))
        //  Delete One Movie form Table View
           cell.handleDeleteMovie = {
                let alertController = UIAlertController(title: "Are you sure delete this from Favourites", message: "", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    self.favouriteVm.DeleteCellAt(indexpath: indexPath)
                    self.tableView.reloadData()
                    }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                self.present(alertController, animated: true, completion: nil)
           }
            return cell
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationController = segue.destination as? DetailViewController {
                    destinationController.MovieVm = favouriteVm.MakeMovieModel(indexpath: indexPath)
                }}}}
    
}

