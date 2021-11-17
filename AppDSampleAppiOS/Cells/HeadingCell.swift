//
//  HeadingCell.swift
//  AppDSampleAppiOS

import UIKit

class HeadingCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        headingLabel.setFormatted(html: "<p style=\"line-height: 1.4;\"><strong>Welcome to the</br>AppDynamics iOS Sample App!</strong></p>Choose a category below to find sample code for a variety of app instrumentation scenarios.")
    }

}
