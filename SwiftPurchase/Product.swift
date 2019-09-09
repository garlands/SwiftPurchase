//
//  Product.swift
//  SwiftPurchase
//
//  Created by Masahiro Tamamura on 2019/09/09.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import Foundation


class Product  {
    var title: String
    var productId: String
    var productImageName: String
    var localizedPrice: String
    
    init(title: String, productId: String, productImageName: String, localizedPrice: String) {
        self.title = title
        self.productId = productId
        self.productImageName = productImageName
        self.localizedPrice = localizedPrice
    }
}
