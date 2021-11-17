//
//  NetworkResultViewController.swift
//  AppDSampleAppiOS

import UIKit

class NetworkResultViewController: GenericLabelViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url: URL?
    var method: String = "GET"
    var timeoutMilliseconds: TimeInterval?
    var labelStartingValue: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let startingValue = labelStartingValue else {
            label.setFormatted(html: "<p>Loading...</p>")
            return
        }
        label.setFormatted(html: "<p>\(startingValue)</p>")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let url = url {
            let request = networkRequest(for: url, method: method)
            makeNetworkCall(request: request)
        }
    }
    
    func makeNetworkCall(request: URLRequest) {
        
        guard let method = request.httpMethod else { return }

        let config = URLSessionConfiguration.ephemeral
        
        // Although this function is generic and used for all the networking
        // examples, this section is specific to just the timeout example.
        if let timeout = timeoutMilliseconds {
            // For timeouts we are showing just the request
            // timeout case, not the resource timeout case. See
            // https://libsdev.com/2020/02/16/two-timeouts-for-nsurlsession/
            config.timeoutIntervalForRequest = timeout / 1000
        }
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // No transport failure, but still need to check status code
                let statusCode = (response as! HTTPURLResponse).statusCode
                DispatchQueue.main.async {
                    self.label.setFormatted(html: "<p>\(method) request returned status code \(statusCode)</p>")
                    self.activityIndicator.stopAnimating()
                    self.revealWhatNext()
                }
            }
            else {
                // Failure
                DispatchQueue.main.async {
                    self.label.setFormatted(html: "<p>\(method) request failed with error: \(error!.localizedDescription)</p>")
                    self.activityIndicator.stopAnimating()
                    self.revealWhatNext()
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
    func networkRequest(for url: URL, method: String) -> URLRequest {
        
        // make request with example headers
        var request = URLRequest(url: url)
        request.addValue("example-header-value", forHTTPHeaderField: "x-example-header")
        request.addValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method

        // if it's a POST, add a body
        if request.httpMethod == "POST" {
            let bodyString = "{}"
            request.httpBody = bodyString.data(using: .utf8, allowLossyConversion: true)
        }
        return request
    }
    
    func revealWhatNext() {
        self.whatNextButton.alpha = 0.0
        self.whatNextButton.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.whatNextButton.alpha = 1.0
        })
    }
    
    // Example: Instrumenting network calls
    //
    // Network calls, whether successful or not, are
    // instrumented automatically without you adding any
    // code! So there is nothing to show here. There are
    // some advanced features that do require code, and
    // these are covered elsewhere:
    //
    // 1. Server Correlation Headers (see documentation at
    // https://docs.appdynamics.com/21.9/en/end-user-monitoring/mobile-real-user-monitoring/correlate-business-transactions-for-mobile-rum)
    //
    // 2. Excluded URL Patterns (prevent instrumentation
    //    of URLs matching regular expressions you
    //    specify)
    // end example

    
    // Example: Network request timeout
    //
    // No user code needed!
    //
    // As long as you have integrated the AppDynamics
    // agent into your app, you will get instrumentation
    // of network call events including timeouts by
    // default, without adding any additional code.
    //
    // When running an instrumented app such as this
    // one under Xcode, after a networking call has
    // completed, if you wish you can look at the JSON
    // instrumentation packets that appear in the Xcode
    // console to verify for yourself that the agent
    // has captured the networking activity as expected.
    // end example


}
