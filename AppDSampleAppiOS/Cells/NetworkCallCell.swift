//
//  NetworkCallCell.swift
//  AppDSampleAppiOS

import UIKit

// This class is reserved for future use.

class NetworkCallCell: UseCaseCell {

    var url: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure(useCase: UseCase, snippet: String, buttonAccessibilityID: String?) {
        if let userData = useCase.userData,
            let urlString = userData["url"] as? String {
            self.url = URL(string: urlString)
        }
        super.configure(useCase: useCase, snippet: snippet, buttonAccessibilityID: buttonAccessibilityID)
    }
    
}
