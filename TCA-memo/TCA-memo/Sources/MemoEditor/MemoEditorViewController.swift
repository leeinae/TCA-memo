//
//  MemoEdiorViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Combine
import UIKit

import ComposableArchitecture

class MemoEditorViewController: UIViewController {
    // MARK: - Properties

    let store: Store<MemoEditorState, MemoEditorAction>
    let viewStore: ViewStore<MemoEditorState, MemoEditorAction>

    // MARK: - UI Components

    lazy var cancelButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .cancel, target: nil, action: nil)
    lazy var saveButtonItem: UIBarButtonItem = .init(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton(_:)))

    // MARK: - Initializer

    init(store: Store<MemoEditorState, MemoEditorAction>) {
        self.store = store
        viewStore = .init(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperty()
    }

    func setupProperty() {
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
    }

    // MARK: - Actions

    @objc
    func didTapSaveButton(_: UIBarButtonItem) {
        print("save button")
        dismiss(animated: true, completion: nil)
    }
}
