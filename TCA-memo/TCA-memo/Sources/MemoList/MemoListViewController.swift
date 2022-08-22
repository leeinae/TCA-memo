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

    private let store: Store<MemoListState, MemoListAction>
    private let viewStore: ViewStore<MemoListState, MemoListAction>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton(_:)))

    // MARK: - Initializer

    init(store: Store<MemoListState, MemoListAction>) {
        self.store = store
        viewStore = .init(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
    func didTapAddButton(_: UIBarButtonItem) {
        print("add button")
        viewStore.send(.addAction)
    }

    func bind() {
        store.scope(
            state: \.memoEditor,
            action: MemoListAction.presentMemoEditor
        ).ifLet { [weak self] store in
            let memoEditorViewController = UINavigationController(
                rootViewController: MemoEditorViewController(store: store)
            )

            self?.present(memoEditorViewController, animated: true)
        }
        .store(in: &cancellables)

        viewStore.publisher.memos
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension MemoListViewController {
    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let memo = viewStore.memos[indexPath.row]

        cell.accessoryType = memo.isBookmark ? .checkmark : .none
        cell.textLabel?.text = memo.memo

        return cell
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewStore.memos.count
    }
}
