//
//  SpeechGrader.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/30/24.
//

import SwiftUI
import AVFoundation
import Accelerate

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

// 억양 점수
func calculateIntonation(referenceFileName: String, comparisonFileURL: URL) -> Double {
    // 번들에서 참조 파일의 URL을 가져옴
    guard let referenceURL = Bundle.main.url(forResource: String(referenceFileName.dropLast(4)), withExtension: "m4a") else {
        print("참조 파일을 찾을 수 없습니다.")
        return 0.0
    }
    
    // 각 파일의 피치 데이터를 추출
    guard let referencePitchData = extractPitchData(from: referenceURL),
          let comparisonPitchData = extractPitchData(from: comparisonFileURL) else {
        print("피치 데이터를 추출할 수 없습니다.")
        return 0.0
    }
    
    // 두 피치 데이터의 길이를 최소 길이로 맞추기
    let minLength = min(referencePitchData.count, comparisonPitchData.count)
    let truncatedReferenceData = Array(referencePitchData.prefix(minLength))
    let truncatedComparisonData = Array(comparisonPitchData.prefix(minLength))
    
    // 피치 패턴의 상승/하강/유지 상태 비교
    var matchingStates = 0
    for i in 1..<minLength {
        let referenceDiff = truncatedReferenceData[i] - truncatedReferenceData[i - 1]
        let comparisonDiff = truncatedComparisonData[i] - truncatedComparisonData[i - 1]
        
        let referenceState = referenceDiff > 0 ? 1 : (referenceDiff < 0 ? -1 : 0)
        let comparisonState = comparisonDiff > 0 ? 1 : (comparisonDiff < 0 ? -1 : 0)
        
        if referenceState == comparisonState {
            matchingStates += 1
        }
    }
    
    // 유사도를 0~1 사이 값으로 계산
    let similarity = Double(matchingStates) / Double(minLength - 1)
    
    // 점수화
    let score: Double
    switch similarity {
    case 0.60...1.0: // 60% ~ 70%를 95점 ~ 100점으로
        score = Int(95 + (similarity - 0.60) / 0.10 * 5)
    case 0.50..<0.60: // 50% ~ 60%를 80점 ~ 95점으로
        score = Int(80 + (similarity - 0.50) / 0.10 * 15)
    case 0.40..<0.50: // 40% ~ 50%를 40점 ~ 80점으로
        score = Int(40 + (similarity - 0.40) / 0.10 * 40)
    case 0.0..<0.40: // 0% ~ 40%를 0점 ~ 40점으로
        score = Int(similarity / 0.40 * 40)
    default:
        score = 0
    }
    
    return min(100.0, score) // 점수는 최대 100으로 제한
}

/// m4a 파일에서 피치 데이터를 추출하는 함수
func extractPitchData(from fileURL: URL) -> [CGFloat]? {
    do {
        let audioFile = try AVAudioFile(forReading: fileURL)
        let format = audioFile.processingFormat
        let frameCount = AVAudioFrameCount(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            print("PCM 버퍼 생성 실패")
            return nil
        }
        
        try audioFile.read(into: buffer)
        
        // `AudioManager2`에서 참조한 calculateRelativePitch 함수의 기능을 구현
        return calculateRelativePitch(buffer: buffer)
    } catch {
        print("오디오 파일을 읽는 데 실패했습니다: \(error)")
        return nil
    }
}

/// `calculateRelativePitch` 함수 구현
func calculateRelativePitch(buffer: AVAudioPCMBuffer) -> [CGFloat] {
    let frameLength = buffer.frameLength
    guard let channelData = buffer.floatChannelData else { return [] }

    var pitchData: [CGFloat] = []
    let frameDuration: Double = 0.05
    let sampleRate = buffer.format.sampleRate
    let frameSize = Int(Double(sampleRate) * frameDuration)
    
    var frameStart = 0
    let volumeThreshold: Float = 0.03
    let minVoiceFrequency: CGFloat = 85.0
    let maxVoiceFrequency: CGFloat = 300.0
    
    while frameStart + frameSize <= frameLength {
        let frameData = Array(UnsafeBufferPointer(start: channelData[0] + frameStart, count: frameSize))
        let rms = calculateRMS(data: frameData)
        var pitch: CGFloat
        
        if rms > volumeThreshold {
            pitch = calculatePitch(data: frameData, sampleRate: Float(sampleRate))
            
            if pitch < minVoiceFrequency || pitch > maxVoiceFrequency {
                pitch = pitchData.last ?? 0
            }
        } else {
            pitch = pitchData.last ?? 0
        }
        
        if pitchData.isEmpty {
            pitchData.append(0)
        } else {
            pitchData.append(pitch - pitchData.first!)
        }
        
        frameStart += frameSize
    }
    
    return pitchData
}

/// RMS 계산 함수
func calculateRMS(data: [Float]) -> Float {
    let squareSum = data.reduce(0) { $0 + $1 * $1 }
    return sqrt(squareSum / Float(data.count))
}

/// 피치 계산 함수
func calculatePitch(data: [Float], sampleRate: Float) -> CGFloat {
    let originalCount = data.count
    let log2n = vDSP_Length(log2(Float(8192)).rounded(.up))
    let fftSize = Int(1 << log2n)
    
    var paddedData = data
    if originalCount < fftSize {
        paddedData.append(contentsOf: [Float](repeating: 0, count: fftSize - originalCount))
    }
    
    guard let fftSetup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
        return 0.0
    }
    
    var frequency: CGFloat = 0.0
    var realParts = paddedData
    var imaginaryParts = [Float](repeating: 0.0, count: fftSize)
    
    realParts.withUnsafeMutableBufferPointer { realPointer in
        imaginaryParts.withUnsafeMutableBufferPointer { imaginaryPointer in
            var splitComplex = DSPSplitComplex(realp: realPointer.baseAddress!, imagp: imaginaryPointer.baseAddress!)
            vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))
            
            var magnitudes = [Float](repeating: 0.0, count: fftSize / 2)
            vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize / 2))
            
            if let maxMagnitude = magnitudes.max(), maxMagnitude > 0 {
                let maxIndex = magnitudes.firstIndex(of: maxMagnitude) ?? 0
                frequency = CGFloat(Float(maxIndex) * sampleRate / Float(fftSize))
            }
        }
    }
    
    vDSP_destroy_fftsetup(fftSetup)
    return frequency
}
