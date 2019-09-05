//
//  SignInViewController.swift
//  ReactiveExample
//
//  Created by Stéphane Copin on 8/1/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import API
import UIKit

final class SignInViewController: UIViewController {
	private var usernameTextField: UITextField!
	private var passwordTextField: UITextField!
	private var activityIndicatorView: UIActivityIndicatorView!
	private var signInButton: UIButton!

	private var runningCancellables: [Cancellable] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		self.signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .primaryActionTriggered)
		self.signInButton.isEnabled = self.validateInputs()

		self.passwordTextField.isSecureTextEntry = true

		[
			self.usernameTextField,
			self.passwordTextField,
		].forEach { NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeHandler(_:)), name: UITextField.textDidChangeNotification, object: $0) }
	}

	deinit {
		self.runningCancellables.forEach { $0.cancel() }
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

	@objc private func textDidChangeHandler(_ notification: Notification) {
		switch notification.object as? UITextField {
		case self.usernameTextField?,
				 self.passwordTextField?:
			self.signInButton.isEnabled = self.validateInputs()
		default:
			fatalError("Unknown object: \(String(describing: notification.object))")
		}
	}

	private func validateInputs() -> Bool {
		let username = self.usernameTextField.text ?? ""
		let password = self.passwordTextField.text ?? ""
		return !username.trimmingCharacters(in: .whitespaces).isEmpty
			&& password.trimmingCharacters(in: .whitespaces).count >= 6
	}

	@objc private func signInButtonTapped(_ button: UIButton) {
		self.signInButton.isEnabled = false
		self.activityIndicatorView.isHidden = false
		self.activityIndicatorView.startAnimating()
		self.runningCancellables.append(API.signIn(username: self.usernameTextField.text!, password: self.passwordTextField.text!) { [unowned self] result in
			switch result {
			case .failure(let error):
				let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alertController, animated: true, completion: nil)
			case .success(let user):
				let homeViewController = HomeViewController()
				homeViewController.user = user
				self.navigationController?.show(homeViewController, sender: nil)
			}
			self.signInButton.isEnabled = true
			self.activityIndicatorView.isHidden = true
			self.activityIndicatorView.stopAnimating()
		})
	}
}
