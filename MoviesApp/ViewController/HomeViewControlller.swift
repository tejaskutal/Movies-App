//
//  ViewController.swift
//  MoviesApp
//
//  Created by admin on 18/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var results : MovieResults?
    var arrMovieList: [MovieInfo]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let client = NetworkClient()
        client.fetchMovieList { data in
            self.arrMovieList = data?.results
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMovieList?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = arrMovieList?[indexPath.row]
        cell.lblMovieTitle?.text = movie?.title
        cell.lblReleaseDate?.text = movie?.release_date
        cell.lblDescription?.text = movie?.overview
        let downloadedImage = Constant.MOVIE_POSTER_PATH + (movie?.poster_path ?? "")
        
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
        let alert = UIAlertController(title: "", message: "Do you wish to mark this movie as 'Watch Later?'", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            print("YES")
            let cell = self.tableView.cellForRow(at: indexPath) as! MovieTableViewCell
            print(cell.lblMovieTitle.text!)
            DispatchQueue.main.async {
                guard let favMovie = CoreDataManager.shared.createFavMovie(name: cell.lblMovieTitle.text!, releaseDate: cell.lblReleaseDate.text!, description: cell.lblDescription.text!) else { return }
                print(favMovie)
                
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            print("NO")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
