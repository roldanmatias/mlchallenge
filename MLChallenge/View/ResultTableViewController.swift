//
//  ResultTableViewController.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import SDWebImage
import UIKit

class ResultTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var list: SearchResult?
    var viewModel: ViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = list?.query ?? ""
        
        hideSpinner()
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

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = list?.results?[indexPath.row] else { 
            fatalError("Unexpected empty list item")
        }
        
        performSegue(withIdentifier: Constant.detailSegue, sender: item)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentPage = list?.paging.offset ?? 0
        let totalPages = list?.paging.total ?? 0
        
        if indexPath.row == (list?.results?.count ?? 0) - 1, currentPage < totalPages {
            loadMoreData()
        }
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
    
    func loadMoreData() {
        guard 
            let currentPage = list?.paging.offset, 
            let query = list?.query 
        else { 
            return
        }
        
        showSpinner()
        
        let filter = SearchFilter(offset: currentPage + 1, text: query)
        
        viewModel?.seearch(
            filter: filter, 
            onSuccess: { [weak self] searchResult in
                self?.handleSearchResult(searchResult)
            }, onError: { [weak self] error in
                self?.handleSearchError(error)
            }
        )
    }
    
    func handleSearchResult(_ searchResult: SearchResult? = nil) {
        guard 
            let searchResult = searchResult, 
            let results = searchResult.results 
        else { 
            return
        }
        
        list?.results?.append(contentsOf: results)
        list?.paging = searchResult.paging
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.hideSpinner()
        }
    }
    
    func handleSearchError(_ error: Error?) {
        DispatchQueue.main.async {
            self.hideSpinner()
            
            let alert = UIAlertController(
                title: "ML Challenge", 
                message: "Oops! Something went wrong! Help us improve your experience by sending an error report: \(error?.localizedDescription ?? "")", 
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alert, animated: true)    
        }
    }
    
    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
