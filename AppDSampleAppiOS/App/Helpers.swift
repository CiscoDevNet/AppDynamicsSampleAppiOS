//
//  Helpers.swift
//  AppDSampleAppiOS

import UIKit
import SwiftUI
import Foundation


// Log wrapper for logging simple life cycle events in
// the app. This is a minimal implementation intended
// only to fulfill Cisco requirements for adding a unique
// app identifier to log output, and should not be used
// for reference. We use this instead of print() to avoid
// unwanted interleaving of messages in the Console.
func printLog(_ message: StaticString) {
    let args: [CVarArg] = []
    withVaList(args) {
        // args and $0 are just dummies here, to satisfy
        // the function signature.
        NSLogv("\(AppDConstants.appID): \(message)", $0)
    }
}


extension UIButton {
    func parentCell() -> UITableViewCell? {
        var view: UIView? = self as UIView
        while view != nil {
            if let cell = view as? UITableViewCell {
                return cell
            }
            view = view?.superview
        }
        return nil
    }
}


public struct AppDConstants {
    
    static var appID: String = {
            let appIDString = UUID().uuidString
            return appIDString
    }()
    
    static let backgroundUIColor = UIColor(ciColor: .white)
    static let foregroundUIColor = UIColor(ciColor: .black)
    static let background = Color(backgroundUIColor)
    static let foreground = Color(foregroundUIColor)
    static let button = Color(red: 0x2e/0xff, green: 0x33/0xff, blue: 0x37/0xff)
    static let notificationBackground = Color(red: 0xc8/0xff, green: 0x5c/0xff, blue: 0x5c/0xff)
    
}

func appearanceHelper() {
    let appdBackgroundColor = AppDConstants.backgroundUIColor
    let appdForegroundColor = AppDConstants.foregroundUIColor
    UITableView.appearance().backgroundColor = appdBackgroundColor
    UINavigationBar.appearance().backgroundColor = appdBackgroundColor
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: appdForegroundColor]
    UITabBar.appearance().backgroundColor = .green
}

extension String {
    
    func asCodeExampleAccessibilityIdentifier() -> String {
        return "Code example for " + self
    }
    
    func htmlStyleWrapped() -> String {
        
        let fontSize = String(format: "%.f", 15.0)
        let style =
        """
        <style>
        li:not(:first-child) { margin-top: 8pt; }
        li:not(:last-child) { margin-bottom: 8pt; }
        .code { font-family: "Courier New", monospace; }
        </style>
        """

        let wrapped = String(format:"<head>%@</head>\n<body>\n<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)pt;\">%@</span>\n</body>", style, self)
        
        return wrapped
    }
    
    func attributedHTML() -> NSAttributedString? {
        
        var result: NSAttributedString? = nil
        let wrapped = self.htmlStyleWrapped()
        let stringData = Data(wrapped.utf8)

        if let attributedString = try? NSMutableAttributedString(data: stringData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            attributedString.addAttributes([.foregroundColor:UIColor.label], range: NSMakeRange(0, attributedString.length))
            result = attributedString
        }
        return result
    }
}

extension UILabel {
    func setFormatted(html: String) {
        if let attributed = html.attributedHTML() {
            self.attributedText = attributed
        }
    }
}

