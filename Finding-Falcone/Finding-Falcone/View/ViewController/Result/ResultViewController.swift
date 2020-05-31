//
//  ResultViewController.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit
import RxSwift

/// ResultViewController
class ResultViewController: BaseViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var planeNameLabel: UILabel!
    
    /// ResultViewModel
    var viewModel: ResultViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

/// Setup RX Bindings with ViewModel
extension ResultViewController {
    
    private func setup() -> Void {
        setupUI(with: viewModel)
        setupBindings(forViewModel: viewModel)
    }
    
    private func setupUI(with viewModel: ResultViewModel) -> Void {
        
    }
    
    private func setupBindings(forViewModel viewModel: ResultViewModel) -> Void {
        
        doneButton.rx
            .tap.bind(to: viewModel.closeTaps)
            .disposed(by: disposeBag)
        
        viewModel.alert.subscribe(onNext: { [weak self] (message, theme) in
            guard let `self` = self else { return }
            self.alert(message, theme: theme)
        }).disposed(by: disposeBag)
        
        viewModel.resultResponse
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                if result.isSuccess {
                    self.messageLabel.text = pString(.successResult)
                    self.planeNameLabel.text = result.planetName
                } else {
                    self.messageLabel.text = pString(.failureResult)
                }
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
