//
//  ViewController.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var activityIndicatorSecond: UIActivityIndicatorView!
    
    private var apiMovies: APIMovies = APIMovies()
    private var movies: [Movies] = []
    private var originalMovies: [Movies] = []
    private var img: UIImage = UIImage() 
    
    private var isLoading = true {
        didSet {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) { [unowned self] in
                self.activityIndicator.isHidden                     = !self.isLoading
                self.lblActivity.isHidden                           = !self.isLoading
                self.viewActivity.isHidden                          = !self.isLoading
                self.activityIndicator.startAnimating()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        
        self.activityIndicatorSecond.isHidden = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 22)!
        ]
        self.setNeedsStatusBarAppearanceUpdate()
        UINavigationBar.appearance().titleTextAttributes    = attrs
        self.navigationController?.isNavigationBarHidden    =  true
        self.isLoading = true
        
        self.tableView.tableFooterView              = UIView(frame: CGRect.zero)
        self.tableView.rowHeight                    = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight          = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 30
        self.tableView.estimatedRowHeight           = 125
        
        let nib = UINib(nibName: "MoviesCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        self.apiMovies.searchMoviesRequest { [weak self] object, error in
            DispatchQueue.main.async { [weak self] in
                guard let obj = object as? [Movies] else {
                    Alert.alert(msg: error ?? "Error fetching movies") {
                        self?.isLoading = false
                    }
                    return
                }
                self?.requestImage(object: obj.first!)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func validImage() {
        let realm = try! Realm()
        let moviesNoImage = realm.objects(Movies.self).filter { !$0.hasImage }
        
        if let first = moviesNoImage.first {
            
            self.requestImage(object: first)
        } else {
            self.movies            = Array(realm.objects(Movies.self).sorted(byKeyPath: "release_date", ascending: false))
            self.originalMovies    = Array(realm.objects(Movies.self).sorted(byKeyPath: "release_date", ascending: false))
            
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.navigationController?.isNavigationBarHidden    =  false
            }

            let when = DispatchTime.now() + 0.8
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                UIView.animate(withDuration: 0.8) { [weak self] in
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func requestImage(object: Movies) {
        let imageString = !object.backdrop_path.isEmpty ? object.backdrop_path : object.poster_path
        if !imageString.isEmpty {
            self.apiMovies.searchPhotosRequest(idMovie: object.id, isPoster: false, photoString: imageString, completion: { [weak self] img, error in
                DispatchQueue.main.async { [weak self] in
                    guard ((img as? UIImage) != nil) else {
                        Alert.alert(msg: error ?? "Error fetching image") {
                            self?.isLoading = false
                        }
                        return
                    }
                    self?.validImage()
                }
            })
        }
    }
    
    private func requestImagePoster(movie: Movies) {
        
        self.activityIndicatorSecond.isHidden = false
        self.activityIndicatorSecond.startAnimating()
        self.tableView.allowsSelection = false
        
        self.apiMovies.searchPhotosRequest(idMovie: movie.id, isPoster: true, photoString: movie.poster_path, completion: { [weak self] img, error in
            DispatchQueue.main.async { [weak self] in
                
                self?.activityIndicatorSecond.isHidden = true
                self?.activityIndicatorSecond.stopAnimating()
                self?.tableView.allowsSelection = true
                
                guard img != nil else {
                    Alert.alert(msg: error ?? "Error fetching image")
                    return
                }
                let vc      = DetailMovieViewController(nibName: "DetailMovieViewController", bundle: nil)
                vc.movie    = movie
                self?.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    deinit {
        print("DEALLOC \(self)")
    }
}

// ----------------------------------------------------------------------------------------------------------------
/* UITableViewDelegate */
// ----------------------------------------------------------------------------------------------------------------
extension HomeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard currentReachabilityStatus != .notReachable else {
            Alert.alert(msg: "Dont have connection internet")
            return
        }
        
        let movie   = self.movies[indexPath.section]
        self.requestImagePoster(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height: 18))
        let label               = UILabel(frame: CGRect(x:8, y:5, width:tableView.frame.size.width, height: view.bounds.height))
        label.font              = UIFont(name: "Optima-Bold", size: 16)
        label.textColor         = UIColor.white
        label.text              = self.movies[section].release_date != nil ? self.movies[section].release_date?.string(withFormat: "dd-MM-yyyy") : Date().string(withFormat: "dd-MM-yyyy")
        view.addSubview(label)
        view.backgroundColor    = UIColor(hex: 0x232323)
        return view
    }
}

// ----------------------------------------------------------------------------------------------------------------
/* UITableViewDataSource */
// ----------------------------------------------------------------------------------------------------------------
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
         return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.movies[section].release_date?.string(withFormat: "dd-MM-yyyy")
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MoviesCell ?? MoviesCell(style: .default, reuseIdentifier: "Cell")
        self.configureCell(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: MoviesCell, atIndexPath indexPath: IndexPath) {
        let movie = self.movies[indexPath.section]
        cell.lblTitle.text      = movie.title
        cell.imgMovie.image     = movie.imagePreview != nil ? movie.imagePreview : #imageLiteral(resourceName: "nameApp")
        cell.lblPopularity.text = "Popularity: \(String(movie.popularity))"
        cell.lblVote.text       = "Vote: \(String(movie.vote_count))"
        cell.lblLanguage.text   = movie.original_language
        cell.selectionStyle     = .none
    }
}

// ----------------------------------------------------------------------------------------------------------------
/* SEARCH BAR DELEGATE */
// ----------------------------------------------------------------------------------------------------------------
extension HomeViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.movies = searchBar.text != nil && searchBar.text!.isEmpty ? self.originalMovies : self.originalMovies.filter({ $0.original_title.range(of: searchBar.text!.lowercased(), options: .caseInsensitive) != nil })
        self.tableView.reloadData()
        
        if searchBar.text != nil && searchBar.text!.isEmpty {
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
        return true
    }
}
