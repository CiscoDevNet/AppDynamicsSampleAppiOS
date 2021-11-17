//
//  SessionStartEndViewController.swift
//  AppDSampleAppiOS

import UIKit
import ADEUMInstrumentation

class SessionStartEndViewController: GenericLabelViewController {
    
    @IBOutlet weak var startNextSessionButton: UIButton!
    @IBOutlet weak var newSessionStartedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newSessionStartedLabel.alpha = 0.0
        self.label.setFormatted(html: "<p>When an app is first launched, the AppDynamics mobile agent starts a session to record and delineate flows of usage in the app, which is subsequently shown in your Controller.<p>A session is deemed to have ended after a period of inactivity, or if the app is launched again. The <strong><span class=\"code\">startNextSession()</span></strong> API lets you override this and force an immediate cutover to a new session.</p>")
    }

    @IBAction func startNextSessionTapped(_ sender: Any) {
        // Example: Start next session

        // Import may be needed for use:
        // import ADEUMInstrumentation
        
        // Sessions are ended automatically after a
        // period of inactivity. However, they can also
        // be ended at any time by invoking this optional
        // method, which forces an end to the current
        // session.
        
        // You can use this to mark the end of an
        // interaction flow of some significance to
        // your app, and, by implication, the
        // beginning of a new flow. Please read the
        // comments in the public interface (header)
        // file ADEumInstrumentation_interfaces.h
        // for more details about Sessions.
        
        // Note that the case for the prefix of the
        // class here (ADEum) differs from the case
        // (ADEUM) for the header import statement.
        
        ADEumInstrumentation.startNextSession()
        
        // end example

        indicateSessionChangeover()
    
    }
    
    func indicateSessionChangeover() {
        
        // Temporarily replace the "Start Next Session" button with a label to
        // show "Started new session" before fading the button back into view.

        // First, instantly hide the button and show the label
        startNextSessionButton.alpha = 0.0
        newSessionStartedLabel.alpha = 1.0

        // Bounce the label size
        UIView.animate(withDuration: 0.2, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.newSessionStartedLabel.transform = scaleTransform
            self.whatNextButton.alpha = 0.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.whatNextButton.isHidden = false
                self.newSessionStartedLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        })

        // After a delay, fade the label out and the button back in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.75, execute: {
            UIView.animate(withDuration: 1.0, animations: {
                self.newSessionStartedLabel.alpha = 1.0
                self.whatNextButton.alpha = 1.0
            })
        })
    }

}

