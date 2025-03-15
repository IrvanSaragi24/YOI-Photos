// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Constans {
  /// OK
  internal static let alertButtonTitle = Constans.tr("Localizable", "alertButtonTitle", fallback: "OK")
  /// No processed image to save
  internal static let alertMessageNoImageToSave = Constans.tr("Localizable", "alertMessageNoImageToSave", fallback: "No processed image to save")
  /// Please enable photo library access in settings
  internal static let alertMessageNoPhotoLibraryAccess = Constans.tr("Localizable", "alertMessageNoPhotoLibraryAccess", fallback: "Please enable photo library access in settings")
  /// Error loading image: 
  internal static let errorLoadingImage = Constans.tr("Localizable", "ErrorLoadingImage", fallback: "Error loading image: ")
  /// Error saving image: 
  internal static let errorSavingImage = Constans.tr("Localizable", "errorSavingImage", fallback: "Error saving image: ")
  /// image.processing.queue
  internal static let imageProcessingQueueName = Constans.tr("Localizable", "imageProcessingQueueName", fallback: "image.processing.queue")
  /// Image Saved
  internal static let imageSaved = Constans.tr("Localizable", "imageSaved", fallback: "Image Saved")
  /// Image saved successfully
  internal static let imageSavedSuccessfully = Constans.tr("Localizable", "imageSavedSuccessfully", fallback: "Image saved successfully")
  /// Save Image
  internal static let labelSaveImage = Constans.tr("Localizable", "labelSaveImage", fallback: "Save Image")
  /// Select Image
  internal static let labelSelectImage = Constans.tr("Localizable", "labelSelectImage", fallback: "Select Image")
  /// Localizable.strings
  ///   [YOI] Photos
  /// 
  ///   Created by Irvan P. Saragi on 15/03/25.
  internal static let navigationTitle = Constans.tr("Localizable", "navigationTitle", fallback: "Color Temperature")
  /// No Image Selected
  internal static let noImageSelectedTitle = Constans.tr("Localizable", "noImageSelectedTitle", fallback: "No Image Selected")
  /// Cooler
  internal static let textCooler = Constans.tr("Localizable", "textCooler", fallback: "Cooler")
  /// Temperature
  internal static let textTemperature = Constans.tr("Localizable", "textTemperature", fallback: "Temperature")
  /// Warmer
  internal static let textWarmer = Constans.tr("Localizable", "textWarmer", fallback: "Warmer")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Constans {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
