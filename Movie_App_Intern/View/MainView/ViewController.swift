//
//  ViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 06/02/2021.
//

import UIKit
class ViewController: UIViewController {
    // Outlets
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var NoConnectView : UIView!
    var MovieListViewModel : MovieListViewModels!
    var apiKey = ConstantsUrls.ApiKey.self
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = NoConnectView 
        collectionView.backgroundView?.isHidden = true // Hide The No Connection View As Default
        MovieListViewModel = MovieListViewModels(ApiKey: apiKey.popular, completion: {
        self.collectionView.reloadData()
        })}
    @IBAction func TryAgainAction(_ sender: Any) {
        MovieListViewModel = MovieListViewModels(ApiKey: apiKey.popular, completion: {
            self.collectionView.reloadData()
        })}
    @IBAction func Show_Menu(_ sender: Any) {
        var choice : String?
        let alertController = UIAlertController(title: "Choose", message: "Your List", preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        let popularAction = UIAlertAction(title: "popular", style: .default) { (action) in
            choice = "popular"
            self.MovieListViewModel.Toggle(choice: choice ?? "") {
                self.collectionView.reloadData()
            }}
        let top_ratedAction = UIAlertAction(title: "top-rated", style: .default) { (action) in
            choice = "top_Rated"
            self.MovieListViewModel.Toggle(choice: choice ?? "") {
                self.collectionView.reloadData()
            }}
        let go_to_favouriteAction = UIAlertAction(title: "Go to Favourites", style: .default) { (action) in
            self.performSegue(withIdentifier: "ShowFav", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(popularAction)
        alertController.addAction(top_ratedAction)
        alertController.addAction(cancelAction)
        alertController.addAction(go_to_favouriteAction)
        self.present(alertController, animated: true, completion: nil)
    }}
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MovieListViewModel.ListNumber() == 0 {
            NoConnectView.isHidden = false
        }
        else {
            NoConnectView.isHidden = true
        }
       return MovieListViewModel.ListNumber()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                layout collectionViewLayout: UICollectionViewLayout,
                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Movie_Poster_Cell", for: indexPath) as! MoviesCollectionViewCell
        cell.Movie_image.downloaded(from: MovieListViewModel.PosterImage(index: indexPath))
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let cell = sender as? UICollectionViewCell,
                let indexPath = self.collectionView.indexPath(for: cell) {
                 let vc = segue.destination as! DetailViewController
                vc.MovieVm = MovieListViewModel.SourceAt(index: indexPath)
        }}}}
