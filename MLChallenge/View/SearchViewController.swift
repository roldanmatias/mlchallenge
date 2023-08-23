//
//  ViewController.swift
//  MLChallenge
//
//  Created by Matias Roldan on 07/08/2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var viewModel = ViewModelFactory.createViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideSpinner()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard 
            segue.identifier == Constant.listSegue, 
            let listViewController = segue.destination as? ResultTableViewController,
            let list = sender as? SearchResult
        else { 
            return
        }
        
        listViewController.list = list
        listViewController.viewModel = viewModel
    }

    @IBAction func search(_ sender: Any) {
        guard 
            let text = searchTextField.text, 
            text.count > 2 
        else { 
            return
        }
        
        showSpinner()
        
        let filter = SearchFilter(offset: 0, text: text)
        
        viewModel.seearch(
            filter: filter) { [weak self] searchResult in
                self?.handleSearchResult(searchResult)
            } onError: { [weak self] error in
                self?.handleSearchError(error)
            }
    }
}

private extension SearchViewController {
    
    enum Constant {
        static let listSegue = "listSegue"
    }
    
    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func handleSearchResult(_ searchResult: SearchResult? = nil) {
        guard let searchResult = searchResult else { return }
        
        DispatchQueue.main.async {
            self.hideSpinner()
            self.performSegue(withIdentifier: Constant.listSegue, sender: searchResult)
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
}
