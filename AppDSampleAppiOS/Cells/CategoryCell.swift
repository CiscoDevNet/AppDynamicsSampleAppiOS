//
//  CategoryCell.swift
//  AppDSampleAppiOS

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .default
        self.configureLabel()
    }

    func configureLabel() {
        self.categoryLabel.text = "category"
        self.descriptionLabel.text = "description"
    }

}
