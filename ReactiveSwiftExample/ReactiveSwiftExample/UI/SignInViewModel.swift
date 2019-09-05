//
//  SignInViewModel.swift
//  ReactiveExample
//
//  Created by Stéphane Copin on 9/4/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import API
import Foundation
import ReactiveSwift

struct SignInViewModel {
	let username = MutableProperty<String?>(nil)
	let password = MutableProperty<String?>(nil)

	let signInAction: Action<(username: String, password: String), User, NetworkError>

	init() {
		let isValidated = Property.combineLatest(
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
