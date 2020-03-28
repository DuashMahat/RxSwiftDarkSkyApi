//
//  CellTableViewCell.swift
//  WeatherData
//
//  Created by Duale on 3/26/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var daylabel: UILabel!
    @IBOutlet weak var imagelabel: UIImageView!
    @IBOutlet weak var maxlabel: UILabel!
    @IBOutlet weak var minlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func updateCell ( day: String , maxt: String , mint: String ) {
        daylabel.text = day
        maxlabel.text = maxt
        minlabel.text = mint
    }
    
    func updateCellImage (image: UIImage) {
        imagelabel.image = image
    }
}
