//
//  ContentView.swift
//  VoiceTaskApp
//
//  Created by Nada Abdullah on 17/06/1446 AH.
//

import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    @State private var items: [String] = [] // القائمة الصوتية
    @State private var isRecording = false // حالة التسجيل
    private let speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack {
            // زر التسجيل
            Button(action: {
                toggleRecording()
            }) {
                Text(isRecording ? "إيقاف التسجيل" : "ابدأ التسجيل")
                    .font(.title2)
                    .frame(width: 200, height: 50)
                    .foregroundColor(.white)
                    .background(isRecording ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            // قائمة المهام الصوتية
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Button(action: {
                            speak(text: item)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
    }
    
    // تشغيل التسجيل
    private func toggleRecording() {
        if isRecording {
            speechRecognizer.stopRecording()
        } else {
            speechRecognizer.startRecording { result in
                DispatchQueue.main.async {
                    items = result.split(separator: "،").map { String($0).trimmingCharacters(in: .whitespaces) }
                }
            }
        }
        isRecording.toggle()
    }
    
    // تحويل النص إلى صوت
    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}


#Preview {
    ContentView()
}
