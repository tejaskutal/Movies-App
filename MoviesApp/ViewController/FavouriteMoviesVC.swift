//
//  FavouriteMoviesVC.swift
//  MoviesApp
//
//  Created by admin on 19/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class FavouriteMoviesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var favMovie: [MovieFavourite]?
    @IBOutlet weak var lblNoMovies: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let favMovies : [MovieFavourite] = CoreDataManager.shared.fetchFavouriteMovies() {
            favMovie = favMovies
            if favMovies.count > 0 {
                lblNoMovies.isHidden = true
            }
            updateTableView()
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavouriteMoviesVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favMovie?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = favMovie?[indexPath.row]
        cell.lblMovieTitle?.text = movie?.name
        cell.lblReleaseDate?.text = movie?.releaseDate
        cell.lblDescription?.text = movie?.desc
        let downloadedImage = Constant.MOVIE_POSTER_PATH + (movie?.imageUrl ?? "")
        
        let client = NetworkClient()
        client.getImage(downloadedImage) { (image) in
            if let image = image
            {
                cell.imgMoviePoster.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie: MovieFavourite = (favMovie?[indexPath.row])!
        let alert = UIAlertController(title: "", message: "Do you wish to remove this movie from 'Watch Later?'", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            self.favMovie?.remove(at: indexPath.row)
            CoreDataManager.shared.deleteMovie(movie: selectedMovie)
            self.updateTableView()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            // Cancel action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
