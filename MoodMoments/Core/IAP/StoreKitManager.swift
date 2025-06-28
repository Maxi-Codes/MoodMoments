//  StoreKitManager.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation
import StoreKit

@MainActor
final class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchased = false

    private let productIDs: Set<String> = ["com.moodmoments.pro"]

    func fetchProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("StoreKit fetch error: \(error)")
        }
    }

    func buy(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(_):
                    purchased = true
                default: break
                }
            default: break
            }
        } catch {
            print("Purchase error: \(error)")
        }
    }
}
