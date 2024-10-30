//
//  SpeechGrader.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/30/24.
//

import Foundation

/// Levenshtein Distance를 통해 정확도 측정
func calculatePronunciation(original: [String], sttText: String) -> Double {
    // 원본 배열을 하나의 문자열로 합침
    let originalText = original.joined()
    
    // Levenshtein Distance 계산
    let distance = levenshteinDistance(originalText, sttText)
    
    // 정확도 계산: (원본 길이 - 거리) / 원본 길이 비율
    let accuracy = Double(originalText.count - distance) / Double(originalText.count) * 100
    return max(accuracy, 0) // 정확도는 최소 0으로 반환
}

/// Levenshtein Distance 함수
private func levenshteinDistance(_ source: String, _ target: String) -> Int {
    let (sourceCount, targetCount) = (source.count, target.count)
    var distanceMatrix = [[Int]](repeating: [Int](repeating: 0, count: targetCount + 1), count: sourceCount + 1)
    
    for i in 0...sourceCount { distanceMatrix[i][0] = i }
    for j in 0...targetCount { distanceMatrix[0][j] = j }
    
    for i in 1...sourceCount {
        for j in 1...targetCount {
            let cost = source[source.index(source.startIndex, offsetBy: i - 1)] == target[target.index(target.startIndex, offsetBy: j - 1)] ? 0 : 1
            distanceMatrix[i][j] = min(
                distanceMatrix[i - 1][j] + 1, // 삭제
                distanceMatrix[i][j - 1] + 1, // 추가
                distanceMatrix[i - 1][j - 1] + cost // 대체
            )
        }
    }
    return distanceMatrix[sourceCount][targetCount]
}
