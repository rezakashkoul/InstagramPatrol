//
//  SearchTableViewCell.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    fileprivate func setupCell() {
        profileImage.layer.cornerRadius = 25
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}