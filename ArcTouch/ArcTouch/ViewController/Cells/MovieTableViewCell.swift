//
//  MovieTableViewCell.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    //MARK: - @IBOutlet
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    
    //MARK: - Public methods
    func configure(title:String?, genre:String?, release:String?, fileImage:String?) {
        titleLabel.text = title
        genreLabel.text = genre
        releaseLabel.text = release
        movieImageView.image = nil
        ArcWebServices.download(imageName: fileImage) { [weak self] (image) in
            self?.movieImageView.image = image
        }
    }

}
