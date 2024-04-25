//
//  Main-onboard.swift
//  AnimeGen
//
//  Created by cranci on 20/04/24.
//

import SwiftUI

struct TutorialStep {
    let text: String
    let icon: String
    let tintColor: Color
    let position: String
}

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentStep = 0
    @State private var isShowingBlur = false

    var steps: [TutorialStep] {
        if #available(iOS 15.0, *) {
            return [
                TutorialStep(text: "Welcom to AnimeGen", icon: "star.fill", tintColor: .accentColor, position: "A simple way to enjoy anime Art"),
                TutorialStep(text: "Tap the Top button to switch image providers. There are 10 API options with unique images.", icon: "bookmark.fill", tintColor: .yellow, position: "Placed on the Top Center"),
                TutorialStep(text: "Hit refresh for a new image.", icon: "arrow.clockwise.circle.fill", tintColor: .secondary, position: "Placed on the Bottom Center"),
                TutorialStep(text: "Show some love! Tap the heart to save an image.", icon: "heart.fill", tintColor: .red, position: "Placed on the Bottom Center Right"),
                TutorialStep(text: "Rewind to the last image with the rewind icon.", icon: "arrowshape.turn.up.backward.circle.fill", tintColor: .green, position: "Placed on the Bottom Center Left"),
                TutorialStep(text: "Share the current image with the share icon.", icon: "square.and.arrow.up.circle.fill", tintColor: .purple, position: "Placed on the Bottom Right Corner"),
                TutorialStep(text: "Access the image URL with the Safari icon.", icon: "safari.fill", tintColor: .blue, position: "Placed on the Bottom Left Corner"),
                TutorialStep(text: "Gear up! Tap the gear icon to tweak settings.", icon: "gearshape", tintColor: .gray, position: "Placed on the Top Left Corner"),
                TutorialStep(text: "Check out the session history with the clock icon in the top right.", icon: "clock.arrow.circlepath", tintColor: .pink, position: "Placed on the Top Right Corner"),
                TutorialStep(text: "AnimeGen care about your privacy. Nothing is stored!", icon: "shield.fill", tintColor: .orange, position: "Visit Settings → About, to learn more."),
                TutorialStep(text: "Enjoy your Stay!", icon: "photo.on.rectangle.angled", tintColor: .accentColor, position: "Don't forget to share your feedbacks!")
            ]
        } else {
            return [
                TutorialStep(text: "Welcom to AnimeGen", icon: "star.fill", tintColor: .accentColor, position: "A simple way to enjoy anime Art"),
                TutorialStep(text: "Tap the Top button to switch image providers. There are 10 API options with unique images.", icon: "bookmark.fill", tintColor: .yellow, position: "Placed on the Top Center"),
                TutorialStep(text: "Hit refresh for a new image.", icon: "arrow.clockwise.circle.fill", tintColor: .secondary, position: "Placed on the Bottom Center"),
                TutorialStep(text: "Show some love! Tap the heart to save an image.", icon: "heart.fill", tintColor: .red, position: "Placed on the Bottom Center Right"),
                TutorialStep(text: "Rewind to the last image with the rewind icon.", icon: "arrowshape.turn.up.backward.circle.fill", tintColor: .green, position: "Placed on the Bottom Center Left"),
                TutorialStep(text: "Share the current image with the share icon.", icon: "square.and.arrow.up.on.square.fill", tintColor: .purple, position: "Placed on the Bottom Right Corner"),
                TutorialStep(text: "Access the image URL with the Safari icon.", icon: "safari.fill", tintColor: .blue, position: "Placed on the Bottom Left Corner"),
                TutorialStep(text: "Gear up! Tap the gear icon to tweak settings.", icon: "gearshape", tintColor: .gray, position: "Placed on the Top Left Corner"),
                TutorialStep(text: "Check out the session history with the clock icon in the top right.", icon: "clock.arrow.circlepath", tintColor: .pink, position: "Placed on the Top Right Corner"),
                TutorialStep(text: "AnimeGen care about your privacy. Nothing is stored!", icon: "shield.fill", tintColor: .orange, position: "Visit Settings → About, to learn more."),
                TutorialStep(text: "Enjoy your Stay!", icon: "photo.on.rectangle.angled", tintColor: .accentColor, position: "Don't forget to share your feedbacks!")
            ]
        }
    }
    
    var body: some View {
        ZStack {
            if isShowingBlur {
                VisualEffectBlur(blurStyle: .regular)
            }
            
            VStack {
                Spacer()
                
                VStack {
                    if currentStep < steps.count {
                        ZStack {
                            Image(systemName: steps[currentStep].icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .padding()
                                .foregroundColor(steps[currentStep].tintColor)
                                .onTapGesture {
                                    self.nextButtonTapped()
                                }
                        }
                        
                        Text(steps[currentStep].text)
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.primary)
                        
                        Text(steps[currentStep].position)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if self.currentStep == self.steps.count - 1 {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.nextButtonTapped()
                    }
                }) {
                    Text(self.currentStep == self.steps.count - 1 ? "Finish" : "Next")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                        .padding(.horizontal, 60)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(self.steps[self.currentStep].tintColor)
                        )
                }
                
                HStack {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentStep ? steps[currentStep].tintColor : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .padding(.horizontal, 4)
                    }
                }.padding(.bottom, 50)
            }
            .onAppear {
                self.startTutorial()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            self.isShowingBlur.toggle()
        }
    }
    
    func startTutorial() {
        currentStep = 0
        isShowingBlur = true
    }
    
    func nextButtonTapped() {
        currentStep += 1
        if currentStep >= steps.count {
            isShowingBlur = false
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .preferredColorScheme(.dark)
    }
}
