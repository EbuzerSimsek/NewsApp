//
//  NewsCell.swift
//  NewsApp
//
//  Created by Ebuzer Şimşek on 28.04.2023.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var headLabel: UILabel!
    
    @IBOutlet weak var newsExplanation: UILabel!
    
    @IBOutlet var CustomImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
