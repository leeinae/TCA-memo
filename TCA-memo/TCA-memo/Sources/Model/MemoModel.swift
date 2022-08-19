//
//  MemoModel.swift
//  TCA-memo
//
//  Created by Devsisters on 2022/08/19.
//

import Foundation

struct MemoModel: Equatable {
    let id: String = UUID().uuidString
    var memo: String
    var isBookmark: Bool = false
}
