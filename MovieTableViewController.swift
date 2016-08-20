//
//  MovieTableViewController.swift
//  MovieSong
//
//  Created by Jim Campagno on 8/20/16.
//  Copyright © 2016 Gamesmith, LLC. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    let movieManager = MovieManager()
    var searchTerm: String = String() {
        didSet {
            title = searchTerm
            movies.removeAll()
            searchForMovie()
        }
    }

    var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTerm = "Love"
        
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        
        print("view did Load is happening.")
        
    }
    
    func searchForMovie() {
        searchButton.enabled = false
        try! movieManager.search(forFilmsWithTitle: searchTerm) { [unowned self] movies, error in
            print("Back in block - \(error)")
            guard let newMovies = movies else { return }
            self.movies = newMovies
            self.searchButton.enabled = true
            
        }

        
        
    }
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Movie count is \(movies.count)")
        return movies.count % 2 == 0 ? movies.count / 2 : (movies.count / 2) + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieTableViewCell
        

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let movieCell = cell as! MovieTableViewCell
        
    
        if indexPath.row == 0 {
            let firstFilm = movies[indexPath.row]
            movieCell.movieView.leftBasicMovieView.movie = firstFilm
            if indexPath.row + 1 <= movies.count {
                let secondFilm = movies[indexPath.row + 1]
                movieCell.movieView.rightBasicMovieView.movie = secondFilm
            }
        } else {
            
            let index = indexPath.row * 2
            let firstFilm = movies[index]
            movieCell.movieView.leftBasicMovieView.movie = firstFilm
            if index + 1 <= movies.count {
                let secondFilm = movies[index + 1]
                movieCell.movieView.rightBasicMovieView.movie = secondFilm
            }

        }
        
    }

}

// MARK: Segue Methods

extension MovieTableViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! SearchViewController
        destVC.searchDelegate = self
    }
}

extension MovieTableViewController: SearchDelegate {
    
    func search(withTitle title: String) {
        searchTerm = title
    }
}

//MARK: Can Display Image Delegate Methods

extension MovieTableViewController: CanDisplayImageDelegate {
    
    func canDisplayImage(view: BasicMovieView) -> Bool {
        let viewableCells = tableView.visibleCells as! [MovieTableViewCell]
        for cell in viewableCells {
            if cell.movieView.leftBasicMovieView.hasMovie { if view.movie.title == cell.movieView.leftBasicMovieView.movie.title  { return true } }
            if cell.movieView.rightBasicMovieView.hasMovie { if view.movie.title == cell.movieView.rightBasicMovieView.movie.title  { return true } }
        }
        return false
    }
}