//
//  ItemCollectionViewCell.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/31.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
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
        layer.cornerRadius = self.frame.width / 2.0
    }
}
