//
//  TypeCollectionViewCell.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/31.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var type: TypeModel? {
        didSet {
            guard let type = type else { return }

            setupType(type)
        }
    }

    // MARK: - UI Components

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .heavy)

        return label
    }()

    private let pokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .light)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6

        [nameLabel, pokemonLabel].forEach { contentView.addSubview($0) }

        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
        }

        pokemonLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }

    private func setupType(_ type: TypeModel) {
        nameLabel.text = type.name
        pokemonLabel.text = type.pokomons.joined(separator: ", ")
    }
}
