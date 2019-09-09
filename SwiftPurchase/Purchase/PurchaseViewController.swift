//
//  PurchaseViewController.swift
//  JumpingCat
//
//  Created by Masahiro Tamamura on 2019/07/08.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController, SKProductsRequestDelegate {

    var selctProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startPopup), userInfo: nil, repeats: false)
        let name = Notification.Name("kPurchasedProductNotification")
        NotificationCenter.default.addObserver(forName: name,
                           object: nil,
                           queue: nil) { notification in
                            print("Notification: \(notification)")
                            let alert: UIAlertController = UIAlertController(title: "Completed!", message: "Thank you for your purchase", preferredStyle:  UIAlertController.Style.alert)
                            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                                (action: UIAlertAction!) -> Void in
                                self.dismiss(animated: true, completion: nil)
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
        }

        let name2 = Notification.Name("kPurchasedErrorNotification")
        NotificationCenter.default.addObserver(forName: name2,
                                               object: nil,
                                               queue: nil) { notification in
                                                print("Notification: \(notification)")
                                                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func startPopup(){
        if SKPaymentQueue.canMakePayments() {
            
            guard let pro : Product = selctProduct else { return }
            let prodcutName : String = "Do you want to purchase " +  pro.title + "?"

            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let alert: UIAlertController = UIAlertController(title: "", message: prodcutName, preferredStyle:  UIAlertController.Style.alert)
            let purchaseAction: UIAlertAction = UIAlertAction(title: "Purchase", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("Purchase" + pro.productId)
                let request = SKProductsRequest(productIdentifiers:
                    NSSet(objects: pro.productId) as! Set<String>)
                request.delegate = self
                request.start()
            })
            let restoreAction: UIAlertAction = UIAlertAction(title: "Restore", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("Restore")
                app.startRestore()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
            alert.addAction(purchaseAction)
            alert.addAction(restoreAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            // Tell user that In-App Purchase is disabled in Settings
            let alert: UIAlertController = UIAlertController(title: "Error", message: "Purchase not available", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }

    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let products = response.products
        
        if (products.count != 0) {

            guard let pro : Product = selctProduct else { return }
            for product:SKProduct in response.products {
                if response.invalidProductIdentifiers.contains(product.productIdentifier as String) == false {
                    if  product.productIdentifier == pro.productId {
                        let payment = SKPayment(product: product)
                        SKPaymentQueue.default().add(payment)
                    }
                }
            }
/*
            for productId in response.invalidProductIdentifiers {
                if response.invalidProductIdentifiers.contains(product.productIdentifier as String) == false {
                    if  product.productIdentifier == "net.jp.garlands.test.quest2016_1" {
                        let payment = SKPayment(product: product)
                        SKPaymentQueue.default().add(payment)
                    }
                }
            }
*/
        }
        
        let invalidProds = response.invalidProductIdentifiers
        
        for product in invalidProds
        {
            print("Product not found: \(product)")
        }
    }
}
