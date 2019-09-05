//
//  HomeViewController.swift
//  ReferenceExample
//
//  Created by Stéphane Copin on 9/5/19.
//  Copyright © 2019 Fueled. All rights reserved.
//

import API
import UIKit

final class HomeViewController: UIViewController {
	var user: User!

	private var usernameLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.usernameLabel.text = self.user.username
	}

	override func loadView() {
		self.usernameLabel = UILabel()
		self.usernameLabel.textAlignment = .center
		self.usernameLabel.backgroundColor = .white
		self.view = self.usernameLabel
	}
}
