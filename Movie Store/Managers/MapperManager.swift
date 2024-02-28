//
//  MapperManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/2/24.
//

import Foundation

class MapperManager {
    
    // MARK: - Properties
    static let shared =  MapperManager()
    
    private init() {}
    // MARK: - Methods
    
    func formatItem(value: [TopRateEntity]) -> [ItemModelCell] {
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
    
    func formatItem(value: [PopularMovieEntity]) -> [ItemModelCell] {
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
    
    func formatItem(value: [NowPlayingEntity]) -> [ItemModelCell] {
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
    
    func formatItem(value: [UpComingEntity]) -> [ItemModelCell] {
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


enum DataMovie {
    case topRate(model: [ItemModelCell])
    case popular(model: [ItemModelCell])
    case upComing(model: [ItemModelCell])
    case nowPlaying(model: [ItemModelCell])
    
    var title: String {
        switch self {
        case .popular:
            return "Popular Movies"
        case .nowPlaying:
            return "Now Playing Movies"
        case .topRate:
            return "Top Rate Movies"
        case .upComing:
            return "Up Coming Movies"
        }
    }
}
