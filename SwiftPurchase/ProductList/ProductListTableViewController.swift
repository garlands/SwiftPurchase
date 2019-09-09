//
//  ProductListTableViewController.swift
//  JumpingCat
//
//  Created by Masahiro Tamamura on 2019/07/18.
//  Copyright © 2019 Masahiro Tamamura. All rights reserved.
//

import UIKit

class ProductListTableViewController: UITableViewController {

    var products : Array<Product>  = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
        let product : Product = Product.init(title: "Product 1", productId: "(your bundle id).testproduct1", productImageName: "testproduct1.png", localizedPrice: "¥120")
        products.append(product)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product : Product = products[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let imageView:UIImageView = cell.viewWithTag(1) as! UIImageView
        if let image:UIImage = UIImage.init(named: product.productImageName){
            imageView.image = image
        }
        
        let title:UILabel = cell.viewWithTag(2) as! UILabel
        title.text = product.title
        let price:UILabel = cell.viewWithTag(3) as! UILabel
        price.text = product.localizedPrice

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if let target = segue.destination as? PurchaseViewController {
            target.selctProduct = products[indexPath.row]
        }
    }
}
