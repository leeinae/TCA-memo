//
//  MemoEdiorViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Combine
import UIKit

import ComposableArchitecture

class MemoEdiorViewController: UIViewController {
    // MARK: - Properties

    let viewStore: ViewStore<MemoEditorState, MemoEditorAction>

    // MARK: - UI Components

    let cancelButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .cancel, target: nil, action: nil)
    let saveButtonItem: UIBarButtonItem = .init(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton(_:)))

    // MARK: - Initializer

    init(store: Store<MemoEditorState, MemoEditorAction>) {
        viewStore = .init(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
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

    @objc
    func didTapSaveButton(_ sender: UIBarButtonItem) {
        print("save button")
        dismiss(animated: true, completion: nil)
    }
}
