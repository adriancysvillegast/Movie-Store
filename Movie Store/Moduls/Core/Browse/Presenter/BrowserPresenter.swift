//
//  BrowserPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserPresentable: AnyObject {
    var view: BrowseView? { get }
    
    func getMovies()
    
}

class BrowserPresenter: BrowserPresentable {

    
    // MARK: - Properties
    
    weak var view: BrowseView?
    
    private var interactor: BrowserInteractable
    private var router: BrowserRouting
    
    init(interactor: BrowserInteractable, router: BrowserRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    
    // MARK: - Methods
    
    func getMovies() {
        
        Task {
            do{
                let topRate = try await interactor.getTopMovies().results
                let topRateModel = formatItems(value: topRate)
                view?.getMovies(movie: topRateModel)
            } catch APIError.errorApi{
                print("error getting info, internet problems")
            } catch APIError.errorUrl {
                print("url error")
            } catch {
                print("error")
            }
        }
        
    }
    
    private func formatItems(value: [TopRateEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                adult: $0.adult,
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + $0.posterPath),
                releaseDate: $0.releaseDate,
                title: $0.title)
        }
        return model
    }
    
}
