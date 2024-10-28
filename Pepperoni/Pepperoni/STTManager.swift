//
//  STTManager.swift
//  Pepperoni
//
//  Created by Woowon Kang on 10/28/24.
//

import Foundation
import Speech
import AVFoundation
import Combine

class STTManager: ObservableObject {
    @Published var isRecording = false 
    @Published var recognizedText = ""
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // Combine에서 사용할 cancellables
    private var cancellables = Set<AnyCancellable>()
    
    func startRecording() {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }
        
        isRecording = true
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        // Combine의 `Publisher`와 `Subscriber`를 사용하여 텍스트 업데이트
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                // `recognizedText`가 업데이트될 때마다 UI에 반영됨
                DispatchQueue.main.async {
                    self?.recognizedText = result.bestTranscription.formattedString
                }
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self?.stopRecording()
            }
        }
    }
    
    func stopRecording() {
        isRecording = false
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
}
