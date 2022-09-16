//
//  BookMarkMemoTableViewController.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Combine
import UIKit

import ComposableArchitecture

class PokemonWikiViewController: UIViewController {
    // MARK: - SubTypes

    enum WikiSection: Int, CaseIterable {
        case pokemon
        case items
        case types

        var header: String {
            switch self {
            case .pokemon: return "Pokemon"
            case .items: return "Items"
            case .types: return "Types"
            }
        }
    }

    // MARK: - Properties

    private let store: Store<WikiState, WikiAction>
    private let viewStore: ViewStore<WikiState, WikiAction>
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: generateCollectionViewLayout()
        )

        collectionView.backgroundColor = .clear
        collectionView.register(PokemonCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                String(describing: PokemonCollectionViewCell.self))
        collectionView.register(ItemCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                String(describing: ItemCollectionViewCell.self))
        collectionView.register(TypeCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                String(describing: TypeCollectionViewCell.self))

        collectionView.dataSource = self

        return collectionView
    }()

    private lazy var membershipSwitchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.addTarget(
            self,
            action: #selector(toggleValueChanged(_:)),
            for: .valueChanged
        )

        return switchButton
    }()

    // MARK: - Initializer

    init(store: Store<WikiState, WikiAction>) {
        self.store = store
        viewStore = ViewStore(store)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewStore.send(.viewDidLoad)

        setupProperty()
        setupUI()
        setupBarButtonItem()

        bind()
    }

    // MARK: - Setup Methods

    private func setupProperty() {
        view.backgroundColor = .white
        title = "Pokemon Wiki"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func generateCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            switch WikiSection.allCases[section] {
            case .pokemon: return self.generatePokemonLayout()
            case .items: return self.generateItemLayout()
            case .types: return self.generateTypeLayout()
            }
        }

        return layout
    }

    private func setupBarButtonItem() {
        let memberLabel = UILabel()
        memberLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        memberLabel.text = "Member"

        let premiumLabel = UILabel()
        premiumLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        premiumLabel.text = "Premium"

        let stackView = UIStackView(
            arrangedSubviews: [memberLabel, membershipSwitchButton, premiumLabel]
        )
        stackView.spacing = 8

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }

    // MARK: - Objc Methods

    @objc
    private func toggleValueChanged(_ sender: UISwitch) {
        let membership: Membership = sender.isOn ? .premium : .member

        viewStore.send(.user(.changeUserStatus(membership)))
    }
}

// MARK: - UICollectionViewDataSource

extension PokemonWikiViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        WikiSection.allCases.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch WikiSection.allCases[section] {
        case .pokemon: return viewStore.pokemons.count
        case .items: return viewStore.items.count
        case .types: return viewStore.types.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch WikiSection.allCases[indexPath.section] {
        case .pokemon:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PokemonCollectionViewCell.self),
                for: indexPath
            ) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
            cell.pokemon = viewStore.pokemons[indexPath.row]
            cell.viewStore = viewStore

            return cell
        case .items:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ItemCollectionViewCell.self),
                for: indexPath
            ) as? ItemCollectionViewCell else { return UICollectionViewCell() }
            cell.item = viewStore.items[indexPath.row]

            return cell
        case .types:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TypeCollectionViewCell.self),
                for: indexPath
            ) as? TypeCollectionViewCell else { return UICollectionViewCell() }
            cell.type = viewStore.types[indexPath.row]

            return cell
        }
    }

    func bind() {
        viewStore.publisher.pokemons
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(
                    .init(integer: WikiSection.pokemon.rawValue)
                )
            }
            .store(in: &cancellables)

        viewStore.publisher.items
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(
                    .init(integer: WikiSection.items.rawValue)
                )
            }
            .store(in: &cancellables)

        viewStore.publisher.types
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(
                    .init(integer: WikiSection.types.rawValue)
                )
            }
            .store(in: &cancellables)

        viewStore.publisher.userState
            .userStatus
            .map { $0 == .premium }
            .assign(to: \.isOn, on: membershipSwitchButton)
            .store(in: &cancellables)

        viewStore.publisher.refresh
            .filter { $0 }
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(
                    .init(integer: WikiSection.pokemon.rawValue)
                )

                self?.viewStore.send(.refresh(false))
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView - SectionLayout

extension PokemonWikiViewController {
    func generatePokemonLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 5.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func generateItemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.0),
            heightDimension: .fractionalWidth(1.0 / 3.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 10.0, leading: 20.0, bottom: 10.0, trailing: 20.0)
        section.interGroupSpacing = 15.0

        return section
    }

    func generateTypeLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10.0

        return section
    }
}
