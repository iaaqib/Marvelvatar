//
//  CharacterViewModel.swift
//  Marvelvatar
//
//  Created by Aaqib Hussain on 10/3/18.
//  Copyright © 2018 Aaqib Hussain. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CharacterViewModelDelegate: class {
    func didFinishFetchWithSuccess()
    func didFinishFetchingWithError(error: Error)
    func searching()
    func nothingMoreToShow()
}


class CharacterViewModel: NSObject {
    
    //Delegate for callbacks
    weak var delegate: CharacterViewModelDelegate? = nil
    //holds all the parsed data coming from api
    var characterModel: CharacterModel? = nil
    //to keep things clean in the controller, created this to avoid a lot of '.' to access the results from inside of characterModel
    var results: BehaviorRelay<[Results]> = BehaviorRelay(value: [])
    //for keeping track of searched characters
    private var searchResults: BehaviorRelay<[Results]> = BehaviorRelay(value: [])
    //requested limit
    let resultsLimit = 20
    //if user is searching something
    var isBeingFiltered = false
    var dataObservable: Observable<[Results]> {
        
        let res = Observable.combineLatest(results.asObservable(), searchResults.asObservable()).map { (res, search) -> [Results] in
            
            if self.isBeingFiltered {return search}
            return res
            }.asObservable()
        
        return res
    }
    
    /**
     this on is the tricky part, this variable holds the ids of the characters which are fetched from the api using the search bar and those records which are not already in the results array, to keep track of if the user has favorited that particular search result it should also be shown as their favorite when loaded from the main data by scrolling down or even when the user has cleared the search bar and searched that character again.
     **/
    lazy var hasFavoritedCharacter: [Int] = []
    typealias success = ((_ characterModel: CharacterModel?)->())?
    typealias failure = ((_ error: Error)->())?
    let searchBarText = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    
    override init() {
        super.init()
        searchCharacter()
    }
    
    
    //Fetches the characters from the Marvel API
    func loadCharacters(offSet: Int? = 0, nameStarts: String? = nil, success: success = nil, failure: failure = nil) {
        
        APIManager.sharedInstance.request(urlConvertible: Routes.characters(limit: resultsLimit, offset: offSet, nameStartsWith: nameStarts), success: {[weak self] (characterModel: CharacterModel) in
            guard let `self` = self, let results = characterModel.data?.results else { return }
            if self.isBeingFiltered {
                self.parseSearchData(results: results)
            } else {
                self.parseData(characterModel: characterModel, results: results)
            }
            DispatchQueue.main.async {
                if let delegate = self.delegate {
                    delegate.didFinishFetchWithSuccess()
                }
            }
        }) { [weak self] (error) in
            
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                if let delegate = weakSelf.delegate{
                    delegate.didFinishFetchingWithError(error: error)
                }
            }
        }
        
    }
    private func searchCharacter() {
        searchBarText
            .asObservable()
            .distinctUntilChanged()
            .debug()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                self?.searchName(text: text)
                
            }).disposed(by: disposeBag)
        
    }
    //loads more data when user scrolls down
    func loadMore() {
        
        guard let characterModelData = self.characterModel?.data, let offSet = characterModelData.offset, let total = characterModelData.total else { return }
        //Pagination logic
        if offSet < total {
            self.characterModel?.data?.offset! += resultsLimit
        } else {
            let remainingResults = offSet - total
            self.characterModel?.data?.offset! -= remainingResults
        }
        if self.characterModel?.data?.offset == total {
            delegate?.nothingMoreToShow()
            return
        }
        loadCharacters(offSet: self.characterModel?.data?.offset)
        
    }
    //Search Character by Name
    func searchName(text: String) {
        isBeingFiltered = text.count == 0 ? false : true
        if !isBeingFiltered {
            self.searchResults.accept([])
            delegate?.didFinishFetchWithSuccess()
            return
        }
        guard let results = characterModel?.data?.results else {return}
        //Search if the character name is present locally
        self.searchResults.accept(results.filter({ (responseObject) -> Bool in
            guard let tmp: NSString = responseObject.name as NSString? else {return false}
            let range = tmp.range(of: text, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }))
        // if not, load the character from api by name
        if self.searchResults.value.count == 0 {
            delegate?.searching()
            loadCharacters(nameStarts: text)
        } else {
            delegate?.didFinishFetchWithSuccess()
        }
    }
    
    //Returns the data model from either Result or Search Results array
    func getDataModel(index: Int) -> Results? {
        if isBeingFiltered {
            let search = [searchResults.value[index]]
            return search.first
        } else {
            return results.value[index]
        }
    }
    
    //Parse the data
    private func parseData(characterModel: CharacterModel, results: [Results]) {
        
        //if data is being loaded again, then append the new array into the old one.
        if let charModel = self.characterModel, let oldResults = charModel.data?.results {
            let resultsArray = oldResults + results
            self.characterModel?.data?.results = resultsArray
            self.results.accept(resultsArray)
        } else {//if data is being loaded for the first time
            self.characterModel = characterModel
            self.results.accept(self.characterModel!.data!.results!)
            self.characterModel?.data?.offset = self.resultsLimit
        }
    }
    //Parse search results data
    private func parseSearchData(results: [Results]) {
        self.searchResults.accept(results)
        
    }
}
