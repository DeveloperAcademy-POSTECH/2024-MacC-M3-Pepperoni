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

    func playAudio(from fileName: String) {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil), !isPlaying else {
            print("Audio file not found or already playing.")
            return
        }
        
        stopAudio()  // 기존 재생 중이던 오디오 중지
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self  // Delegate 설정
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    // AVAudioPlayerDelegate 메서드: 오디오 재생이 끝났을 때 호출
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}



