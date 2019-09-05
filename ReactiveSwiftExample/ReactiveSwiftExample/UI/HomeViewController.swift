//
//  HomeViewController.swift
//  ReactiveSwiftExample
//
//  Created by Stéphane Copin on 9/5/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import ReactiveSwift
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
