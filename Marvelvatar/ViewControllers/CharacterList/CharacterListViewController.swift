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
    
    @IBAction func didPressFavoriteAction(_ sender: UIButton) {
        let index = sender.tag
        sender.isSelected = !sender.isSelected
        
        characterViewModel.favoritePressed(index: index, isSelected: sender.isSelected)
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
    func bindSearchBar() {
        searchBarField.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<CharacterModel> in
                if query.isEmpty {
                    return
                }
                 characterViewModel.searchName(text: query)
                
            }
            .observeOn(MainScheduler.instance)
            .asObservable().subscribe( onError: { (error) in
                
            }, onCompleted: {
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        ImageCache.clearCache()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let index = sender as? Int else {return}
            let destination = segue.destination as! CharacterDetailViewController
            guard let selectedCharacter = characterViewModel.getDataModel(index: index) else {return}
            destination.characterModel = selectedCharacter
        }
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as! CharacterTableViewCell
        
        let characterData = characterViewModel.getDataModel(index: indexPath.row)
        cell.characterModel = (characterData, indexPath.row)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(didPressFavoriteAction), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterViewModel.dataCount()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let results = characterViewModel.results else { return }
        let lastItem = results.count - 1
        if indexPath.row == lastItem{
            characterViewModel.loadMore()
            showBottomLoader()
        }else{
            hideBottomLoader()
        }
    }
    
    //MARK:- TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell
        
        performSegue(withIdentifier: "detail", sender: indexPath.row)
    }
    
    
}
extension CharacterListViewController: CharacterViewModelDelegate {
    
    //MARK:- CarouselViewModel Delegate
    func didFinishFetchWithSuccess() {
        
        self.tableView.reloadData()
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
extension CharacterListViewController: UISearchBarDelegate {
    
    //MARK:- SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        characterViewModel.searchName(text: searchText)
        
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
