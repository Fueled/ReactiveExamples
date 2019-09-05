//
//  HomeViewController.swift
//  RxSwiftExample
//
//  Created by Stéphane Copin on 9/16/19.
//  Copyright © 2019 Stéphane Copin. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
	var viewModel: HomeViewModel!

	private var usernameLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.usernameLabel.text = self.viewModel.user.username
	}

	override func loadView() {
		self.usernameLabel = UILabel()
		self.usernameLabel.textAlignment = .center
		self.usernameLabel.backgroundColor = .white
		self.view = self.usernameLabel
	}
}
