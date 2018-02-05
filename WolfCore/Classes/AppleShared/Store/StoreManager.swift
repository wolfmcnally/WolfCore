//
//  StoreManager.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/30/17.
//  Copyright © 2017 WolfMcNally.com. All rights reserved.
//

import StoreKit

public var storeManager = StoreManager()

public class StoreManager: NSObject {
    fileprivate override init() { }

    public typealias ProductsBlock = (SKProductsResponse) -> Void
    private var productsRequest: SKProductsRequest!
    fileprivate var productsResponse: SKProductsResponse!
    fileprivate var productsCompletionBlock: ProductsBlock!

    public func retriveProducts(for identifiers: Set<String>, completion: @escaping ProductsBlock) {
        assert(productsCompletionBlock == nil)

        productsCompletionBlock = completion

        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension StoreManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsResponse = response

        //print(response.json.prettyString)

        productsCompletionBlock(response)
        productsCompletionBlock = nil
    }
}

#if os(macOS)
    extension SKProduct {
        public var isDownloadable: Bool {
            return downloadable
        }

        public var downloadContentLengths: [NSNumber] {
            return contentLengths
        }

        public var downloadContentVersion: String {
            return contentVersion
        }
    }
#endif

extension SKProduct: JSONRepresentable {
    public var json: JSON {
        return JSON([
            "localizedDescription": localizedDescription,
            "localizedTitle": localizedTitle,
            "price": price,
            "priceLocale": priceLocale,
            "productIdentifier": productIdentifier,

            "isDownloadable": isDownloadable,
            "downloadContentLengths": downloadContentLengths,
            "downloadContentVersion": downloadContentVersion
            ])
    }
}

extension SKProductsResponse {
    public var json: JSON {
        return JSON([
            "products": products,
            "invalidProductIdentifiers": invalidProductIdentifiers
            ])
    }
}
