//
//  AnimeQuotes.swift
//  Pepperoni
//
//  Created by 변준섭 on 10/28/24.
//

import SwiftData
import Foundation

@Model
class Anime {
    @Attribute(.unique) var id: UUID
    var title: String // 애니메이션 제목
    @Relationship(deleteRule: .cascade) var characters: [Character] // Character와 1:N 관계
    var favorite: Bool // 즐겨찾기(핀) 여부

    init(id: UUID = UUID(), title: String, characters: [Character] = [], favorite: Bool = false) {
        self.id = id
        self.title = title
        self.characters = characters
        self.favorite = favorite
    }
}

@Model
class Character {
    @Attribute(.unique) var id: UUID
    var name: String // 캐릭터 이름
    var favorite: Bool // 즐겨찾기 여부
    @Relationship(deleteRule: .cascade) var quotes: [AnimeQuote] // AnimeQuote와 1:N 관계
    var image: Data? // 사용자가 수정 가능한 캐릭터 이미지

    // Character가 속한 Anime을 나타내기 위한 관계
    @Relationship(deleteRule: .nullify, inverse: \Anime.characters) var anime: Anime?

    init(id: UUID = UUID(), name: String, favorite: Bool, quotes: [AnimeQuote] = [], image: Data? = nil, anime: Anime? = nil) {
        self.id = id
        self.name = name
        self.favorite = favorite
        self.quotes = quotes
        self.image = image
        self.anime = anime
    }
}

@Model
class AnimeQuote {
    @Attribute(.unique) var id: UUID
    var japanese: [String] // 대사 일본어 배열
    var pronunciation: [String] // 대사 발음 배열
    var korean: [String] // 대사 한국어 번역 배열
    var evaluation: Evaluation // 각 요소별 점수 및 통과 여부
    var timemark: [Double] // 각 단어(구)가 시작되는 타임마크
    var audiofile: String // 오디오 파일 이름

    // AnimeQuote가 속한 Character를 나타내기 위한 관계
    @Relationship(deleteRule: .nullify, inverse: \Character.quotes) var character: Character?

    init(id: UUID = UUID(), japanese: [String], pronunciation: [String], korean: [String], evaluation: Evaluation, timemark: [Double], audiofile: String, character: Character? = nil) {
        self.id = id
        self.japanese = japanese
        self.pronunciation = pronunciation
        self.korean = korean
        self.evaluation = evaluation
        self.timemark = timemark
        self.audiofile = audiofile
        self.character = character
    }
}

struct Evaluation: Codable {
    // pronunciation : 발음, intonation : 억양, speed : 속도
    // 각각은 점수(Score), 통과여부(Pass) 로 이루어짐
    var id: UUID
    var pronunciationScore: Double
    var pronunciationPass: Bool
    var intonationScore: Double
    var intonationPass: Bool
    var speedScore: Double
    var speedPass: Bool

    init(id: UUID=UUID(), pronunciationScore: Double, pronunciationPass: Bool, intonationScore: Double, intonationPass: Bool, speedScore: Double, speedPass: Bool) {
        self.id = id
        self.pronunciationScore = pronunciationScore
        self.pronunciationPass = pronunciationPass
        self.intonationScore = intonationScore
        self.intonationPass = intonationPass
        self.speedScore = speedScore
        self.speedPass = speedPass
    }
}