//
//  TableTestableViewController.swift
//  FastPeek
//
//  Created by Antonio Epifani on 16/03/22.
//  Copyright © 2022 Antonio Epifani. All rights reserved.
//

import UIKit

public class TableTestableViewController: UIViewController {
    public weak var tableView: UITableView? {
        didSet {
            configureTableViewInside()
        }
    }
    
    private func configureTableViewInside() {
        guard let tableView = tableView else { return }
        
        view.addSubview(tableView)
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
