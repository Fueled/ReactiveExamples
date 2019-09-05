//
//  SignInViewController.swift
//  RxSwiftExample
//
//  Created by Stéphane Copin on 9/16/19.
//  Copyright © 2019 Stéphane Copin. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class SignInViewController: UIViewController {
	private var usernameTextField: UITextField!
	private var passwordTextField: UITextField!
	private var activityIndicatorView: UIActivityIndicatorView!
	private var signInButton: UIButton!

	private let disposeBag = DisposeBag()

	let viewModel = SignInViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.viewModel.signInAction.executing.bind(to: self.activityIndicatorView.rx.isHidden)
			.disposed(by: self.disposeBag)
		self.viewModel.signInAction.executing.bind(to: self.activityIndicatorView.rx.isAnimating)
			.disposed(by: self.disposeBag)
		self.viewModel.signInAction.enabled.bind(to: self.signInButton.rx.isEnabled)
			.disposed(by: self.disposeBag)
		self.signInButton.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { [viewModel] _ in
			self.viewModel.signInAction.execute((viewModel.username.value!, viewModel.password.value!))
		}).disposed(by: self.disposeBag)

		self.passwordTextField.isSecureTextEntry = true

		self.usernameTextField.rx.text.bind(to: self.viewModel.username)
			.disposed(by: self.disposeBag)
		self.passwordTextField.rx.text.bind(to: self.viewModel.password)
			.disposed(by: self.disposeBag)

		self.viewModel.signInAction.errors.subscribe(onNext: { [unowned self] error in
			let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alertController, animated: true, completion: nil)
		}).disposed(by: self.disposeBag)

		self.viewModel.signInAction.elements.subscribe(onNext: { [unowned self] user in
			let homeViewController = HomeViewController()
			homeViewController.viewModel = HomeViewModel(user: user)
			self.navigationController?.show(homeViewController, sender: nil)
		}).disposed(by: self.disposeBag)
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
