//
//  JSONUtils.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/28/24.
//

import Foundation
import SwiftData

struct JSONUtils {
    
    // AnimeCharacter 데이터를 불러와 SwiftData에 저장
    static func saveAnimeCharacterData(modelContext: ModelContext) {
        guard let url = Bundle.main.url(forResource: "AnimeCharacter", withExtension: "json") else {
            print("AnimeCharacter.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for jsonItem in jsonArray {
                    let animeTitle = jsonItem["anime"] as? String ?? ""
                    let charactersArray = jsonItem["characters"] as? [[String: Any]] ?? []
                    let genre = jsonItem["genre"] as? String ?? ""
                    
                    // Anime 객체 생성
                    let anime = Anime(title: animeTitle, genre: genre)
                    modelContext.insert(anime)
                    
                    for charItem in charactersArray {
                        let name = charItem["name"] as? String ?? ""
                        let character = Character(name: name, favorite: false, anime: anime)
                        modelContext.insert(character)
                        anime.characters.append(character)
                    }
                }
                try modelContext.save()
            }
        } catch {
            print("AnimeCharacter.json 파일 읽기 또는 파싱 중 오류 발생:", error.localizedDescription)
        }
    }

    // Quotes 데이터를 불러와 SwiftData에 저장
    static func saveAnimeQuotesData(modelContext: ModelContext) {
        guard let url = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("Quotes.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for jsonItem in jsonArray {
                    let animeTitle = jsonItem["anime"] as? String ?? ""
                    let season = jsonItem["season"] as? String ?? ""
                    let episode = jsonItem["episode"] as? Int ?? 0
                    let characterName = jsonItem["character"] as? String ?? ""
                    let japanese = jsonItem["japanese"] as? [String] ?? []
                    let pronunciation = jsonItem["pronunciation"] as? [String] ?? []
                    let korean = jsonItem["korean"] as? [String] ?? []
                    let timemark = jsonItem["timemark"] as? [Double] ?? []
                    let voicingTime = jsonItem["voicingTime"] as? Double ?? 0.0
                    let audiofile = jsonItem["audiofile"] as? String ?? ""
                    let youtubeId = jsonItem["youtubeid"] as? String ?? ""
                    let youtubeStartTime = jsonItem["start"] as? Int ?? 0
                    let youtubeEndTime = jsonItem["end"] as? Int ?? 0
                    
                    // 평가 초기화
                    let evaluation = Evaluation(
                        pronunciationScore: 0.0,
                        pronunciationPass: false,
                        intonationScore: 0.0,
                        intonationPass: false,
                        speedScore: 0.0,
                        speedPass: false
                    )

                    // Anime와 Character 조회
                    let animeFetchDescriptor = FetchDescriptor<Anime>(
                        predicate: #Predicate { $0.title == animeTitle }
                    )
                    
                    if let anime = try? modelContext.fetch(animeFetchDescriptor).first,
                       let character = anime.characters.first(where: { $0.name == characterName }) {
                        
                        let newQuote = AnimeQuote(season: season, episode: episode, japanese: japanese, pronunciation: pronunciation, korean: korean, evaluation: evaluation, timemark: timemark, voicingTime: voicingTime, audiofile: audiofile, youtubeID: youtubeId, youtubeStartTime: youtubeStartTime, youtubeEndTime: youtubeEndTime)
                        
                        modelContext.insert(newQuote)
                        character.quotes.append(newQuote)
                    }
                }
                try modelContext.save()
            }
        } catch {
            print("Quotes.json 파일 읽기 또는 파싱 중 오류 발생:", error.localizedDescription)
        }
    }
}
