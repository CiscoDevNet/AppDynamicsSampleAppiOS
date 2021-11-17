//
//  ErrorViewController.swift
//  AppDSampleAppiOS

import UIKit
import ADEUMInstrumentation

class ErrorViewController: GenericLabelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        induceError()
        // After a delay, fade the label out and the button back in
        self.whatNextButton.alpha = 0.0
        self.whatNextButton.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.whatNextButton.alpha = 1.0
        })
    }

    func induceError() {
        // Example: Reporting selected errors

        // Here we conduct an operation that we know
        // will fail (attempting to read the contents
        // of a directory that does not exist), in
        // order to demonstrate how to use the
        // reportError() feature.
        
        let fm = FileManager.default
        do {
            let path = "/no-such-path"
            // normally we would do let foo = fm.contentsOf...
            // but here we are just going for the error.
            try fm.contentsOfDirectory(atPath: path)
        } catch let error {
            
            // Instrument the error
            ADEumInstrumentation.reportError(error, withSeverity: .warning)
            
            let message = "Error: \(error.localizedDescription)"
            label.text = message
            print(message)
        }
        // end example
    }

//    - (BOOL)networkRequestCallback:(ADEumHTTPRequestTracker *)networkRequest


    
    //
    
    // end example
    
    
}
