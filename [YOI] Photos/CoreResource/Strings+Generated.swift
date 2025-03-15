// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum StringConstants {
  /// No internet connection.
  internal static let errorNetwork = StringConstants.tr("Localizable", "error_network", fallback: "No internet connection.")
  /// helloo dunia
  internal static let helloWorld = StringConstants.tr("Localizable", "Hello world", fallback: "helloo dunia")
  /// Login successful!
  internal static let loginSuccess = StringConstants.tr("Localizable", "login_success", fallback: "Login successful!")
  /// Localizable.strings
  ///   [YOI] Photos
  /// 
  ///   Created by Irvan P. Saragi on 15/03/25.
  internal static let welcomeMessage = StringConstants.tr("Localizable", "welcome_message", fallback: "Welcome to YOI Photos!")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension StringConstants {
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
