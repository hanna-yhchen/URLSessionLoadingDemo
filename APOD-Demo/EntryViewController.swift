//
//  EntryViewController.swift
//  APOD-Demo
//
//  Created by Hanna Chen on 2022/5/12.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Astronomy Picture of the Day"
    }


    @IBSegueAction func show(_ coder: NSCoder, sender: Any?) -> ViewController? {
        guard let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let method = LoadingMethod(rawValue: indexPath.row)
        else {
            return nil
        }

        return ViewController(coder: coder, method: method)
    }
}

extension EntryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "methodCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        switch indexPath.row {
        case 0:
            content.text = "Completion Handler with Result Type"
        case 1:
            content.text = "Async Function"
        case 2:
            content.text = "Combine"
        case 3:
            content.text = "Generic Service Protocol"
        default:
            break
        }

        cell.contentConfiguration = content
        return cell
    }
}

extension EntryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
