//
//  CrashDemoViewController.swift
//  AppDSampleAppiOS

import UIKit

class CrashDemoViewController: GenericLabelViewController {

    static let crashDelay =  5.0

    @IBOutlet var button: UIButton!

    var count = CrashDemoViewController.crashDelay
    var timer: Timer?
    var preamble = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        button.isEnabled = false
        button.accessibilityIdentifier = "Crash"
        label.accessibilityIdentifier = "Crash label"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let unc = UNUserNotificationCenter.current()
        unc.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                self.preamble = "<p>You will be prompted to allow notifications.</p>"
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        button.isEnabled = !isDebuggerAttached
        label.setFormatted(html: promptHTML(forDebuggingState: isDebuggerAttached))
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func countdownToCrash() {

        let displayCount = Int(count)
        self.label.text = "Crashing in \(displayCount) seconds..."
        count = count - 0.01

        if count < 1.0 {
            self.timer?.invalidate()
            
            // Example: Crash reporting
            
            // Note that you need not add any code in order
            // to get crash reporting. As long as you have
            // initialized the agent (covered in the App
            // Start sample code) then you will have crash
            // reporting on by default.
            
            // (It is also possible to instead turn crash
            // reporting off, by setting the public
            // crashReportingEnabled flag of the configuration
            // object to false, but you would do this at agent
            // initialization time, typically in the
            // AppDelegate. We don't want to do that here in
            // this demonstration, so we have commented it out):
            
            /*
            // How to initialize with crash reporting off:
            let config = ADEumAgentConfiguration(appKey: "<YOUR-APP-KEY>")
            config.crashReportingEnabled = false
             ...
            ADEumInstrumentation.initWith(config)
            */
 
            // After a crash, the agent will gather the crash
            // data and forward it to the cloud the next time
            // the user launches the app.
            
            // Here, for demonstration purposes, we have
            // intentionally added a call to fatalError() to
            // invoke a crash.
            
            // Obviously you would not do this in your shipping
            // production app!
            
            fatalError()
            
            // end example
        }
    }

    func prepareForCrash() {
        
        // Set up the callback that will be run when the prompt for authorization is complete.
        let nc = NotificationCenter.default
        let main = OperationQueue.main
        let name = Notification.Name("prompted")
        nc.addObserver(forName: name, object: nil, queue: main) {
            note in
            self.startCountdown()
        }
        
        // Do the prompt. The above observer callback is called when this is done.
        promptForAuthorizationIfNeeded()
    }
    
    func startCountdown() {

        // Crash button has been tapped already
        button.isEnabled = false
        
        // Even if we did not obtain authorization, it is harmless to still schedule this local notification, which the system will silently drop in that case.
        scheduleLocalNotification()

        // This timer is unrelated to the "schedule" above... it is used to update a countdown timer label.
        timer =  Timer.scheduledTimer(timeInterval: 0.01, target: self, selector:#selector(CrashDemoViewController.countdownToCrash), userInfo: nil, repeats: true)

    }

    func promptForAuthorizationIfNeeded() {
        
        // Used for our internal notification that prompting of the user for local notification authorization is done
        let nc = NotificationCenter.default
        
        // Used for generating the local notification
        let unc = UNUserNotificationCenter.current()

        unc.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else {
                    unc.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            print("error: " + String(describing: error.localizedDescription))
                        }
                        // Case where we prompted the user for the first time. Whether permission was granted or not, this notification that the user prompt has finished kicks off the countdown.
                        nc.post(name: Notification.Name("prompted"), object: nil)
                    }
                    return
            }
            // Case where authorization was previously asked for. We need both of these cases because of the asynchronous nature of the UI presenting the prompt in the other case.
            nc.post(name: Notification.Name("prompted"), object: nil)
        }
    }
    
    func scheduleLocalNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "App crashed."
        content.body = "Crash report will be sent on next launch."
        
        // Show local notification immediately after crash
        let notificationDelay = 1.0
        let triggerDelay = CrashDemoViewController.crashDelay + notificationDelay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:triggerDelay, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        let unc = UNUserNotificationCenter.current()
        unc.add(request) { (error) in
            if let error = error {
                print("error: " + String(describing: error.localizedDescription))
            }
        }
    }

    @IBAction func crashButtonTapped(_ sender: Any) {
        // Prepare for crash prompts the user, if needed, for permission to use local notifications. It then kicks off the countdown timer.
        prepareForCrash()
    }

    func promptHTML(forDebuggingState isDebugging: Bool) -> String {
        if isDebugging {
            return "<p><strong>To try this feature:</strong></p><ol><li>Detach from the Xcode debugger</li><li>Restart the app</li><li>Return to this screen and tap the \"Crash\" button below.</li></ol>"
        } else {
            return "\(preamble)<p><strong>Viewing Crash Data... <i>read first!</i></strong></p><p>Crash data is normally viewed in your Controller. However, to see the data in Xcode, whether to increase your understanding or for debugging:</p><ol><li>After the crash, re-run in Xcode using <br/><strong>Product&nbsp;->&nbsp;Run</strong></li><li>Open the Xcode Console using <strong>View&nbsp;-> Debug&nbsp;Area&nbsp;-> Activate&nbsp;Console</strong></li></ol><br/>Crash data appears in the Console. It cannot be sent at crash time, since the app is no longer active. It is only sent the next time the app runs."
        }
    }
}


// The following code is based on this blog post:
// https://christiantietze.de/posts/2019/07/swift-is-debugger-attached/
// Also seen in a slightly edited form here:
// https://stackoverflow.com/questions/4744826/detecting-if-ios-app-is-run-in-debugger/56836695#56836695

fileprivate let isDebuggerAttached: Bool = {
    var debuggerIsAttached = false

    var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var info: kinfo_proc = kinfo_proc()
    var info_size = MemoryLayout<kinfo_proc>.size

    let success = name.withUnsafeMutableBytes { (nameBytePtr: UnsafeMutableRawBufferPointer) -> Bool in
        guard let nameBytesBindMemory = nameBytePtr.bindMemory(to: Int32.self).baseAddress else { return false }
        return -1 != sysctl(nameBytesBindMemory, 4, &info/*UnsafeMutableRawPointer!*/, &info_size/*UnsafeMutablePointer<Int>!*/, nil, 0)
    }

    if !success {
        debuggerIsAttached = false
    }

    if !debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0 {
        debuggerIsAttached = true
    }

    return debuggerIsAttached
}()
