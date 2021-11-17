//
//  GenericLabelViewController.swift
//  AppDSampleAppiOS

import UIKit

class GenericLabelViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var whatNextButton: UIButton!
    var nextSteps: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        whatNextButton.isHidden = true
        super.viewDidDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextStepsVC = segue.destination as? NextStepsPopoverViewController, let instructions = nextSteps {
            nextStepsVC.instructions = instructions
        }
    }

}
