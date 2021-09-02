//
//  ModelLocator.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import Foundation

// modelを共有するための構造体
struct ModelLocator {
    static let shared = ModelLocator()
    let model = ItemsList()
    private init() {}
}
