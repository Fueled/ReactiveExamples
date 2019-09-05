//
//  API+ReactiveSwift.swift
//  ReactiveSwiftExample
//
//  Created by Stéphane Copin on 9/5/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import API
import ReactiveSwift

extension API {
	private static func reactify<Result, Error: Swift.Error>(_ method: @escaping (@escaping (Swift.Result<Result, Error>) -> Void) -> Cancellable) -> SignalProducer<Result, Error> {
		return SignalProducer { observer, lifetime in
			let cancellable = method { result in
				switch result {
				case .failure(let error):
					observer.send(error: error)
				case .success(let result):
					observer.send(value: result)
					observer.sendCompleted()
				}
			}
			lifetime.observeEnded {
				cancellable.cancel()
			}
		}
	}

	static func signIn(username: String, password: String) -> SignalProducer<User, NetworkError> {
		return self.reactify { self.signIn(username: username, password: password, completion: $0) }
	}
}
