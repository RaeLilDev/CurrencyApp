//
//  ExchangeRateTableViewCell.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/10/22.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    
    var data: LiveExchangeRateVO? {
        didSet {
            if let data = data {
                lblFrom.text = data.from
                lblTo.text = data.to
                lblRate.text = "\(data.rate)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
