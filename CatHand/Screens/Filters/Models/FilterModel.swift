//
//  FilterModel.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 06.02.2024.
//

import Foundation
import CoreImage

struct FilterModel: Identifiable {
    let id: UUID = .init()
    let name: String = "QWE"
    let filter: CIFilter
}
