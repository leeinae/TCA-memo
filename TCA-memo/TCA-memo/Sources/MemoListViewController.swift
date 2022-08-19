//
//  ViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/18.
//

import UIKit

class MemoListViewController: UITableViewController {
    // MARK: - UI Components

    lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperty()
    }

    func setupProperty() {
        title = "Memo"
        view.backgroundColor = .white

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addButtonItem
    }

    func setupLayout() {}

    // MARK: - Actions

    @objc
    func didTapAddButton(_ sender: UIBarButtonItem) {
        print("add button")
    }
}

extension MemoListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .checkmark
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
