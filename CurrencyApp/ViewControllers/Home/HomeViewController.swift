//
//  HomeViewController.swift
//  CurrencyApp
//
//  Created by Ye linn htet on 12/9/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var viewExchangeCard: UIStackView!
    @IBOutlet weak var viewResult: UIStackView!
    @IBOutlet weak var viewFrom: UIStackView!
    @IBOutlet weak var lblFromCurrency: UILabel!
    @IBOutlet weak var viewTo: UIStackView!
    @IBOutlet weak var lblToCurrency: UILabel!
    @IBOutlet weak var txtFieldAmount: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var tableViewExchangeRate: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel(currencyModel: CurrencyModelImpl.shared)
        
        setupNavbar()
        
        setupView()
        
        setupGestureRecognizers()
        
        setupTableView()
        
        bindViewState()
        
        bindTxtField()
        
        viewModel.fetchExchangeRateWithTime()
    }


    private func setupNavbar() {
        self.navigationItem.title = "Currency App"
    }
    
    private func setupView() {
        viewExchangeCard.layer.cornerRadius = 16.0
        viewResult.layer.cornerRadius = 16.0
        viewResult.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setupGestureRecognizers() {
        let tapFromCurrency = UITapGestureRecognizer(target: self, action: #selector(onTapFromCurrency))
        viewFrom.isUserInteractionEnabled = true
        viewFrom.addGestureRecognizer(tapFromCurrency)
        
        let tapToCurrency = UITapGestureRecognizer(target: self, action: #selector(onTapToCurrency))
        viewTo.isUserInteractionEnabled = true
        viewTo.addGestureRecognizer(tapToCurrency)
    }
    
    private func setupTableView() {
        tableViewExchangeRate.dataSource = self
        tableViewExchangeRate.registerForCell(identifier: ExchangeRateTableViewCell.identifier)
        tableViewExchangeRate.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    
    
    private func bindTxtField() {
        txtFieldAmount.rx.text
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                
                guard let self = self else { return }
                
                guard let amount = value else { return }
                guard let from = self.lblFromCurrency.text else { return }
                guard let to = self.lblToCurrency.text else { return }
                
                self.viewModel.validateInputAndConvertCurrency(from: from, to: to, amount: amount)
                
            }).disposed(by: disposeBag)
    }
    
    private func bindViewState() {
        viewModel.viewState.subscribe(onNext: {[weak self] state in
            
            guard let self = self else { return }
            
            switch state {
            case .successCurrencyConvert:
                self.bindView()
                
            case .successFetchingLiveExchangeRate:
                self.tableViewExchangeRate.reloadData()
                
            case .invalidInput(let message):
                self.bindInvalidState(message: message)
                
            case .failure(let message):
                debugPrint(message)
                
            default:
                debugPrint("Default state")
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func bindView() {
        lblResult.text = "\(viewModel.getConvertResult()) \(lblToCurrency.text!)"
    }
    
    private func bindInvalidState(message: String) {
        lblResult.text = "0 \(lblToCurrency.text!)"
    }
    
    
    //MARK: - OnTap Callbacks
    @objc private func onTapFromCurrency() {
        let currency = lblFromCurrency.text!
        navigateToChooseCurrency(isFrom: true, selectedCurrency: currency)
    }
    
    @objc private func onTapToCurrency() {
        let currency = lblToCurrency.text!
        navigateToChooseCurrency(isFrom: false, selectedCurrency: currency)
    }

    
    func navigateToChooseCurrency(isFrom: Bool, selectedCurrency: String) {
        let vc = ChooseCurrencyViewController()
        vc.viewModel = ChooseCurrencyViewModel(currencyModel: CurrencyModelImpl.shared, selectedCurrency: selectedCurrency, isFromCurrency: isFrom)
        vc.delegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
}


//MARK: - TableView Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getLiveExchangeRateListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(identifier: ExchangeRateTableViewCell.identifier, indexPath: indexPath) as ExchangeRateTableViewCell
        cell.data = viewModel.getLiveExchangeRate(by: indexPath.row)
        return cell
    }
}


//MARK: - Choose Currency Delegate
extension HomeViewController: ChooseCurrencyDelegate {
    
    func didChooseFromCurrency(currency: String) {
        lblFromCurrency.text = currency
        viewModel.validateInputAndConvertCurrency(from: currency, to: lblToCurrency.text!, amount: txtFieldAmount.text!)
    }
    
    func didChooseToCurrency(currency: String) {
        lblToCurrency.text = currency
        viewModel.validateInputAndConvertCurrency(from: lblFromCurrency.text!, to: currency, amount: txtFieldAmount.text!)
    }
}
