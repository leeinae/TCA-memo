//
//  MemoEdiorViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Combine
import UIKit

import ComposableArchitecture
import SnapKit

class MemoEditorViewController: UIViewController {
    // MARK: - Properties

    let store: Store<MemoEditorState, MemoEditorAction>
    let viewStore: ViewStore<MemoEditorState, MemoEditorAction>

    var cancellabel: Set<AnyCancellable> = []

    // MARK: - UI Components

    lazy var cancelButtonItem: UIBarButtonItem = .init(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(didTapCancelButton(_:))
    )

    lazy var bookmarkButtonItem: UIBarButtonItem = .init(
        image: UIImage(systemName: "bookmark"),
        style: .plain,
        target: self,
        action: #selector(didTapBookmarkButton(_:))
    )

    lazy var saveButtonItem: UIBarButtonItem = .init(
        title: "Save",
        style: .done,
        target: self,
        action: #selector(didTapSaveButton(_:))
    )

    let textView: UITextView = .init()

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
        setupLayout()

        bind()
    }

    func setupProperty() {
        view.backgroundColor = .white

        navigationItem.leftBarButtonItems = [cancelButtonItem, bookmarkButtonItem]
        navigationItem.rightBarButtonItem = saveButtonItem

        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 2.0
        textView.font = .systemFont(ofSize: 18)
        textView.delegate = self
    }

    func setupLayout() {
        view.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }

    // MARK: - Bind

    func bind() {
        viewStore.publisher.memo
            .memo
            .assign(to: \.text, on: textView)
            .store(in: &cancellabel)

        viewStore.publisher.memo
            .memo
            .map { !$0.isEmpty }
            .assign(to: \.isEnabled, on: saveButtonItem)
            .store(in: &cancellabel)

        viewStore.publisher.memo
            .isBookmark
            .map { $0 ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark") }
            .assign(to: \.image, on: bookmarkButtonItem)
            .store(in: &cancellabel)
    }

    // MARK: - Actions

    @objc
    func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func didTapBookmarkButton(_ sender: UIBarButtonItem) {
        let isBookmark = !viewStore.memo.isBookmark

        viewStore.send(.setBookmark(isBookmark))
    }

    @objc
    func didTapSaveButton(_ sender: UIBarButtonItem) {
        let isBookmark = viewStore.memo.isBookmark
        let newMemo = MemoModel(memo: textView.text, isBookmark: isBookmark)

        viewStore.send(.saveMemo(newMemo))
        dismiss(animated: true, completion: nil)
    }
}

extension MemoEditorViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        saveButtonItem.isEnabled = !text.isEmpty || (range.length < textView.text.count)

        return true
    }
}
