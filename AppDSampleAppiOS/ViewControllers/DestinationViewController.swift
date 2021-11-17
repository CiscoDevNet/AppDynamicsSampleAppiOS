//
//  DestinationViewController.swift
//  AppDSampleAppiOS

import Foundation
import UIKit

class DestinationViewController: GenericLabelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        label.setFormatted(html: "<p>View Controller transition complete.</p>")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // After a delay, fade the label out and the button back in
        self.whatNextButton.alpha = 0.0
        self.whatNextButton.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.whatNextButton.alpha = 1.0
        })

    }
}

