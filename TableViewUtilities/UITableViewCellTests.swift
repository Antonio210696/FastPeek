//
//  File.swift
//  FastPeek
//
//  Created by Antonio Epifani on 16/03/22.
//  Copyright © 2022 Antonio Epifani. All rights reserved.
//

import XCTest
import UIKit
import Reusable

open class UITableViewCellTests<Cell>: UIPreparedTestCase, UITableViewDelegate, UITableViewDataSource where Cell: UITableViewCell & Reusable {
    
    public var viewController: TableTestableViewController?
    public var config: ((Cell) -> Void)?
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func registerCell() {
        tableView.register(cellType: Cell.self)
    }
    
    public var cell: Cell {
        tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! Cell
    }
    
    public var renderedCell: Cell {
        tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! Cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        config?(cell)
        
        return cell
    }
    
    open override func setUp() {
        super.setUp()
        viewController = TableTestableViewController()
        self.registerCell()
        self.viewController?.tableView = self.tableView
        
        setRootViewController(to: self.viewController)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
