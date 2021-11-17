//
//  CategoryViewController.swift
//  AppDSampleAppiOS

import UIKit
import SwiftUI
import ADEUMInstrumentation

// for later:
//        ADEumInstrumentation.beginCall(self, selector: #function)
//        ADEumInstrumentation.leaveBreadcrumb("my breadcrumb")

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var previouslySelectedIndexPath: IndexPath?
    var userData: UseCaseUserData?
    var category: Category?
    let snippets = Model().snippets
    var nextSteps: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        printLog("Loaded Category Screen")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userData = nil
        if let indexPath = previouslySelectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            previouslySelectedIndexPath = nil
        }
        self.navigationItem.title = category?.name
    }
    
    // Example: View Controller tracking
    //
    // No user code needed!
    //
    // Transitions to and from different view
    // controller classes will be tracked and
    // reported along with the name of the
    // involved view controller class.
    // end example
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.useCases.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UseCaseCell = tableView.dequeueReusableCell(withIdentifier: CellID.useCaseCell.rawValue) as! UseCaseCell
        if let useCase = category?.useCases[indexPath.row] {
            let parsedSnippet = snippetParser(useCase: useCase, snippets: snippets)
            cell.configure(useCase: useCase, snippet: parsedSnippet.snippet, buttonAccessibilityID: parsedSnippet.identifier)
        }
        return cell as UITableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previouslySelectedIndexPath = indexPath
        if let useCase = category?.useCases[indexPath.row],
            let segueID = useCase.segueID {
            if let userData = useCase.userData {
                self.userData = userData // used in prepare(for segue..)
            }
            if let nextSteps = useCase.nextSteps {
                self.nextSteps = nextSteps // used in prepare(for segue..)
            }
            if !useCase.isPushSuppressedOnDidSelect {
                performSegue(withIdentifier: segueID, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        previouslySelectedIndexPath = nil
        self.userData = nil
        self.nextSteps = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Handle code snippet button
        if let button = sender as? UIButton, let buttonCell = button.parentCell() as? UseCaseCell {
            if let codeVC = segue.destination as? CodePopoverViewController,
                let snippet = buttonCell.snippet {
                codeVC.snippet = snippet
            }
        }
        else {

            // Not a code button, normal transition
            
            // Set up "Next Steps" instructions if any
            if let destVC = segue.destination as? GenericLabelViewController, let instructions = nextSteps {
                destVC.nextSteps = instructions
            }
            
            // Special handling for network examples
            if segue.identifier == "ErrorsToNetworkResultSegueID"
                || segue.identifier == "CategoryToNetworkResultSegueID" {
                if let userData = self.userData,
                    let url = userData["url"] as? String,
                    let destination = segue.destination as? NetworkResultViewController {
                    destination.url = URL(string: url)
                    if let method = userData["method"] as? String {
                        destination.method = method
                    }
                    if let timeout = userData["customTimeoutMS"] as? TimeInterval {
                        destination.timeoutMilliseconds = timeout
                        destination.labelStartingValue = "The request will time out in \(Int(timeout / 1000)) seconds."
                    }
                }
            }
        }
    }

}


// Helper functions

func snippetParser(useCase: UseCase, snippets: [String:String]) -> (identifier: String?, snippet: String) {
    // The useCase may have a key into our collection of snippets.
    // Or, it may have simply a hard coded snippet. The key approach
    // is useful to have, as we can use that key to build an
    // accessibilityIdentifier for the snippet code button (used both
    // for accessibility, and also for testing). The hard coded
    // snippet works otherwise. This helper just hides that
    // complexity to help keep the code cleaner.
    var identifier: String? = nil
    var snippet = useCase.snippet // fallback if no snippetKey
    if let key = useCase.snippetKey,
        let keyedSnippet = snippets[key] {
        snippet = keyedSnippet
        identifier = key.asCodeExampleAccessibilityIdentifier()
    }
    return (identifier, snippet)
}

