//
//  ImageWarmCoolerViewModel.swift
//  WarmCoolerDetect
//
//  Created by Irvan P. Saragi on 01/03/25.
//

import Combine
import PhotosUI

@MainActor
final class ImageProcessorViewModel: ObservableObject {
    @Published var inputImage: UIImage?
    @Published var processedImage: UIImage?
    @Published var temperatureValue: Double = 0.0
    @Published var isProcessing = false
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    private let openCVWrapper = OpenCVWrapper()
    private var processingTask: Task<Void, Never>?
    
    // Throttle processing to avoid excessive updates
    private let processingQueue = DispatchQueue(label: DataConstans.imageProcessingQueueName, qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $temperatureValue
            .dropFirst()
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.processImage()
            }
            .store(in: &cancellables)
    }
    
    func loadImage(from data: Data) {
        guard var image = UIImage(data: data) else { return }
        
        // Force portrait orientation
        image = image.forcePortraitOrientation()
        
        inputImage = image
        processImage()
    }
    
    func processImage() {
        processingTask?.cancel()
        
        guard let inputImage = inputImage else { return }
        
        isProcessing = true
        let temperature = Float(temperatureValue)
        
        processingTask = Task { [weak self] in
            guard let self = self else { return }
            
            let processedImage = await self.processImageAsync(
                inputImage: inputImage,
                temperature: temperature
            )
            
            if !Task.isCancelled {
                self.processedImage = processedImage
                self.isProcessing = false
            }
        }
    }
    private func processImageAsync(inputImage: UIImage, temperature: Float) async -> UIImage? {
        await withCheckedContinuation { continuation in
            processingQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(returning: nil)
                    return
                }
                // Force portrait orientation first
                let orientedImage = inputImage.forcePortraitOrientation()
                
                // Process with OpenCV
                let adjustedImage = self.openCVWrapper.adjustTemperature(
                    orientedImage,
                    temperature: temperature
                )
                continuation.resume(returning: adjustedImage)
            }
        }
    }
    
    func saveImage() {
        guard let processedImage = processedImage?.forcePortraitOrientation() else {
            showAlert(message: DataConstans.alertMessageNoImageToSave)
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
            guard status == .authorized else {
                self?.showAlert(message: DataConstans.alertMessageNoPhotoLibraryAccess)
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: processedImage)
            }) { success, error in
                let message = success ?
                DataConstans.imageSavedSuccessfully :
                "\(DataConstans.errorSavingImage) \(error?.localizedDescription ?? "Unknown error")"
                
                self?.showAlert(message: message)
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
