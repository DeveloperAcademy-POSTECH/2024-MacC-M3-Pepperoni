//
//  AudioPlayerManager.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/31/24.
//

import AVFoundation
import Combine

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    private var timer: Timer?
    @Published var currentTime: Double = 0.0 // 현재 재생 시간, @Published로 선언하여 변화를 감지

    func playAudio(from fileName: String) {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil), !isPlaying else {
            print("Audio file not found or already playing.")
            return
        }
        
        // 무음 모드에서도 소리를 재생할 수 있도록 오디오 세션 설정
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
        
        stopAudio()  // 기존 재생 중이던 오디오 중지
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self  // Delegate 설정
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
            startTimer()  // 타이머 시작
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    private func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()  // 타이머 정지
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            if let player = self?.audioPlayer {
                self?.currentTime = player.currentTime
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        self.currentTime = 0.0
    }
    
    // AVAudioPlayerDelegate 메서드: 오디오 재생이 끝났을 때 호출
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        stopTimer()  // 타이머 정지
    }
}
