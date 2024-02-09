//
//  ImageAsset.swift
//  Instafilter
//
//  Created by Филатов Олег Олегович on 28.11.2023.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImageAsset: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var asset: PHAsset? = nil
    var thumbnail: UIImage? = nil
    var title: String = ""
    // MARK: Selected image index
    var assetIndex: Int = -1
    
    static var examples: [ImageAsset] = [ImageAsset(thumbnail: UIImage(named: "BlackPro")), ImageAsset(thumbnail: UIImage(named: "catAnn")), ImageAsset(thumbnail: UIImage(named: "BlackPro")), ImageAsset(thumbnail: UIImage(named: "catAnn"))]
}
extension ImageAsset: Codable {
    // Initializer 2: For decoding the encoded data
    init(from decoder: Decoder) throws {
    }

    func encode(to encoder: Encoder) throws {
    }
}
extension ImageAsset: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .imageAsset)
    }
}

extension UTType {
    static let imageAsset = UTType(exportedAs: "O.Fil.Instafilter.imageAsset")
}
