//
//  ListTableViewCell.swift
//  Assessment
//
//  Created by Geniusjames on 31/07/2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = "ListTableViewCell"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var localNameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    static func toNib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup(with city: City) {
        cityLabel.text = city.name
        localNameLabel.text = city.localName
        if let lat = city.lat, let lng = city.lng {
            latitudeLabel.text = "\(lat)"
            longitudeLabel.text = "\(lng)"
        }
    }
    
    
}
