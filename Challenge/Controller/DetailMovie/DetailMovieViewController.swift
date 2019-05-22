//
//  DetailMovieViewController.swift
//  Challenge
//
//  Created by Matias Borges Evalte on 20/05/19.
//  Copyright © 2019 Matias Borges Evalte. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {
 
    @IBOutlet weak var imageBackgroundMovie: UIImageView!
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblIndicative: UILabel!
    @IBOutlet weak var lblTitleMovie: UILabel!
    
    private var apiMovies: APIMovies = APIMovies()
    public weak var movie: Movies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie"
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.imageBackgroundMovie.image     = self.movie.imagePreviewPoster ?? #imageLiteral(resourceName: "nameApp")
        self.lblOverView.text               = self.movie.overview
        self.imageHeader.image              = self.movie.imagePreview != nil ? self.movie.imagePreview : #imageLiteral(resourceName: "nameApp")
        self.lblDate.text                   = self.movie.release_date?.string(withFormat: "yyyy")
        self.lblIndicative.text             = self.movie.adult ? "Adult indicative" : "Kid indicative"
        self.lblTitleMovie.text             = self.movie.title
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.imageBackgroundMovie.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageBackgroundMovie.addSubview(blurEffectView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTouchClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("DEALLOC \(self)")
    }
}
