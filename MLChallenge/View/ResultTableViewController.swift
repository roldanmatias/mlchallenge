//
//  ResultTableViewController.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import SDWebImage
import UIKit

class ResultTableViewController: UITableViewController {

    var list: SearchResult?
    var searchText: String?
    var viewModel: ViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = searchText
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath) as? ResultTableViewCell,
            let item = list?.results?[indexPath.row]
        else { 
            fatalError("Result table is not configured correctly")
        }

        cell.title.text = item.title
        cell.price.text = "\(viewModel?.getCurrency(id: item.currencyId)?.symbol ?? "") \(item.price)"
        
        if let url = URL(string: item.thumbnail) {
            cell.thumbnail.sd_setImage(
                with: url, 
                placeholderImage: UIImage(named: "no-image-product")
            )
        } else {
            cell.thumbnail.image = UIImage(named: "no-image-product")
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = list?.results?[indexPath.row] else { 
            fatalError("Unexpected empty list item")
        }
        
        performSegue(withIdentifier: Constant.detailSegue, sender: item)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard 
            segue.identifier == Constant.detailSegue, 
            let detailViewController = segue.destination as? DetailViewController,
            let item = sender as? Item
        else { 
            return
        }
        
        detailViewController.item = item
        detailViewController.viewModel = viewModel
    }
}

private extension ResultTableViewController {
    
    enum Constant {
        static let cellIdentifier = "cell"
        static let detailSegue = "detailSegue"
    }
}
