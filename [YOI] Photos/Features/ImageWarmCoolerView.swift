//
//  ImageWarmCoolerView.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//
import PhotosUI
import SwiftUI

struct ImageWarmCoolerView: View {
    @StateObject private var viewModel = ImageProcessorViewModel()
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            VStack {
                imageView
                Spacer()
                controlsView
                buttonsView
            }
            .navigationTitle(DataConstans.navigationTitle)
            .alert(DataConstans.imageSaved, isPresented: $viewModel.showAlert) {
                Button(DataConstans.alertButtonTitle) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .overlay(processingOverlay)
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image = viewModel.processedImage ?? viewModel.inputImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
                .cornerRadius(10)
        } else {
            ImagePlaceholderView()
        }
    }
    
    private var controlsView: some View {
        VStack {
            HStack {
                Text(DataConstans.textCooler)
                    .foregroundColor(.blue)
                Slider(value: $viewModel.temperatureValue, in: -100...100, step: 1)
                Text(DataConstans.textWarmer)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            Text("\(DataConstans.textTemperature) \(Int(viewModel.temperatureValue))")
                .padding(.top, 5)
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 20) {
            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                Label(DataConstans.labelSelectImage, systemImage: "photo.on.rectangle")
                    .buttonStyle()
            }
            .onChange(of: photoPickerItem) {_, newItem in
                Task {
                    await loadImage(from: newItem)
                }
            }
            
            Button(action: viewModel.saveImage) {
                Label(DataConstans.labelSaveImage, systemImage: "square.and.arrow.down")
                    .buttonStyle()
            }
            .disabled(viewModel.processedImage == nil)
        }
        .padding()
    }
    
    @ViewBuilder
    private var processingOverlay: some View {
        if viewModel.isProcessing {
            ZStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding(20)
                    .background(Color.secondary)
                    .cornerRadius(10)
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                throw ImageError.loadFailed
            }
            viewModel.loadImage(from: data)
        } catch {
            viewModel.showAlert(message: "\(DataConstans.ErrorLoadingImage) \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
#Preview {
    ImageWarmCoolerView()
}
