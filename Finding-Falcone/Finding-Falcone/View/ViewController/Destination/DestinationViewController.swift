//
//  DestinationViewController.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import UIKit
import RxSwift

/// DestinationViewController
class DestinationViewController: BaseViewController {

    @IBOutlet weak var planetPickerView: UIPickerView!
    @IBOutlet weak var vehiclePickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timeTakenLabel: UILabel!
    
    /// DestinationViewModel
    var viewModel: DestinationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

/// Setup RX Bindings with ViewModel
extension DestinationViewController {
    
    private func setup() -> Void {
        setupUI(with: viewModel)
        setupBindings(forViewModel: viewModel)
    }
    
    private func setupUI(with viewModel: DestinationViewModel) -> Void {
        planetPickerView.selectRow(0, inComponent: 0, animated: true)
        vehiclePickerView.selectRow(0, inComponent: 0, animated: true)
        viewModel.selectPlanet(index: 0)
        viewModel.selectVehicle(index: 0)
    }
    
    private func setupBindings(forViewModel viewModel: DestinationViewModel) -> Void {
        
        cancelButton.rx
            .tap.bind(to: viewModel.cancelTaps)
            .disposed(by: disposeBag)
        
        doneButton.rx
            .tap.bind(to: viewModel.doneTaps)
            .disposed(by: disposeBag)
        
        viewModel.timeTakenText
            .subscribe(onNext: { [weak self] (text) in
            guard let `self` = self else { return }
            self.timeTakenLabel.text = text
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

/// UIPickerView Delegates and DataSource
extension DestinationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == planetPickerView {
            return viewModel.availablePlanets.count
        } else {
            return viewModel.availableVehicles.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == planetPickerView {
            return viewModel.availablePlanets[row].name
        } else {
            return viewModel.availableVehicles[row].displayName
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == planetPickerView {
            viewModel.selectPlanet(index: row)
        } else {
            viewModel.selectVehicle(index: row)
        }
    }
}
