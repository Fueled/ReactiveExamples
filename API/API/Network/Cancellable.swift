//
//  Cancellable.swift
//  ReactiveExample
//
//  Created by Stéphane Copin on 8/1/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import Foundation

public protocol Cancellable: AnyObject {
	var isCancelled: Bool { get }

	func cancel()
}
