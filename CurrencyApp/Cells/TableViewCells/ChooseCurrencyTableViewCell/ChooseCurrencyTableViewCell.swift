//
//  ChooseCurrencyTableViewCell.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import UIKit

class ChooseCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var btnOverlay: UIButton!
    
    var data: CurrencyVO? {
        didSet {
            if let data = data {
                lblCurrency.text = data.key
                lblFullName.text = data.fullName
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        btnOverlay.isHidden = !selected
        
    }
    
}
