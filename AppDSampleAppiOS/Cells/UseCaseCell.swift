//
//  UseCaseCell.swift
//  AppDSampleAppiOS

import UIKit

class UseCaseCell: UITableViewCell {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var codePointerImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var codeTrailingConstraint: NSLayoutConstraint!
    
    var action: (() -> Void)?
    var snippet: String?
    var nextSteps: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .default
    }

    func configure(useCase: UseCase, snippet: String, buttonAccessibilityID: String?) {
        self.promptLabel.text = useCase.name
        self.accessibilityIdentifier = useCase.name
        self.resultLabel.text = useCase.prompt
        self.snippet = snippet
        if let accessID = buttonAccessibilityID {
            self.codeButton.accessibilityIdentifier = accessID
        }
        if useCase.isCodeOnlyCell {
            self.codeTrailingConstraint.constant = 48.0
            self.accessoryType = .none
            self.selectionStyle = .none
        }
        else {
            self.codeTrailingConstraint.constant = 20.0
        }
    }

}
