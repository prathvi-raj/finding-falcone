//
//  HomeViewController.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit
import RxSwift

/// HomeViewController
class HomeViewController: BaseViewController {

    @IBOutlet weak var planetsTableView: UITableView!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    /// HomeViewModel
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.resetTaps.onNext(())
    }
    
    deinit {
        plog(HomeViewController.self)
    }
}

/// Setup RX Bindings with ViewModel
extension HomeViewController {
    
    private func setup() -> Void {
        plog(viewModel)
        setupUI(with: viewModel)
        setupBindings(forViewModel: viewModel)
    }
    
    private func setupUI(with viewModel: HomeViewModel) -> Void {
        planetsTableView.tableFooterView = UIView()
    }
    
    private func setupBindings(forViewModel viewModel: HomeViewModel) -> Void {
        
        planetsTableView.rx
            .itemSelected.bind(to: viewModel.selectedIndexPath)
            .disposed(by: disposeBag)
        
        resetButton.rx
            .tap.bind(to: viewModel.resetTaps)
            .disposed(by: disposeBag)
        
        nextButton.rx
            .tap.bind(to: viewModel.nextTaps)
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled.subscribe(onNext: { [weak self] (isNextButtonEnabled) in
            guard let `self` = self else { return }
            self.nextButton.isEnabled = isNextButtonEnabled
        }).disposed(by: disposeBag)
        
        viewModel.refreshTableView.subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.planetsTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.alert.subscribe(onNext: { [weak self] (message, theme) in
            guard let `self` = self else { return }
            self.alert(message, theme: theme)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.distinctUntilChanged().drive(onNext: { [weak self] (isLoading) in
            guard let `self` = self else { return }
            self.hideActivityIndicator()
            if isLoading {
                self.showActivityIndicator()
            }
        }).disposed(by: disposeBag)
    }
}

/// UITableView Delegates and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.destinationTableViewCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DestinationTableViewCell.self), for: indexPath) as! DestinationTableViewCell
        cell.configure(data: viewModel.destinationTableViewCellData[indexPath.row])
        return cell
    }
}
