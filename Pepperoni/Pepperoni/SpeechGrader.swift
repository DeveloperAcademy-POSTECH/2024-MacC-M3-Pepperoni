//
//  SpeechGrader.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/30/24.
//

import Foundation

/// 발음 정확도를 측정합니다.
func calculatePronunciation(original: [String], sttText: String) -> Double {
    // 일본어 단어 배열을 하나의 문자열로 합침
    let originalText = original.joined()
    
    // Levenshtein Distance 계산
    let distance = levenshteinDistance(originalText, sttText)
    
    // 정확도 계산: (원본 길이 - 거리) / 원본 길이 비율
    let accuracy = Double(originalText.count - distance) / Double(originalText.count) * 100
    return max(accuracy, 0) // 정확도는 최소 0으로 반환
}

/// 사용자 음성 시작지점 - 종료시점을 계산 합니다.
/// 편집 거리 알고리즘(Levenshtein Distance)
func calculateVoiceSpeed(originalLength: Double, sttVoicingTime: Double) -> Double {
    // 음성 시간이 0 이하인 경우 처리
    guard sttVoicingTime > 0 else {
        return 0.0 // 음성이 측정되지 않음
    }
    
    // 100% 점수 기준 시간 (±0.5초)
    let acceptableRange: Double = 0.8
    
    // 원래 음원 길이에 따라 점수 계산
    let minAcceptableTime = originalLength - acceptableRange
    let maxAcceptableTime = originalLength + acceptableRange
    
    if sttVoicingTime < minAcceptableTime {
        // sttVoicingTime이 너무 짧은 경우
        return max(0.0, 100.0 * (sttVoicingTime / originalLength))
    } else if sttVoicingTime > maxAcceptableTime {
        // sttVoicingTime이 너무 긴 경우
        return max(0.0, 100.0 * (originalLength / sttVoicingTime))
    } else {
        // sttVoicingTime이 허용된 범위 안에 있는 경우
        return 100.0 // 100% 점수
    }
}

/// Levenshtein Distance 함수
private func levenshteinDistance(_ source: String, _ target: String) -> Int {
    // target이 비어있거나 길이가 0인 경우 처리
    if target.isEmpty {
        return source.count 
    }
    
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
