//
//  ItemCollectionViewCell.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/31.
//

import UIKit

import Kingfisher
import SnapKit

class ItemCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var item: Item? {
        didSet {
            guard let item = item else { return }

            setupItem(item)
        }
    }

    // MARK: - UI Components

    private let image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .systemOrange
        layer.cornerRadius = frame.width / 2.0
        
        contentView.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupItem(_ item: Item) {
        guard let url = URL(string: item.image ?? "") else { return }

        image.kf.setImage(with: url)
    }
}
