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
    var results: BehaviorRelay<[Results]>? = BehaviorRelay(value: [])
    //for keeping track of searched characters
    var searchResults: BehaviorRelay<[Results]>? = BehaviorRelay(value: [])
    //requested limit
    let resultsLimit = 20
    //if user is searching something
    var isBeingFiltered = false
    /**
     this on is the tricky part, this variable holds the ids of the characters which are fetched from the api using the search bar and those records which are not already in the results array, to keep track of if the user has favorited that particular search result it should also be shown as their favorite when loaded from the main data by scrolling down or even when the user has cleared the search bar and searched that character again.
     **/
    lazy var hasFavoritedCharacter: [Int] = []
    typealias success = ((_ characterModel: CharacterModel?)->())?
    typealias failure = ((_ error: Error)->())?
    let searchBarText = BehaviorRelay<String>(value: "")
    
    
    //Fetches the characters from the Marvel API
    func loadCharacters(offSet: Int? = 0, nameStarts: String? = nil, success: success = nil, failure: failure = nil) {
        
        APIManager.sharedInstance.request(urlConvertible: Routes.characters(limit: resultsLimit, offset: offSet, nameStartsWith: nameStarts), success: {[weak self] (characterModel: CharacterModel) in
            guard let weakSelf = self, let results = characterModel.data?.results else { return }
            if weakSelf.isBeingFiltered {
                weakSelf.parseSearchData(results: results)
            } else {
                weakSelf.parseData(characterModel: characterModel, results: results)
            }
            DispatchQueue.main.async {
                if let delegate = weakSelf.delegate {
                    delegate.didFinishFetchWithSuccess()
                }
            }
            guard let successCompleteion = success else { return }
            successCompleteion(weakSelf.characterModel)
        }) { [weak self] (error) in
          
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                if let delegate = weakSelf.delegate{
                    delegate.didFinishFetchingWithError(error: error)
                }
                guard let failureCompletion = failure else {return}
                failureCompletion(error)
            }
        }
       
    }
    //loads more data when user scrolls down
    func loadMore() {
        
        guard let characterModelData = self.characterModel?.data else {return}
        guard let offSet = characterModelData.offset else {return}
        guard let total = characterModelData.total else {return}
       
        //Pagination logic
        if offSet < total{
            self.characterModel?.data?.offset! += resultsLimit
        }else {
            let remainingResults = offSet - total
            self.characterModel?.data?.offset! -= remainingResults
        }
        if self.characterModel?.data?.offset == total{
            delegate?.nothingMoreToShow()
            return
        }
        loadCharacters(offSet: self.characterModel?.data?.offset)
        
    }
    //If user pressed the fav icon
    func favoritePressed(index: Int, isSelected: Bool) {
        
        if isBeingFiltered {
            //Get the id
            let favorite = searchResults?.value[index].id ?? 0
            //Check if the id is present in the original results
            let filteredFromOriginal = results?.value.filter{$0.id! == favorite}
            //if yes set the isFavorite to the given value
            if filteredFromOriginal?.count ?? 0 > 0 {
                filteredFromOriginal?.first?.isFavorite = isSelected
            } else {
                //if user presses the same button again, then remove the id
                if let index = hasFavoritedCharacter.index(of: favorite) {
                    hasFavoritedCharacter.remove(at: index)
                } else { //Otherwise save the id in the hasFavoritedCharacter
                    hasFavoritedCharacter.append(favorite)
                }
            }
        } else {
            //if user is not searching, just set the passed in value to isFavorite
            self.results?.value[index].isFavorite = isSelected
        }
    }
    
    //Search Character by Name
    func searchName(text:String) {
        isBeingFiltered = text.count == 0 ? false : true
        if !isBeingFiltered{
        delegate?.didFinishFetchWithSuccess()
        return
        }
        guard let results = characterModel?.data?.results else {return}
        //Search if the character name is present locally
        self.searchResults?.accept(results.filter({ (responseObject) -> Bool in
            guard let tmp: NSString = responseObject.name as NSString? else {return false}
            let range = tmp.range(of: text, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }))
        // if not, load the character from api by name
        if self.searchResults?.value.count == 0 {
            delegate?.searching()
            loadCharacters(nameStarts: text)
        } else {
            delegate?.didFinishFetchWithSuccess()
        }
    }
    
    //Returns the data count of the either Result or Search Results array
    func dataCount() -> Int {
        if isBeingFiltered{
            return searchResults?.value.count  ?? 0
        }else{
            return results?.value.count ?? 0
        }
    }
    
    //Returns the data model from either Result or Search Results array
    func getDataModel(index: Int) -> Results? {
        if isBeingFiltered{
            var search = [searchResults!.value[index]]
            filterIdsToApplyFavorite(results: &search)
            return search.first!
        } else {
            return results?.value[index]
        }

    }
    
    //Parse the data
    private func parseData(characterModel: CharacterModel, results: [Results]) {
        
        //if data is being loaded again, then append the new array into the old one.
        if let charModel = self.characterModel, let oldResults = charModel.data?.results {
            var resultsArray = oldResults + results
            self.characterModel?.data?.results = resultsArray
         //   self.results?.accept(self.characterModel!.data!.results!)
          self.results?.accept(filterIdsToApplyFavorite(results: &resultsArray))
        } else {//if data is being loaded for the first time
            self.characterModel = characterModel
            self.results?.accept(self.characterModel!.data!.results!)
            self.characterModel?.data?.offset = self.resultsLimit
        }
    }
    
    //Parse search results data
    private func parseSearchData(results: [Results]) {
        var results = results
       self.searchResults?.accept(self.filterIdsToApplyFavorite(results: &results))
    }
    
    //check if user has favorited any searched result, if yes, make the isFavorite variable true in the result.
    private func filterIdsToApplyFavorite( results: inout [Results]) -> [Results] {
        if hasFavoritedCharacter.count > 0 {
            hasFavoritedCharacter.forEach({ (id) in
                results.filter{$0.id! == id}.first?.isFavorite = true
            })
        }
        return results
    }
}
