//
//  MovieDetailViewController.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK: - internal properties
    var movie:Movie?
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie?.title
        genreLabel.text = movie?.genres
        releaseLabel.text = movie?.releaseDate?.toString(dateStyle: .medium)
        movieImageView.image = nil
        
        ArcWebServices.download(imageName: movie?.posterPath) { [weak self] (image) in
            self?.movieImageView.image = image
        }
    }
    

}
