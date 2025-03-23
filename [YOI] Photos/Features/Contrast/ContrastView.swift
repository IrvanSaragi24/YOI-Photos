//
//  ContrastEditorView.swift
//  [YOI] Photos
//
//  Created by Irvan P. Saragi on 15/03/25.
//


import SwiftUI

enum AdjustmentType {
    case brightness, contrast, saturation, blur
}

struct PhotoEdit: View {
    @State private var brightness: Double = 0.0
    @State private var contrast: Double = 1.0
    @State private var saturation: Double = 1.0
    @State private var blur: Double = 0.0
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var selectedAdjustment: AdjustmentType = .brightness
    @EnvironmentObject var router : Router

    let brightnessRange = -0.5...0.5
    let contrastRange = 0.5...1.5
    let saturationRange = 0.0...2.0
    let blurRange = 0.0...10.0
    
    var body: some View {
        NavigationView {
            VStack {
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
                .onTapGesture {
                    isShowingImagePicker = true
                }
                .padding()
                Spacer()
                VStack {
                    HStack(spacing: 30) {
                        Image(systemName: "chevron.left") // Back
                            .onTapGesture {
                                router.popToRoot()
                            }
                        
                        Image(systemName: "sun.snow.circle") // Brightness
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedAdjustment = .brightness
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: selectedAdjustment == .brightness ? 3 : 0)
                            )
                        
                        Image(systemName: "sun.lefthalf.filled") // Contrast
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedAdjustment = .contrast
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: selectedAdjustment == .contrast ? 3 : 0)
                            )
                        
                        Image(systemName: "pencil.circle") // Saturation
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedAdjustment = .saturation
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: selectedAdjustment == .saturation ? 3 : 0)
                            )
                        
                        Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal") // Blur
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedAdjustment = .blur
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(Color.orange, lineWidth: selectedAdjustment == .blur ? 3 : 0)
                            )
                        
                        Image(systemName: "arrow.uturn.backward.circle.fill") // Undo
                        Image(systemName: "arrow.uturn.right.circle.fill") // Redo
                    }
                    .padding(.leading)
                    .font(.system(size: 20))
                    
                    VStack(spacing: 20) {
                        switch selectedAdjustment {
                        case .brightness:
                            AdjustmentSlider(value: $brightness, range: brightnessRange, name: "Brightness")
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case .contrast:
                            AdjustmentSlider(value: $contrast, range: contrastRange, name: "Contrast")
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case .saturation:
                            AdjustmentSlider(value: $saturation, range: saturationRange, name: "Saturation")
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case .blur:
                            AdjustmentSlider(value: $blur, range: blurRange, name: "Blur")
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                    .padding()
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
    }
}

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

// ImagePicker to access photo library
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
