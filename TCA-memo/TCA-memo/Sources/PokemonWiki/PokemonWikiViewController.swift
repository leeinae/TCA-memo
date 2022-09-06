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

    enum WikiSection: String, CaseIterable {
        case pokemon
        case items
        case types
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
        bind()
    }

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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch WikiSection.allCases[indexPath.section] {
        case .pokemon:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PokemonCollectionViewCell.self),
                for: indexPath
            ) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
            cell.pokemon = viewStore.pokemons[indexPath.row]

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
                self?.collectionView.reloadSections(.init(integer: 0))
            }
            .store(in: &cancellables)

        viewStore.publisher.items
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(.init(integer: 1))
            }
            .store(in: &cancellables)

        viewStore.publisher.types
            .sink { [weak self] _ in
                self?.collectionView.reloadSections(.init(integer: 2))
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
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)

        return section
    }

    func generateTypeLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
