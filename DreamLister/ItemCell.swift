//
//  ItemCell.swift
//  DreamLister
//
//  Created by Danil on 01.03.17.
//  Copyright © 2017 VoitenkoDaniel. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configureCell(item: Item) {
        itemImageView.image = item.toImage?.image as? UIImage
        titleLabel.text = item.title
        priceLabel.text = "$\(item.price)"
        detailsLabel.text = item.details
    }

}
