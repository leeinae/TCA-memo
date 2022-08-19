//
//  ViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/18.
//

import Combine
import UIKit

import ComposableArchitecture

class MemoListViewController: UITableViewController {
    // MARK: - Properties

    private let viewStore: ViewStore<MemoListState, MemoListAction>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))

    // MARK: - Initializer

    init(store: Store<MemoListState, MemoListAction>) {
        viewStore = .init(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperty()
        bind()
    }

    func setupProperty() {
        title = "Memo"
        view.backgroundColor = .white

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = addButtonItem
    }

    // MARK: - Actions

    @objc
    func didTapAddButton(_ sender: UIBarButtonItem) {
        print("add button")
        viewStore.send(.addAction)
    }

    func bind() {
        viewStore.publisher.isPresentEditor
            .sink { [weak self] isPresentEditor in
                guard let memo = isPresentEditor else { return }

                let memoEditorStore = Store(initialState: MemoEditorState(), reducer: memoEditorReducer, environment: MemoEditorEnvironment())
                let memoEditorViewController = MemoEdiorViewController(store: memoEditorStore)

                self?.present(memoEditorViewController, animated: true, completion: nil)
            }
            .store(in: &cancellables)
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
