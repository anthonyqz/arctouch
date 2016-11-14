//
//  UpcomingMoviesTableViewController.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import UIKit
import MagicalRecord
import PKHUD

class UpcomingMoviesTableViewController: UITableViewController {

    //MARK:- privates properties
    private var movies = [Movie]()
    private var isLoading = false
    private var indexPathSelected = IndexPath(row: 0, section: 0)
    private var searchText = ""
    
    //MARK:- readonly
    private var currentPage:Int {
        get {
            let page = UserDefaults.standard.integer(forKey: kCurrentPage)
            return page <= 0 ? 1 : page //force min 1
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kCurrentPage) //save the new page
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reset all
        currentPage = 1
        HUD.show(.progress)
        isLoading = true
        Genre.sync { [weak self] in
            guard let currentPage = self?.currentPage else { return }
            Movie.sync(withPage: currentPage) { [weak self] in
                self?.isLoading = false
                self?.reloadTableView()
                HUD.hide()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detail = segue.destination as? MovieDetailViewController
        detail?.movie = movies[indexPathSelected.row]
    }
    
    //MARK:- @IBAction methods
    @IBAction private func resetTableView(_ sender: UIRefreshControl) {
        //reset all
        currentPage = 1
        isLoading = true
        Movie.sync(withPage: currentPage) { [weak self] in
            self?.isLoading = false
            self?.reloadTableView()
            sender.endRefreshing()
        }
    }
    
    //MARK:- Private methods
    private func reloadTableView() {
        movies = Movie.getAll(bySearchText: searchText, orderBy: kOrder)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source & delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count == 0 ? 0 : movies.count + (searchText.characters.count == 0 ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == movies.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadMoreCell", for: indexPath)
            let activity = cell.viewWithTag(10) as? UIActivityIndicatorView
            activity?.startAnimating()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        let movie = movies[row]
        cell.configure(title: movie.title, genre: movie.genres, release: movie.releaseDate?.toString(dateStyle: .medium), fileImage: movie.posterPath)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == movies.count {
             return 45 //load more cell
        }
        return 108
    }
    
    // MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count {
            return
        }
        indexPathSelected = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    // MARK: - Scroll View delegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let posY = scrollView.contentOffset.y + scrollView.frame.size.height
        if posY >= scrollView.contentSize.height - 44 {
            if !isLoading && searchText.characters.count == 0 {
                currentPage = currentPage + 1
                isLoading = true
                Movie.sync(withPage: currentPage) { [weak self] in
                    self?.isLoading = false
                    self?.reloadTableView()
                }
            }
        }
    }
    
    // MARK: - UISearchBarDelegate View delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        reloadTableView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
