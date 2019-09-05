//
//  API.swift
//  ReactiveExample
//
//  Created by Stéphane Copin on 8/1/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import Foundation

public enum API {
	// A stub representation a network operation.
	private final class NetworkOperation: Cancellable {
		private(set) var isCancelled: Bool = false

		func cancel() {
			self.isCancelled = true
		}
	}

	public static func signIn(username: String, password: String, completion: @escaping (Result<User, NetworkError>) -> Void) -> Cancellable {
		let operation = NetworkOperation()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			if operation.isCancelled {
				return
			}

//			if username == "Stephane" && password == "fueled" {
				completion(.success(User(id: "6D371B44-6451-4B1E-9AE6-FDEED25E1101", username: username)))
//				return
//			}
//			completion(.failure(.signIn))
		}
		return operation
	}

	private final class BundleHelper {
	}

	private static var sortedAnimals: [Animal] = {
		var animals = NSArray(contentsOf: Bundle(for: BundleHelper.self).url(forResource: "Animals", withExtension: "plist")!) as! [String]
		animals.sort()
		return animals.map(Animal.init)
	}()

	public static func fetchAllAnimals(start: Int, count: Int, completion: @escaping (Result<(animals: [Animal], hasMore: Bool), NetworkError>) -> Void) -> Cancellable {
		let operation = NetworkOperation()
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			if operation.isCancelled {
				return
			}

			let start = max(0, min(self.sortedAnimals.count, start))
			let end = min(start + count, self.sortedAnimals.count)
			completion(.success((Array(self.sortedAnimals[start..<end]), end < self.sortedAnimals.count)))
		}
		return operation
	}
}
