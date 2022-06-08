//
//  TestableViewController.swift
//  FastPeek
//
//  Created by Antonio Epifani on 16/03/22.
//  Copyright © 2022 Antonio Epifani. All rights reserved.
//

import UIKit
import XCTest

/// Used to provide expectations to let test synchronize with view life cycle
public protocol ViewLifeCycleNotifier: UIViewController {
    var viewAppearedExpectation: XCTestExpectation? { get set }
    var subviewsLaidOutExpectation: XCTestExpectation? { get set }
}

public extension XCTestCase {
    func waitForViewControllerToAppear(_ viewController: ViewLifeCycleNotifier) {
        viewController.viewAppearedExpectation = expectation(description: "view controller did appear")
        wait(for: [viewController.viewAppearedExpectation!], timeout: 3)
    }
    
    func waitForViewControllerToLayoutSubviews(_ viewController: ViewLifeCycleNotifier) {
        viewController.subviewsLaidOutExpectation = expectation(description: "view controller laid out subviews")
        wait(for: [viewController.subviewsLaidOutExpectation!], timeout: 3)
    }
    
    func waitForViewControllerToDisappear(_ viewController: ViewLifeCycleNotifier) {
        viewController.viewDisappearedExpectation = expectation(description: "view controller did appear")
        wait(for: [viewController.viewDisappearedExpectation!], timeout: 3)
    }
}
