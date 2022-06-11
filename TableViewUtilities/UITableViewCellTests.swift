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

/// This class provides utilities to test table cells in isolation. By default, it provides an already initialized
/// view controller and tableview. In order to test consistently the layout of the cell, ``renderedCell``
/// can be used to retrieve the already laid out cell, with the appearance shown on the screen.
/// As this class inherits from ``UIPreparedTestCase``, it is always highly recommended to wait for the view controller to appear
/// with ``waitForViewControllerToAppear``.
open class UITableViewCellTests<Cell>: UIPreparedTestCase, UITableViewDelegate, UITableViewDataSource where Cell: UITableViewCell & Reusable {
    
    public var viewController: TableTestableViewController?
    
    /// This callback is called in the ``tableView(_:cellForRowAt:)`` method,
    /// before the cell is returned. Any configuration for the cell in the test can be specified here
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
    
    /// Use this variable to retrieve the result of ``tableView(_:cellForRowAt:)`` return value
    public var cell: Cell {
        tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! Cell
    }
    
    /// Use this variable to retrieve the already laid out cell in the table view. This cell will have
    /// stable graphical properties and can be used to test for layout correctness
    public var renderedCell: Cell {
        tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! Cell
    }
    
    /// This is the implementation for the UITableViewDataSource protocol to which this class adheres.
    /// You shouldn't be overriding this method, and if you wish to configure the cell to be tested, you should be
    /// assigning ``config`` variable
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(for: indexPath)
        config?(cell)
        
        return cell
    }
    
    /// When overriding this method to configure setup before your tests, remember to call this implementation with ``super``
    /// otherwise, all the utilities of this class will not work
    open override func setUp() {
        super.setUp()
        viewController = TableTestableViewController()
        self.registerCell()
        self.viewController?.tableView = self.tableView
        
        setRootViewController(to: self.viewController)
    }

    /// Override this method if you want to display more cells of the same type.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Override this method if you want to display more sections.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
