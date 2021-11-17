//
//  ANRViewController.swift
//  AppDSampleAppiOS

import UIKit

class ANRViewController: GenericLabelViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var hangButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.setFormatted(html: "Try scrolling the text view below. Then tap the <strong>Hang main thread for ten seconds</strong> button below and try again.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundView.isHidden = false
        self.hangButton.isHidden = false
    }
    
    @IBAction func hangButtonTapped(_ sender: Any) {
        navigationItem.hidesBackButton = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            self.label.setFormatted(html: "<strong>* Main thread blocked for ten seconds. Notice that you are now unable to scroll or otherwise change the text in the text box.*</strong>")
            self.label.textAlignment = .center
            self.hangButton.isEnabled = false
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
            
            // Example: ANR
            
            // To enable Application Not Responding detection and
            // reporting, you must set the anrDetectionEnabled
            // property of the ADEumAgentConfiguration instance
            // object to true prior to initializing the agent with
            // the configuration object:
            /*
             let config = ADEumAgentConfiguration(appKey: "<YOUR-APP-KEY>")
             config.anrDetectionEnabled = true
             ... do additional configuration settings ...
             ADEumInstrumentation.initWith(config)
             */
            // You can also ask for stack traces showing execution
            // context in proximity to the ANR, with:
            // config.anrStackTraceEnabled = true
            // However, there can be no guarantee that these stack
            // traces directly correspond to the cause of the ANR,
            // so their utility is limited and turning them on is
            // not recommended in most cases.
            
            // To force an ANR, such as for testing, invoke a
            // sleep on the main thread as in this example:
            /*
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 10.0)
            }
             */
            // Of course, this is something you would only do for
            // testing, debugging, or, as we are doing here, for
            // demonstrating ANR functionality. It should
            // generally not be done in a shipping app.
            
            // Once enabled, ANR detection works without any
            // additional code. Also, once enabled, it can be
            // controlled (turned off and back on, timeout value
            // updated, and stack trace option turned on or off)
            // on a per-app key basis through server side
            // configuration.
            // end example
            
            Thread.sleep(forTimeInterval: 10.0)
            
            self.label.setFormatted(html: "<p><strong>ANR Event Completed</strong></p><p>At this point the agent should have detected the ANR (hang) event, which will appear in the Xcode Console sometime in the next five minutes if you are running under the debugger.</p><p>Note that to enable this feature, we had to set <strong><span class=\"code\">anrDetectionEnabled</span></strong> to true in our configuration object when initializing the agent in the App Delegate (see the sample code linked on the previous screen for more).</p>")
            self.label.textAlignment = .natural
            self.backgroundView.isHidden = true
            self.hangButton.isEnabled = true
            self.hangButton.isHidden = true
            self.navigationItem.hidesBackButton = false
            self.whatNextButton.alpha = 0.0
            self.whatNextButton.isHidden = false
            UIView.animate(withDuration: 1.0, animations: {
                self.whatNextButton.alpha = 1.0
            })
        })
    }


}
