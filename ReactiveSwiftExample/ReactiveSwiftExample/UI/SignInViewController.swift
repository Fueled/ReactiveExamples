//
//  SignInViewController.swift
//  ReactiveExample
//
//  Created by Stéphane Copin on 8/1/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

final class SignInViewController: UIViewController {
	private var usernameTextField: UITextField!
	private var passwordTextField: UITextField!
	private var activityIndicatorView: UIActivityIndicatorView!
	private var signInButton: UIButton!

	let viewModel = SignInViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.activityIndicatorView.reactive.isHidden <~ self.viewModel.signInAction.isExecuting
		self.activityIndicatorView.reactive.isAnimating <~ self.viewModel.signInAction.isExecuting
		self.signInButton.reactive.pressed = CocoaAction<UIButton>(self.viewModel.signInAction) { [viewModel] _ in
			return (viewModel.username.value!, viewModel.password.value!)
		}

		self.passwordTextField.isSecureTextEntry = true

		self.viewModel.username <~ self.usernameTextField.reactive.continuousTextValues
		self.viewModel.password <~ self.passwordTextField.reactive.continuousTextValues

		self.viewModel.signInAction.errors.observeValues { [unowned self] error in
			let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alertController, animated: true, completion: nil)
		}

		self.viewModel.signInAction.values.observeValues { [unowned self] user in
			let homeViewController = HomeViewController()
			homeViewController.viewModel = HomeViewModel(user: user)
			self.navigationController?.show(homeViewController, sender: nil)
		}
	}

	override func loadView() {
		let containerView = UIView()
		containerView.backgroundColor = .white
		let stackView = UIStackView()
		stackView.spacing = 16.0
		stackView.axis = .vertical

		func label(_ string: String) -> UILabel {
			let label = UILabel()
			label.text = string
			label.numberOfLines = 0
			return label
		}

		self.usernameTextField = UITextField()
		self.passwordTextField = UITextField()
		self.signInButton = UIButton(type: .system)
		self.signInButton.setTitle("Sign In", for: .normal)

		[
			label("Username:"),
			self.usernameTextField!,
			label("Password:\n(Must have 6 characters or more)"),
			self.passwordTextField!,
			self.signInButton!,
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			stackView.addArrangedSubview($0)
		}

		self.activityIndicatorView = UIActivityIndicatorView(style: .gray)
		self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

		stackView.translatesAutoresizingMaskIntoConstraints = false
		[
			stackView,
			self.activityIndicatorView!,
		].forEach { containerView.addSubview($0) }

		NSLayoutConstraint.activate([
			stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75),
			stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
			stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			self.activityIndicatorView.leadingAnchor.constraint(equalTo: self.signInButton.leadingAnchor),
			self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.signInButton.centerYAnchor),
		])
		self.view = containerView
	}
}
