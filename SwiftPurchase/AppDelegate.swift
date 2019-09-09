//
//  AppDelegate.swift
//  SwiftPurchase
//
//  Created by Masahiro Tamamura on 2019/09/09.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]){
        for transaction in transactions {
            //            guard let productType = ProductType(rawValue: transaction.payment.productIdentifier) else {fatalError()}
            //            switch transaction.transactionState {
            //            case .purchasing:
            //                self.delegate?.inAppLoadingStarted()
            if transaction.transactionState == .purchased {
                //            case .purchased:
                //                SKPaymentQueue.default().finishTransaction(transaction)
                //                self.updateSubscriptionStatus()
                //                self.isSubscriptionAvailable = true
                //                self.delegate?.inAppLoadingSucceded(productType: productType)
                if transaction.downloads.count > 0 {
                    SKPaymentQueue.default().start(
                        transaction.downloads)
                } else {
                    // Unlock feature or content here before
                    // finishing transaction
                    SKPaymentQueue.default().finishTransaction(
                        transaction)
                    addProduct(transaction: transaction)
                    let name = Notification.Name("kPurchasedProductNotification")
                    NotificationCenter.default.post(name: name, object: nil)
                    //                    NotificationCenter.default.post(name: "kPurchasedProductNotification", object: nil)
                }
            }
            if transaction.transactionState == .failed {
                if let transactionError = transaction.error as NSError?,
                    transactionError.code != SKError.paymentCancelled.rawValue {
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                let name = Notification.Name("kPurchasedErrorNotification")
                NotificationCenter.default.post(name: name, object: nil)
            }
            if transaction.transactionState == .restored {
                if transaction.downloads.count > 0 {
                    SKPaymentQueue.default().start(
                        transaction.downloads)
                } else {
                    // Unlock feature or content here before
                    // finishing transaction
                    SKPaymentQueue.default().finishTransaction(
                        transaction)
                    let name = Notification.Name("kPurchasedProductNotification")
                    NotificationCenter.default.post(name: name, object: nil)
                }
            }
            //                SKPaymentQueue.default().finishTransaction(transaction)
            //                self.updateSubscriptionStatus()
            //                self.isSubscriptionAvailable = true
            //                self.delegate?.inAppLoadingSucceded(productType: productType)
            //            case .deferred:
            //                self.delegate?.inAppLoadingSucceded(productType: productType)
        }
    }
    
    func startRestore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func addProduct(transaction:SKPaymentTransaction){
        let productid:String = transaction.payment.productIdentifier
        UserDefaults.standard.set(true, forKey: productid)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue){
        print("Restore  paymentQueueRestoreCompletedTransactionsFinished")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]){
        for download in downloads
        {
            switch download.state {
            case SKDownloadState.active:
                print("Download progress \(download.progress)")
                print("Download time = \(download.timeRemaining)")
                break
            case SKDownloadState.finished:
                // Download is complete. Content file URL is at
                // path referenced by download.contentURL. Move
                // it somewhere safe, unpack it and give the user
                // access to it
                break
            default:
                break
            }
        }
        
        func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment
            payment: SKPayment, for product: SKProduct) -> Bool {
            return true
        }
    }


}

