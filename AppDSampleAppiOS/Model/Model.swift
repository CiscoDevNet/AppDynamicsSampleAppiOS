//
//  Model.swift
//  AppDSampleAppiOS

import Foundation
import SwiftUI


struct Snippet : Codable {
    let name: String
    let content: String
}


typealias UseCaseUserData = [String:Any]

struct UseCase: Identifiable {
    var id = UUID()
    var name: String
    var prompt: String
    var result: String
    var icon: String = "empty"
    var isPushSuppressedOnDidSelect: Bool = false
    var isCodeOnlyCell: Bool = false
    var snippetKey: String? = nil
    var snippet: String =
        """
        /**
         This shows the instrumentation code for the feature. In many cases, no code is needed.
        **/
        """
    var segueID: String? = nil
    var userData: UseCaseUserData? = nil
    var nextSteps: String?
}


class Model {

    var snippets: [String:String] = [:]
    
    init() {
        let snippets = loadSnippets(from: "auto-generated-snippets")
        self.snippets = snippets
    }

    func genericNextSteps(insertXcode: String = "", insertCloud: String = "") -> String {
        let genericNextSteps =
        """
        For a debugging-oriented usage, assuming you are running this app while tethered to Xcode, you can now look in the Xcode console to see instrumentation packets show up shortly in JSON format. (This logging is enabled by a .loggingLevel setting which you can see in the agent configuration code, and use in your own app.)
        FEATURE_SPECIFIC_XCODE_STEPS
        For a more day-to-day usage that reflects how you would normally access the data generated by your installed user base, visit your AppDynamics Controller, and watch for the corresponding instrumented events to show up there.
        FEATURE_SPECIFIC_CLOUD_STEPS
        Note that for both the Xcode console, and your Controller, updates are only sent periodically, so there is a delay before results are seen. The default update interval is five minutes.
        """

        let intermediate = genericNextSteps.replacingOccurrences(of: "FEATURE_SPECIFIC_XCODE_STEPS", with: insertXcode)
        
        let result = intermediate.replacingOccurrences(of: "FEATURE_SPECIFIC_CLOUD_STEPS", with: insertCloud)
        
        return result
    }

    func loadSnippets(from fileName: String) -> [String:String] {
        var dict: [String:String] = [:]
        let decoder = JSONDecoder()
        guard
             let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
             let data = try? Data(contentsOf: url),
             let snippets = try? decoder.decode([Snippet].self, from: data)
        else {
             return dict
        }
        for snippet in snippets {
            dict[snippet.name] = snippet.content
        }
        return dict
    }
    
    lazy var categoryTestData: [Category] = {
        return prepareData()
    }()

    func prepareData() -> [Category] {
        let data = [
        Category(name: "Features",
                 title: "Features",
                 caption: "Learn how to instrument anything from regular user interactions to custom instrumentation scenarios.",
                 toolbarImage: nil,
                 hasProgress: false,
                 useCases: [
                    UseCase(name: "Start App",
                            prompt: "For simple and advanced startup options, please see code sample.",
                            result: "App launched",
                            isPushSuppressedOnDidSelect: true,
                            isCodeOnlyCell: true,
                            snippetKey: "App Start"
                    ),
                    UseCase(name: "View Controller Transition Tracking",
                            prompt: "Instrument transition from one view controller to another",
                            result: "Transitioned",
                            snippetKey: "View Controller tracking",
                            segueID: "CategoryToDestinationSegueID",
                            nextSteps: genericNextSteps(insertXcode: "\nYou can find and inspect this View Controller Transition event in the Xcode Console logs by searching for \"viewControllerUuid\".\n")
                    ),
                    UseCase(name: "Start Next Session",
                            prompt: "Force an end to the current session, and the creation of a new one",
                            result: "New session started",
                            snippetKey: "Start next session",
                            segueID: "CategoryToSessionSegueID",
                            nextSteps: genericNextSteps(insertXcode: "\nEach time this is invoked (and after each new app start) your logs should show a higher value for the \"sessionCounter\" field of the instrumentation JSON payload.\n")
                    ),
                    UseCase(name: "Breadcrumb",
                            prompt: "Leave a custom breadcrumb",
                            result: "Breadcrumb created",
                            snippetKey: "Leaving a breadcrumb",
                            segueID: "CategoryToBreadcrumbSegueID",
                            nextSteps: genericNextSteps(insertXcode: "\nTo see the JSON for this in the Xcode Console, search for the string \"breadcrumb\" and inspect the value of the \"text\" field, which should be \"sample2\" in this case.\n")
                    ),
                    UseCase(name: "Periodic Screenshots",
                            prompt: "Get periodic screenshots of activity as app is used",
                            result: "Screenshot captured",
                            isPushSuppressedOnDidSelect: true,
                            isCodeOnlyCell: true,
                            snippetKey: "Periodic screenshots"
                    )
        ]),
        Category(name: "Networking",
                 title: "Networking",
                 caption: "Learn about advanced network request instrumentation as well as basic instrumentation that requires no code.",
                 toolbarImage: nil,
                 hasProgress: false,
                 useCases: [
                    UseCase(name: "Network request success",
                            prompt: "Send a successful request with a 200 response code",
                            result: "Network request succeeded with response code 200",
                            snippetKey: "Instrumenting network calls",
                            segueID: "CategoryToNetworkResultSegueID",
                            userData: [
                                "url": "https://www.appdynamics.com/"
                            ],
                            nextSteps: genericNextSteps(insertXcode: "\nSearch the Xcode Console for \"network-request\" and then inspect the value of the \"hrc\" (for \"Human Readable Code\") field, to see this in a debugging session.\n")
                    ),
                    UseCase(name: "Network request POST",
                            prompt: "Send a successful POST request with custom headers and payload",
                            result: "Network request succeeded",
                            snippetKey: "Instrumenting network calls",
                            segueID: "CategoryToNetworkResultSegueID",
                            userData: [
                                "url": "https://httpbin.org/post",
                                "method": "POST"
                            ],
                            nextSteps: genericNextSteps(insertXcode: "\nSearch the Xcode Console for \"network-request\" and then inspect the value of the \"hrc\" (for \"Human Readable Code\") field, to see this in a debugging session.\n")
                    ),
                    UseCase(name: "Excluded URL Patterns",
                            prompt: "Please see code example",
                            result: "Please see code example",
                            isPushSuppressedOnDidSelect: true,
                            isCodeOnlyCell: true,
                            snippetKey: "Excluded URL patterns",
                            segueID: "CategoryToNetworkResultSegueID"
                    ),
        ]),
        Category(name: "Error Conditions",
                 title: "Error Conditions",
                 caption: "Learn how failing network requests, crashes, and other errors are instrumented.",
                 toolbarImage: nil,
                 hasProgress: false,
                 useCases: [
                    UseCase(name: "Application Not Responding (ANR)",
                            prompt: "Instrumentation that detects and reports cases where the application main thread is blocked for too long.",
                            result: "Main thread blocked",
                            snippetKey: "ANR",
                            segueID: "ErrorsToANRSegueID",
                            nextSteps: genericNextSteps()
                    ),
                    UseCase(name: "Report Error",
                            prompt: "Granular intervention to have an error of special importance, along with a detailed stack trace, reported up to the cloud.",
                            result: "Error tracked and sent to cloud.",
                            snippetKey: "Reporting selected errors",
                            segueID: "ErrorsToErrorSegueID",
                            nextSteps: genericNextSteps(insertXcode: "\nAfter invoking this, you will be able to find the string \"type\" : \"error\" (with all the quotes) in the Xcode Console. You can see that the JSON packet for the error contains an entire stack trace for each thread, and is thus quite heavy, so use of this feature with stack trace enabled is not recommended for everyday errors, as it can generate high network traffic with potential battery impact for your users.\n")
                    ),
                    UseCase(name: "Network request 404",
                            prompt: "Send a request that fails with a 404 status code",
                            result: "Network request failed with code 404",
                            snippetKey: "Instrumenting network calls",
                            segueID: "ErrorsToNetworkResultSegueID",
                            userData: [
                                "url": "https://httpstat.us/404"
                            ],
                            nextSteps: genericNextSteps(insertXcode: "\nSearch the Xcode Console for \"network-request\" and then inspect the value of the \"hrc\" (for \"Human Readable Code\") field, to see this in a debugging session.\n")
                    ),
                    UseCase(name: "Network request 500",
                            prompt: "Send a request that fails with a 500 status code",
                            result: "Network request failed with code 500",
                            snippetKey: "Instrumenting network calls",
                            segueID: "ErrorsToNetworkResultSegueID",
                            userData: [
                                "url": "https://httpstat.us/500"
                            ],
                            nextSteps: genericNextSteps(insertXcode: "\nSearch the Xcode Console for \"network-request\" and then inspect the value of the \"hrc\" (for \"Human Readable Code\") field, to see this in a debugging session.\n")
                    ),
                    UseCase(name: "Network request timeout",
                            prompt: "Send a request that fails with a timeout",
                            result: "Network request failed with timeout",
                            snippetKey: "Network request timeout",
                            segueID: "ErrorsToNetworkResultSegueID",
                            userData: [
                                "url": "https://httpstat.us/200?sleep=20000",
                                "customTimeoutMS": TimeInterval(5000)
                            ],
                            nextSteps: genericNextSteps(insertXcode: "\nSearch the Xcode Console for \"network-request\" and then inspect the value of the \"hrc\" (for \"Human Readable Code\") field, to see this in a debugging session.\n")
                    ),
                    UseCase(name: "Viewing Crash Data",
                            prompt: "Crash this app to allow subsequent inspection of captured crash log in Xcode console.",
                            result: "Crashing in 10 seconds...",
                            snippetKey: "Crash reporting",
                            segueID: "ErrorsToCrashSegueID"
                    ),
        ])
        ]
        return data
    }

}

