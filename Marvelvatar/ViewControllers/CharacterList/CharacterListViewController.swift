//
//  CharacterListViewController.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 9/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarField: UISearchBar!
    
    var selectedCell: CharacterTableViewCell? = nil
    
    
    let characterViewModel = CharacterViewModel()
    var bottomLoader = BottomActivityIndicatorView.loadView()
    
    //Custom object for animation on navigation
    let transition = PushAnimation()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController!.delegate = self
        navigationController?.view.hideKeyboard()
        view.hideKeyboard()
        
        if Utils.isInternetReachable() {
            getCharacters()
        } else {
            weak var weakSelf = self
            Utils.showAlert(title: "Connect to Internet", message: "Please Connect to internet and try again.", sender: weakSelf)
        }
        
        searchBarField.rx.text.orEmpty.bind(to: characterViewModel.searchBarText).disposed(by: disposeBag)
        
        configureCellForRow()
        configueCellTap()
        configureWillDisplayCell()
        setUpTableViewFooter()
    }
    
    //Loads character from ViewModel object
    private func getCharacters() {
        
        self.view.showLoaderView()
        characterViewModel.delegate = self
        characterViewModel.loadCharacters()
    }
    
    private func setUpTableViewFooter() {
        
        tableView.tableFooterView = bottomLoader
        tableView.tableFooterView?.isHidden = true
        tableView.keyboardDismissMode = .onDrag
    }
    
    //Footter view activity loader show
    private func showBottomLoader() {
        bottomLoader.activitiIndictor.startAnimating()
        tableView.tableFooterView?.isHidden = false
    }
    
    //Footter view activity loader hide
    func hideBottomLoader() {
        bottomLoader.activitiIndictor.stopAnimating()
        tableView.tableFooterView?.isHidden = true
    }
    func configureCellForRow() {
        characterViewModel.dataObservable.asObservable().bind(to: tableView
            .rx //2
            .items(cellIdentifier: CharacterTableViewCell.identifier,
                   cellType: CharacterTableViewCell.self)) {
                    row, result, cell in
                    let characterData = self.characterViewModel.getDataModel(index: row)
                    cell.characterModel = (characterData, row)
            }
            .disposed(by: disposeBag)
        
    }
    func configueCellTap() {
        tableView
            .rx
            .modelSelected(Results.self)
            .subscribe(onNext: { [weak self]
                selectedCharacter in
                
                if let indexPath = self?.tableView.indexPathForSelectedRow {
                    let cell = self?.tableView.cellForRow(at: indexPath) as! CharacterTableViewCell
                    self?.selectedCell = cell
                    self?.performSegue(withIdentifier: "detail", sender: selectedCharacter)
                }
            })
            .disposed(by: disposeBag)
    }
    func configureWillDisplayCell() {
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                let lastItem = self.characterViewModel.results.value.count - 1
                if indexPath.row == lastItem {
                    self.characterViewModel.loadMore()
                    self.showBottomLoader()
                } else {
                    self.hideBottomLoader()
                }
            }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let selectedCharacter = sender as? Results else {return}
            let destination = segue.destination as! CharacterDetailViewController
            destination.characterModel = selectedCharacter
        }
    }
}
extension CharacterListViewController: CharacterViewModelDelegate {
    
    //MARK:- CarouselViewModel Delegate
    func didFinishFetchWithSuccess() {
        hideBottomLoader()
        self.view.hideLoaderView()
    }
    
    func didFinishFetchingWithError(error: Error) {
        showBottomLoader()
        self.view.hideLoaderView()
    }
    
    func searching() {
        showBottomLoader()
    }
    
    func nothingMoreToShow() {
        hideBottomLoader()
    }
    
}
extension CharacterListViewController: UINavigationControllerDelegate {
    
    //MARK: Navigation Controller Delegate
    //For Custom Transition
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            transition.originFrame = selectedCell!.superview!.convert(selectedCell!.frame, to: nil)
            transition.isPresenting = true
            return transition
        default:
            transition.isPresenting = false
            return transition
        }
    }
    
    
    
}
