//
//  DetailViewController.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import SDWebImage
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var availableQuantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var sellerStatusLabel: UILabel!
    @IBOutlet weak var soldQuantityLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var item: Item?
    var viewModel: ViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item else { return }
        
        availableQuantityLabel.text = "Available quantity: \(item.availableQuantity)"
        priceLabel.text = "\(viewModel?.getCurrency(id: item.currencyId)?.symbol ?? "") \(item.price)"
        productTitleLabel.text = item.title
        
        if let sellerStatus = item.seller.powerSellerStatus {
            sellerStatusLabel.text = "Seller status: \(sellerStatus)"    
        } else {
            sellerStatusLabel.isHidden = true
        }
        
        if let url = URL(string: item.thumbnail) {
            thumbnailImageView.sd_setImage(
                with: url, 
                placeholderImage: UIImage(named: "no-image-product")
            )
        } else {
            thumbnailImageView.image = UIImage(named: "no-image-product")
        }
    }
}
