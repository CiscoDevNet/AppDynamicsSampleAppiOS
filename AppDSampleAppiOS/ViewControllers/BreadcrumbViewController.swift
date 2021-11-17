//
//  BreadcrumbViewController.swift
//  AppDSampleAppiOS

import UIKit
import ADEUMInstrumentation


class BreadcrumbViewController: GenericLabelViewController {

    @IBOutlet var breadcrumbButton: UIButton!
    @IBOutlet var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.setFormatted(html: "<p>For this demo, the word \"sample2\" (to correspond to the second example in the sample code snippet shown for this feature) is hard coded as the breadcrumb value, but in your code the breadcrumb value can be any string of your choosing.</p>")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultLabel.alpha = 0.0
    }

    @IBAction func breadcrumbButtonTapped(_ sender: Any) {

        
        // Example: Leaving a breadcrumb
        
        // Import may be needed for use:
        // import ADEUMInstrumentation
        //
        // Note that the case for the prefix of the class
        // here (ADEum) differs from the case (ADEUM) for
        // for the header import statement.
        //
        // The breadcrumb value can be any string of your
        // choosing, including strings dynamically chosen
        // or built at runtime based on state in your app.
        //
        // A crashes-only breadcrumb is the default, and
        // is preferred because it avoids needlessly
        // polluting your cloud data with redundant string
        // values when there are no crashes.
        //
        // Crashes-only breadcrumbs are only sent up to
        // the cloud if the prior run of the app crashed.
        //
        // To make best use of crashes-only breadcrumbs,
        // place them in code leading up to places where
        // crashes have been detected, or are suspected.
        // This way you can then inspect any such
        // breadcrumbs that show up, to learn which code
        // paths were followed, and which which values were
        // present, prior to the crash you are debugging.

        // Leave a breadcrumb with value "sample1", which
        // only gets sent (next run) if there is a crash.
        ADEumInstrumentation.leaveBreadcrumb("sample1")

        // Alternatively, you can create breadcrumbs that
        // always get sent, not only after crashes, but
        // also when any session ends, as shown below:

        // Leave a breadcrumb with the value "sample2",
        // which gets sent upon end of session or after
        // any crash.
        ADEumInstrumentation.leaveBreadcrumb("sample2", mode:
            ADEumBreadcrumbVisibility.crashesAndSessions)

        // end example
        
        indicateBreadcrumbGenerated()
        
    }
    
    func indicateBreadcrumbGenerated() {
        
        // Temporarily replace the "Generate Breadcrumb" button with a label to
        // show "Breadcrumb Generated" before fading the button back into view.

        // First, instantly hide the button and show the label
        breadcrumbButton.alpha = 0.0
        resultLabel.alpha = 1.0

        // Bounce the label size
        UIView.animate(withDuration: 0.2, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.resultLabel.transform = scaleTransform
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.resultLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        })

        // After a delay, fade the label out and the button back in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.75, execute: {
            UIView.animate(withDuration: 1.0, animations: {
            }, completion: { _ in
                self.whatNextButton.alpha = 0.0
                self.whatNextButton.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.whatNextButton.alpha = 1.0
                }
            })
        })
    }

}
