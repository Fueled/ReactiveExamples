//
//  API+RxSwift.swift
//  RxSwiftExample
//
//  Created by Stéphane Copin on 9/16/19.
//  Copyright © 2019 Stéphane Copin. All rights reserved.
//

import API
import RxSwift

extension API {
	private static func rxify<Result, Error: Swift.Error>(_ method: @escaping (@escaping (Swift.Result<Result, Error>) -> Void) -> Cancellable) -> Single<Result> {
		return Single.create { single in
			let cancellable = method { result in
				switch result {
				case .failure(let error):
					single(.error(error))
				case .success(let result):
					single(.success(result))
				}
			}
			return Disposables.create {
				cancellable.cancel()
			}
		}
	}

	static func signIn(username: String, password: String) -> Single<User> {
		return self.rxify { self.signIn(username: username, password: password, completion: $0) }
	}
}
