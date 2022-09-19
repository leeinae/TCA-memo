//
//  MyPageViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Combine
import UIKit

import ComposableArchitecture

class MyPageViewController: UIViewController {
    // MARK: - Properties

    private let store: Store<BaseState<MyPageState>, MyPageAction>
    private let viewStore: ViewStore<BaseState<MyPageState>, MyPageAction>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    let membershipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)

        return label
    }()

    // MARK: - Initializer

    init(store: Store<BaseState<MyPageState>, MyPageAction>) {
        self.store = store
        viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperty()
        setupUI()
        bind()
    }

    // MARK: - Setup Methods

    private func setupProperty() {
        view.backgroundColor = .white
    }

    private func setupUI() {
        view.addSubview(membershipLabel)

        membershipLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bind() {
        viewStore.publisher.shared.membership
            .map { $0.rawValue }
            .assign(to: \.text, on: membershipLabel)
            .store(in: &cancellables)
    }
}
