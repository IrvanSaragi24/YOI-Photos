//
//  ContrastEditorView.swift
//  [YOI] Photos
//
//  Created by Irvan P. Saragi on 15/03/25.
//


import SwiftUI
import UIKit

enum AdjustmentType {
    case brightness, contrast, saturation, blur, temperature
}

struct PhotoEdit: View {
    @State private var brightness: Double = 0.0
    @State private var contrast: Double = 1.0
    @State private var saturation: Double = 1.0
    @State private var blur: Double = 0.0
    @State private var temperature: Double = 0.5
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var selectedAdjustment: AdjustmentType = .brightness
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationView {
            VStack {
                ImageDisplayView(
                    image: image,
                    brightness: brightness,
                    contrast: contrast,
                    saturation: saturation,
                    blur: blur
                )
                Spacer()
                VStack {
                    AdjustmentIconsRow(selectedAdjustment: $selectedAdjustment)
                    SliderArea(
                        selectedAdjustment: $selectedAdjustment,
                        brightness: $brightness,
                        contrast: $contrast,
                        saturation: $saturation,
                        blur: $blur,
                        temperature: $temperature
                    )
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.secondary)
                .cornerRadius(25)
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
        .onAppear {
            isShowingImagePicker = true
        }
        .onChange(of: temperature) { _ in
            applyTemperatureFilter()
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

    func resetAdjustments() {
        brightness = 0.0
        contrast = 1.0
        saturation = 1.0
        blur = 0.0
        temperature = 0.5
        applyTemperatureFilter()
    }

    // MARK: Temperature Filter
    func applyTemperatureFilter() {
        guard let inputImage = inputImage else { return }
        guard let cgImage = inputImage.cgImage else { return }

        let temperatureValue = (temperature - 0.5) * 2

        let context = CIContext()
        let ciImage = CIImage(cgImage: cgImage)

        guard let filter = CIFilter(name: "CITemperatureAndTint") else { return }
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        let neutral = CGFloat(6500)
        let targetTemperature = neutral + CGFloat(temperatureValue * 5000)
        filter.setValue(CIVector(x: targetTemperature, y: 0), forKey: "inputNeutral")

        guard let outputCIImage = filter.outputImage,
              let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return
        }

        image = Image(uiImage: UIImage(cgImage: outputCGImage))
    }
}

// MARK: - Reusable Components

struct ImageDisplayView: View {
    let image: Image?
    let brightness: Double
    let contrast: Double
    let saturation: Double
    let blur: Double

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .brightness(brightness)
                    .contrast(contrast)
                    .saturation(saturation)
                    .blur(radius: CGFloat(blur))
            } else {
                Text("Tap to select a photo")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct AdjustmentIconsRow: View {
    @Binding var selectedAdjustment: AdjustmentType
    @EnvironmentObject var router: Router

    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    router.popToRoot()
                }

            AdjustmentIcon(type: .brightness, systemName: "sun.snow.circle", selectedAdjustment: $selectedAdjustment)
            AdjustmentIcon(type: .contrast, systemName: "sun.lefthalf.filled", selectedAdjustment: $selectedAdjustment)
            AdjustmentIcon(type: .saturation, systemName: "pencil.circle", selectedAdjustment: $selectedAdjustment)
            AdjustmentIcon(type: .blur, systemName: "circle.lefthalf.filled.righthalf.striped.horizontal", selectedAdjustment: $selectedAdjustment)
            AdjustmentIcon(type: .temperature, systemName: "circle.lefthalf.filled", selectedAdjustment: $selectedAdjustment)

            Image(systemName: "arrow.uturn.backward.circle.fill")
            Image(systemName: "arrow.uturn.right.circle.fill")
        }
        .padding(.leading)
        .font(.system(size: 20))
    }
}

struct AdjustmentIcon: View {
    let type: AdjustmentType
    let systemName: String
    @Binding var selectedAdjustment: AdjustmentType

    var body: some View {
        Image(systemName: systemName)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedAdjustment = type
                }
            }
            .overlay(
                Circle()
                    .stroke(Color.orange, lineWidth: selectedAdjustment == type ? 3 : 0)
            )
    }
}

struct SliderArea: View {
    @Binding var selectedAdjustment: AdjustmentType
    @Binding var brightness: Double
    @Binding var contrast: Double
    @Binding var saturation: Double
    @Binding var blur: Double
    @Binding var temperature: Double

    var body: some View {
        VStack(spacing: 20) {
            switch selectedAdjustment {
            case .brightness:
                BrightnessSlider(brightness: $brightness)
            case .contrast:
                AdjustmentSlider(value: $contrast, range: 0.5...1.5, name: "Contrast")
            case .saturation:
                AdjustmentSlider(value: $saturation, range: 0.0...2.0, name: "Saturation")
            case .blur:
                AdjustmentSlider(value: $blur, range: 0.0...10.0, name: "Blur")
            case .temperature:
                TemperatureSlider(temperature: $temperature)
            }
        }
        .padding()
    }
}

struct BrightnessSlider: View {
    @Binding var brightness: Double

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Brightness")
                    .font(.headline)
                Spacer()
                Text("\(Int((brightness + 0.5) * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            WavySlider(
                progress: Binding<CGFloat>(
                    get: { CGFloat(brightness + 0.5) }, // Convert Double to CGFloat
                    set: { brightness = Double($0) - 0.5 } // Convert CGFloat back to Double
                ),
                lowColor: .black,
                midColor: .gray,
                highColor: .white
            )

            HStack {
                Text("Darker")
                    .font(.caption)
                    .foregroundColor(.black)

                Spacer()

                Text("Normal")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text("Brighter")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
}

struct TemperatureSlider: View {
    @Binding var temperature: Double

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Temperature")
                    .font(.headline)
                Spacer()
                Text("\(Int((temperature - 0.5) * 200))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            WavySlider(
                progress: Binding<CGFloat>(
                    get: { CGFloat(temperature) }, // Convert Double to CGFloat
                    set: { temperature = Double($0) } // Convert CGFloat back to Double
                ),
                lowColor: .blue,
                midColor: .gray,
                highColor: .orange
            )

            HStack {
                Text("Cool")
                    .font(.caption)
                    .foregroundColor(.blue)

                Spacer()

                Text("Neutral")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text("Warm")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
}

// MARK: - Custom Slider Components

struct AdjustmentSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let name: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", value))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("\(String(format: "%.1f", range.lowerBound))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Slider(value: $value, in: range)

                Text("\(String(format: "%.1f", range.upperBound))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct WavySlider: View {
    @Binding var progress: CGFloat // Use CGFloat instead of Double
    var lowColor: Color
    var midColor: Color
    var highColor: Color

    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                WavyLine(progress: progress)
                    .stroke(getLineColor(), lineWidth: 5)

                RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                    .frame(width: 20, height: 60)
                    .offset(x: progress * geo.size.width - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newProgress = max(0, min(1, value.location.x / geo.size.width))
                                if newProgress != progress {
                                    progress = newProgress
                                    feedbackGenerator.impactOccurred()
                                }
                            }
                    )
            }
        }
        .frame(height: 50)
        .padding(24)
    }

    private func getLineColor() -> Color {
        let coolProgress = abs(progress - 0.5) * 2
        let warmProgress = max(0, (progress - 0.5) * 2)

        if progress < 0.5 {
            return midColor.lerp(to: lowColor, progress: coolProgress)
        } else if progress > 0.5 {
            return midColor.lerp(to: highColor, progress: warmProgress)
        } else {
            return midColor
        }
    }
}

struct WavyLine: Shape {
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height / 2
        let baseAmplitude = progress * height / 3
        let minAmplitude = progress * height / 1.5

        let initialFrequency: CGFloat = 2
        let finalFrequency: CGFloat = 10

        path.move(to: CGPoint(x: 0, y: height))

        let step = width / 200
        for i in stride(from: 0, through: width, by: step) {
            let xProgress = i / width
            let x = i

            let amplitude = baseAmplitude * (1 - xProgress) + minAmplitude * xProgress
            let frequency = initialFrequency * (1 - xProgress) + finalFrequency * xProgress

            let y = height + amplitude * sin(xProgress * .pi * frequency)
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}

extension Color {
    func lerp(to color: Color, progress: CGFloat) -> Color {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(color)

        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return Color(
            red: Double(r1 + (r2 - r1) * progress),
            green: Double(g1 + (g2 - g1) * progress),
            blue: Double(b1 + (b2 - b1) * progress),
            opacity: Double(a1 + (a2 - a1) * progress)
        )
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEdit()
    }
}

//MARK: use for edit use openCV

//struct ContrastView: View {
//    @State private var inputImage: UIImage?
//    @State private var processedImage: UIImage?
//    @State private var temperature: Float = 0.0
//    @State private var contrast: Float = 0.0
//    @State private var objectsOnly: Bool = false  // New state for the toggle
//    @State private var isShowingImagePicker = false
//
//    private let openCVWrapper = OpenCVWrapper()
//
//    var body: some View {
//        VStack {
//            if let image = processedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .padding()
//            } else {
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .padding()
//                    .frame(height: 300)
//                    .foregroundColor(.gray)
//            }
//
//            HStack {
//                Text("Temperature")
//                Slider(value: $temperature, in: -100...100, step: 1) { _ in
//                    processImage()
//                }
//                Text("\(Int(temperature))")
//            }
//            .padding()
//
//            HStack {
//                Text("Contrast")
//                Slider(value: $contrast, in: -100...100, step: 1) { _ in
//                    processImage()
//                }
//                Text("\(Int(contrast))")
//            }
//            .padding()
//
//            // Add toggle for objects-only mode
//            Toggle("Adjust contrast for objects only", isOn: $objectsOnly)
//                .padding(.horizontal)
//                .onChange(of: objectsOnly) { _ in
//                    processImage()
//                }
//
//            Button("Select Image") {
//                isShowingImagePicker = true
//            }
//            .padding()
//        }
//        .sheet(isPresented: $isShowingImagePicker) {
//            ImagePicker(image: $inputImage, isPresented: $isShowingImagePicker)
//                .onDisappear {
//                    if inputImage != nil {
//                        processImage()
//                    }
//                }
//        }
//    }
//
//    func processImage() {
//        guard let inputImage = inputImage else { return }
//
//        // Apply temperature adjustment first
//        let tempAdjusted = openCVWrapper.adjustTemperature(inputImage, temperature: temperature)
//
//        // Then apply contrast adjustment with objectsOnly parameter
//        let finalImage = openCVWrapper.adjustContrast(tempAdjusted, contrast: contrast, objectsOnly: objectsOnly)
//
//        processedImage = finalImage
//    }
//}

// Image Picker remains unchanged
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Binding var isPresented: Bool
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//            parent.isPresented = false
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.isPresented = false
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//}
