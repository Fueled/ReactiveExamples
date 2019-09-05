//
//  SignInViewModel.swift
//  RxSwiftExample
//
//  Created by Stéphane Copin on 9/16/19.
//  Copyright © 2019 Stéphane Copin. All rights reserved.
//

import Action
import API
import Foundation
import RxRelay
import RxSwift

struct SignInViewModel {
	let username = BehaviorRelay<String?>(value: nil)
	let password = BehaviorRelay<String?>(value: nil)

	let signInAction: Action<(username: String, password: String), User>

	init() {
		let isValidated = BehaviorRelay.combineLatest(
			self.username,
			self.password
		).map { SignInViewModel.validateInputs(username: $0, password: $1) }
		self.signInAction = Action(enabledIf: isValidated) { API.signIn(username: $0.username, password: $0.password) }
	}

	private static func validateInputs(username: String?, password: String?) -> Bool {
		let username = username ?? ""
		let password = password ?? ""
		return !username.trimmingCharacters(in: .whitespaces).isEmpty
			&& password.trimmingCharacters(in: .whitespaces).count >= 6
	}
}
