//
//  PokemonCollectionViewCell.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/31.
//

import Combine
import UIKit

import ComposableArchitecture
import Kingfisher
import SnapKit

class PokemonCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var pokemon: Pokemon? {
        didSet {
            guard let pokemon = pokemon else { return }

            setupPokemon(pokemon)
        }
    }

    var viewStore: ViewStore<WikiState, WikiAction>?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Components

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .heavy)

        return label
    }()

    private let statLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)

        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)

        return label
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.systemGreen
        button.setImage(.init(systemName: "hand.thumbsup"), for: .normal)
        button.setImage(.init(systemName: "hand.thumbsup.fill"), for: .selected)
        button.addTarget(self, action: #selector(didTapLikeButton(_:)), for: .touchUpInside)

        return button
    }()

    private let image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        likeButton.isSelected = false
        image.image = nil
        nameLabel.text = nil
        statLabel.text = nil
    }

    private func setupUI() {
        backgroundColor = .systemGray5

        [nameLabel, statLabel, typeLabel, image, likeButton]
            .forEach { contentView.addSubview($0) }

        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }

        statLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(nameLabel.snp.leading)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(statLabel.snp.bottom).offset(12)
            make.leading.equalTo(nameLabel.snp.leading)
        }

        image.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(self.bounds.height)
            make.trailing.equalToSuperview().inset(12)
        }

        likeButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupPokemon(_ pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        statLabel.text = pokemon.stat
        typeLabel.text = pokemon.type
        likeButton.isSelected = pokemon.isLiked

        guard let url = URL(string: pokemon.image ?? "") else { return }

        image.kf.setImage(with: url)
    }

    @objc
    func didTapLikeButton(_ sender: UIButton) {
        guard let pokemon = pokemon else { return }

        viewStore?.send(.tapPokemonLikeButton(pokemon.id, !sender.isSelected))
    }
}
