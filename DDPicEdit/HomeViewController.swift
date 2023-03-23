//
//  HomeViewController.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/19.
//

import UIKit

class HomeViewController: UITableViewController {
    
    enum HomeMenu: CaseIterable, HomeMenuProtocol {
        case edit
        case capture
        
        var title: String {
            switch self {
            case .edit:
                return "Edit"
            case .capture:
                return "Capture"
            }
        }
        
        var controller: UIViewController {
            let style: UITableView.Style
            if #available(iOS 13.0, *) {
                style = .insetGrouped
            } else {
                style = .grouped
            }
            switch self {
            case .edit:
                return DDPicEditViewController(style: style)
            case .capture:
                return DDPicCaptureViewController(style: style)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DDPicEdit"

        self.tableView.registerCellClasses(classes: [UITableViewCell.self])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeMenu.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = HomeMenu.allCases[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(HomeMenu.allCases[indexPath.row].controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Options"
    }
}
