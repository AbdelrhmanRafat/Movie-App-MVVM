//
//  DetailViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 08/02/2021.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    // Outlets
    @IBOutlet var BackDrop_Image : UIImageView! {
        didSet {
            BackDrop_Image.downloaded(from: imageUrl.ImagesUrl(ImgString: MovieVm.backdrop_path!))
        }}
    @IBOutlet var fav_button : UIButton!
    @IBOutlet var tableView : UITableView!
    //----------------------------------------------------------------------
    var MovieVm : MovieViewModel!
    var imageUrl = ConstantsUrls()
    var favouriteVm : FavouriteListViewModels!
    // End of Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.tintColor = .white // make backButton Color white
        favouriteVm = FavouriteListViewModels()
    }
    override func viewWillAppear(_ animated: Bool) {
        if favouriteVm.HeartButtonCheck(MovieName: MovieVm.title){
            if let image = UIImage(systemName: "heart.fill"){
                    fav_button.setImage(image, for: .normal)}
        }
        else {
            if let image = UIImage(systemName: "heart"){
                    fav_button.setImage(image, for: .normal)}
        }}
    @IBAction func Tapped_fav(_ sender: Any) {
        if favouriteVm.HeartButtonAction(MovieVm: MovieVm) {
            if let image = UIImage(systemName: "heart.fill"){
                    fav_button.setImage(image, for: .normal)}
        }
        else {
            if let image = UIImage(systemName: "heart"){
                    fav_button.setImage(image, for: .normal)}
        }}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MD") as! MovieDetailsTableViewCell
            cell.Name.text = MovieVm.title
            cell.Rate.text = String (MovieVm.vote_average!)
            cell.Release_Data.text = MovieVm.release_date
            cell.Poster_Image.downloaded(from: imageUrl.ImagesUrl(ImgString: MovieVm.poster_path!))
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "D") as! DescriptionTableViewCell
            cell.Description.text = MovieVm.overview
            cell.selectionStyle = .none
            return cell
        default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
        }}}
