//
//  ChooseCurrencyViewController.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import UIKit
import RxSwift
import RxCocoa

class ChooseCurrencyViewController: UIViewController {

    @IBOutlet weak var tableViewCurrency: UITableView!
    
    weak var delegate: ChooseCurrencyDelegate?
    var viewModel: ChooseCurrencyViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavbar()
        
        setupTableView()
        
        viewModel.fetchCurrencyList()
        
        bindViewState()
    }
    
    private func setupNavbar() {
        self.navigationItem.title = "Choose Currency"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "colorPrimary")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onTapCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onTapDone))
    }
    
    private func setupTableView() {
        tableViewCurrency.dataSource = self
        tableViewCurrency.delegate = self
        tableViewCurrency.registerForCell(identifier: ChooseCurrencyTableViewCell.identifier)
        tableViewCurrency.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func bindViewState() {
        viewModel.viewState.subscribe(onNext: { [weak self] state in
            
            guard let self = self else { return }
            
            switch state {
                
            case .successFetchingCurrencyList:
                self.tableViewCurrency.reloadData()
                
            case .failure(let message):
                debugPrint(message)
                
            default:
                debugPrint("Default state")
            }
            
        }).disposed(by: disposeBag)
    }
    
    @objc private func onTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func onTapDone() {
        if viewModel.isCurrencyStateFrom() {
            delegate?.didChooseFromCurrency(currency: viewModel.getSelectedCurrency())
        } else {
            delegate?.didChooseToCurrency(currency: viewModel.getSelectedCurrency())
        }
        self.dismiss(animated: true)
    }
    

}

extension ChooseCurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCurrencyCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(identifier: ChooseCurrencyTableViewCell.identifier, indexPath: indexPath) as ChooseCurrencyTableViewCell
        cell.data = viewModel.getCurrency(by: indexPath.row)
        if viewModel.isSelectedCurrency(by: indexPath.row) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    
}

extension ChooseCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedCurrency(by: indexPath.row)
    }
}
