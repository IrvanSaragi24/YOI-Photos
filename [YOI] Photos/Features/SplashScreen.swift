//
//  SplashScreen.swift
//  [YOI] Photos
//
//  Created by Obed Willhem on 15/03/25.
//

import SwiftUI
import AVFoundation

struct SplashScreen: View {
    let audio = AudioPlayer()
    @State private var isSplashed: Bool = false
    
    var body: some View {
        ZStack {
            if isSplashed {
                SplashView(audio: audio)
                    .preferredColorScheme(.dark)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isSplashed = true
            }
        }
    }
}

struct SplashView: View {
    let audio: AudioPlayer
    @State private var text: String = "  I"
    @State private var scale: CGFloat = 0.8
    @State private var isSplashed: Bool = false
    @State private var isTapAction: Bool = false
    //    @State private var isComingSoon: Bool = false
    @Namespace var namespace
    @StateObject var router = Router()
    
    
    var titleSequence: some View {
        Text(text)
            .scaleEffect(isSplashed ? 0.7 : scale)
            .font(.custom(FontFamily.NothingFont5x7.regular.name, size: 30))
    }
    
    var body: some View {
        NavigationStack(path: $router.path)  {
            ZStack {
                Rectangle()
                    .fill(Gradient(colors: [Color("Gray1"), Color("Gray2")]))
                    .ignoresSafeArea()
                
                VStack(spacing: 8) {
                    titleSequence
                        .opacity(isSplashed ? 0.5 : 1)
                    
                    Text("photos")
                        .font(.custom(FontFamily.NothingFont5x7.regular.name, size: 60))
                        .bold()
                        .opacity(isSplashed ? 1 : 0)
                    
                    if isSplashed {
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text("TAKE")
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(isTapAction ? Color("AccentPrimary") : .white.opacity(0.2))
                                .cornerRadius(100)
                                .onTapGesture {
                                    isTapAction = false
                                }
                            
                            Text("CHOOSE")
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(isTapAction ? .white.opacity(0.2) : Color("AccentPrimary"))
                                .cornerRadius(100)
                                .onTapGesture {
                                    isTapAction = true
                                    router.path.append(.photoEditor)
                                }
                        }
                        .font(.custom(FontFamily.NothingFont5x7.regular.name, size: 17))
                        .padding()
                    }
                }
                .padding(.top, 60)
                .navigationDestination(for: Destination.self) { destination in
                  ViewFactory.viewForDestination(destination)
                }
               
            }
        
            .onAppear {
                audio.play(sound: "SPLASH")
                updateText()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring(duration: 1.5)) {
                        isSplashed = true
                    }
                }
            }
            
            
        }
        .environmentObject(router)
    }
    
    private func updateText() {
        let updates: [(String, TimeInterval)] = [
            ("Y    ", 0.125),
            ("  O  ", 0.125),
            ("Y    ", 0.25),
            ("Y O  ", 0.25),
            ("Y O I", 0.25)
        ]
        
        var delay: TimeInterval = 0
        
        for (newText, interval) in updates {
            delay += interval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                text = newText
                if newText == "Y O I" {
                    scale = 1
                }
            }
        }
    }
}

class AudioPlayer: ObservableObject {
    var players: [String: AVAudioPlayer] = [:]
    @Published var playing = false
    
    func play(sound: String) {
        guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "wav")
        else {
            print("Sound file \(sound).wav not found")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.play()
            players[sound] = player
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SplashScreen()
}

