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
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + $0.posterPath),
                releaseDate: $0.releaseDate,
                title: $0.title)
        }
        return model
    }
    
    func formatItem(value: [PopularTVEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + ($0.posterPath ?? "")),
                releaseDate: $0.firstAirDate ?? "",
                title: $0.originalName)
        }
        return model
    }
    
    func formatItem(value: [TopRateTVEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + ($0.posterPath ?? "")),
                releaseDate: $0.firstAirDate ?? "",
                title: $0.originalName)
        }
        return model
    }
    
    func formatItem(value: [OnAirTVEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + ($0.posterPath ?? "")),
                releaseDate: $0.firstAirDate ?? "",
                title: $0.name)
        }
        return model
    }
    
    func formatItem(value: [TVAiringTodayEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + ($0.posterPath ?? "")),
                releaseDate: $0.firstAirDate ?? "",
                title: $0.name)
        }
        return model
    }
    
    
    func formatItem(value: [ListByGenreEntity]) -> [ItemModelCell] {
        let model = value.compactMap {
            ItemModelCell(
                id: $0.id,
                artWork: URL(string: "https://image.tmdb.org/t/p/w200" + ($0.posterPath ?? "")),
                releaseDate: $0.releaseDate ?? "",
                title: $0.originalTitle)
        }
        return model
    }
    
    func formatItem(value: GenresResponse) -> [GenreModelCell] {
        let model = value.genres.compactMap {
            GenreModelCell(id: $0.id, name: $0.name)
        }
        return model
    }
    
    func formatItem(value: DetailMovieResponseEntity) -> DetailModelCell {
        let companies = value.productionCompanies.compactMap {
            Companies(id: $0.id,
                      logoPath: ($0.logoPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + $0.logoPath!) : nil,
                      name: $0.name,
                      originCountry: $0.originCountry)
        }
        let detail = DetailModelCell(isAMovie: true,
                                     adult: value.adult,
                                     backdropPath: (value.backdropPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + value.backdropPath!) : nil,
                                     episodeRunTimeTV: nil,
                                     firstAirDate: nil,
                                     genres: value.genres,
                                     id: String(value.id),
                                     inProductionTv: nil,
                                     lenguage: value.originalLanguage,
                                     name: value.originalTitle,
                                     overview: value.overview,
                                     numSeasons: nil,
                                     numSpisodes: nil,
                                     productionCompanies: companies,
                                     artwork: (value.posterPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + value.posterPath!) : nil,
                                     voteCount: value.voteCount)
        return detail
    }
    
    func formatItem(value: DetailTVResponseEntity) -> DetailModelCell {
        let companies = value.productionCompanies.compactMap {
            Companies(id: $0.id,
                      logoPath: ($0.logoPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + $0.logoPath!) : nil,
                      name: $0.name,
                      originCountry: $0.originCountry)
        }
        let detail = DetailModelCell(isAMovie: false,
                                     adult: value.adult,
                                     backdropPath: (value.backdropPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + value.backdropPath!) : nil,
                                     episodeRunTimeTV: value.episodeRunTime,
                                     firstAirDate: value.firstAirDate,
                                     genres: value.genres,
                                     id: String(value.id) ,
                                     inProductionTv: value.inProduction,
                                     lenguage: value.originalLanguage ?? "",
                                     name: value.name ?? value.originalName ?? "--",
                                     overview: value.overview,
                                     numSeasons: value.numberOfSeasons,
                                     numSpisodes: value.numberOfSeasons,
                                     productionCompanies: companies,
                                     artwork: (value.posterPath != nil) ? URL(string: "https://image.tmdb.org/t/p/w200" + value.posterPath!) : nil,
                                     voteCount: value.voteCount)
        return detail
    }
    
    
}


enum DataMovie {
    case topRateMovie(model: [ItemModelCell])
    case popularMovie(model: [ItemModelCell])
    case upComingMovie(model: [ItemModelCell])
    case nowPlayingMovie(model: [ItemModelCell])
    case topRateTV(model: [ItemModelCell])
    case popularTV(model: [ItemModelCell])
    case onAirTV(model: [ItemModelCell])
    case airingTV(model: [ItemModelCell])
    
    var title: String {
        switch self {
        case .popularMovie:
            return "Popular Movies"
        case .nowPlayingMovie:
            return "Now Playing Movies"
        case .topRateMovie:
            return "Top Rate Movies"
        case .upComingMovie:
            return "Up Coming Movies"
        case .topRateTV:
            return "Top Rate TV Shows"
        case .popularTV:
            return "Popular Tv Shows"
        case .onAirTV:
            return "On Air TV Shows"
        case .airingTV:
            return "Airing TV Shows"
        }
    }
    

}
