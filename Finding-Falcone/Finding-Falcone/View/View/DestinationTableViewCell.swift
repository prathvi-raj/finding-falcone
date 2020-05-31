//
//  DestinationTableViewCell.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var planetLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    
    func configure(data: DestinationTableViewCellData) -> Void {
        planetLabel.text = data.planetLabel
        vehicleLabel.text = data.vehicleLabel
    }
}
