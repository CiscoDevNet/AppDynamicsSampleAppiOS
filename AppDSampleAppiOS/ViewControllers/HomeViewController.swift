//
//  HomeViewController.swift
//  AppDSampleAppiOS

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let content = Model().categoryTestData

    @IBOutlet var tableView: UITableView!
    var previouslySelectedIndexPath: IndexPath?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.title = "Home"
        
        printLog("Loaded Home Screen")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = previouslySelectedIndexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            previouslySelectedIndexPath = nil
        }
        
        suggestSimulator()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow,
           let categoryVC = segue.destination as? CategoryViewController {
            categoryVC.category = content[indexPath.row - 1]
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: HeadingCell = tableView.dequeueReusableCell(withIdentifier: CellID.headingCell.rawValue) as! HeadingCell
            return cell
        }
        let cell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: CellID.categoryCell.rawValue) as! CategoryCell
        let category: Category = content[indexPath.row - 1]
        cell.categoryLabel!.text = category.title
        cell.descriptionLabel!.text = category.caption
        cell.accessibilityIdentifier = category.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previouslySelectedIndexPath = indexPath
    }
    
    func suggestSimulator() {
        #if !(arch(i386) || arch(x86_64))
        let defaultsKey = "com.appdynamics.AppDSampleAppiOS.alreadySuggested"
        let isAlreadySuggested = UserDefaults.standard.bool(forKey: defaultsKey)
        if !isAlreadySuggested {
            let message = "For best results, run this app in the iOS Simulator so you can copy/paste sample code snippets from the app to your editor."
            let alert = UIAlertController(title: "Use Simulator", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            UserDefaults.standard.setValue(true, forKey: defaultsKey)
        }
        #endif
    }
}

