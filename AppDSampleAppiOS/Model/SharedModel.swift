//
//  SharedModel.swift
//  AppDSampleAppiOS

import Foundation
import SwiftUI


enum CellID: String {
    case headingCell = "HeadingCell"
    case categoryCell = "CategoryCell"
    case useCaseCell = "UseCaseCell"
    case networkCallCell = "NetworkCallCell"
}


struct Category: Identifiable {
    var id = UUID()
    var name: String
    var title: String
    var caption: String
    var toolbarImage: Image?
    var hasProgress: Bool
    var useCases: [UseCase]
}
