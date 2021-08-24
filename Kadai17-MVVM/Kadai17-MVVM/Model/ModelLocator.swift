//
//  ModelLocator.swift
//  Kadai17-MVVM
//
//  Created by 今村京平 on 2021/08/24.
//

import Foundation

struct ModelLocator {
    static let share = ModelLocator()
    let model = ItemsList()
    private init() {}
}
