//
//  OpenAIConfigurationUIViewModel.swift
//  openai-configuration-ui
//
//  Created by Daniel Vela on 22/3/25.
//

import KeychainSwift
import OpenAI
import SwiftUI

public enum ConfigurationKeyName {
  public static let url = "OACUI_CL_URL"
  public static let model = "OACUI_CL_Model"
  public static let token = "OACUI_CL_API_Token"
  public static let organizationIdentifier = "OACUI_CL_API_Organization_Identifier"
  
  public static func value(for key: String) -> String? {
    let keychain = KeychainSwift()
    return keychain.get(key)
  }
}

public class OpenAIConfigurationUIViewModel: ObservableObject {
  // Variables for text fields
  @Published var url: String = "https://api.openai.com/v1"
  @Published var model: String = "Select model"
  @Published var token: String = ""
  @Published var organizationIdentifier: String = ""
  @Published var statusMessage: String = ""
  
  // Variables to define the state of the view
  @Published var isConnectionSuccessful: Bool? = nil
  @Published var isLoading: Bool = false
  @Published var isValidUrl: Bool = true
  
  // State variable to store available models (for combo box)
  @Published var availableModels: [String] = ["Select model"]
  
  public init() {
    restoreValuesFromKeyChain()
    isValidUrl = URL(string: self.url) != nil
    isConnectionSuccessful = isValidUrl
  }
  
  func checkConnection() {
    // Logic to check the connection to the specified URL
    downloadModels()
  }
  
  func downloadModels() {
    self.isLoading = true
    Task {
      guard let (scheme, host, port, path) = extractURLComponents(from: self.url) else {
        self.isConnectionSuccessful = false
        self.statusMessage = "Invalid URL format"
        return
      }
      let configuration = OpenAI.Configuration(token: self.token,
                                               organizationIdentifier: self.organizationIdentifier,
                                               host: host,
                                               port: port,
                                               scheme: scheme,
                                               basePath: path,
                                               timeoutInterval: 10)
      let openAI = OpenAI(configuration: configuration)
      do {
        let result = try await openAI.models()
        await MainActor.run {
          self.availableModels = []
          result.data.forEach {
            self.availableModels.append($0.id)
          }
          self.model = self.availableModels.first ?? "Select model"
          self.isConnectionSuccessful = true
          self.statusMessage = "Connection successful"
          self.isLoading = false
        }
      } catch {
        await MainActor.run {
          self.isConnectionSuccessful = false
          self.statusMessage = "Error: Cannot connect to the specified URL.\n\(error.localizedDescription)"
          self.isLoading = false
        }
      }
    }
  }
  
  func saveConfiguration() {
    saveValuesToKeyChain()
  }
  
  private func restoreValuesFromKeyChain() {
    let keychain = KeychainSwift()
    if let url = keychain.get(ConfigurationKeyName.url) {
      self.url = url
    }
    if let model = keychain.get(ConfigurationKeyName.model) {
      self.model = model
      self.availableModels = [model]
    }
    if let organizationIdentifier = keychain.get(ConfigurationKeyName.organizationIdentifier) {
      self.organizationIdentifier = organizationIdentifier
    }
    if let token = keychain.get(ConfigurationKeyName.token) {
      self.token = token
    }
  }
  
  private func saveValuesToKeyChain() {
    let keychain = KeychainSwift()
    keychain.set(url, forKey: ConfigurationKeyName.url)
    keychain.set(model, forKey: ConfigurationKeyName.model)
    keychain.set(organizationIdentifier, forKey: ConfigurationKeyName.organizationIdentifier)
    keychain.set(token, forKey: ConfigurationKeyName.token)
  }
}

func extractURLComponents(from urlString: String) -> (scheme: String, host: String, port: Int, path: String)? {
  guard let url = URL(string: urlString) else {
    return nil
  }
  
  var port = 0
  guard let scheme = url.scheme,
        let host = url.host else {
    return nil
  }
  if let p = url.port {
    port = p
  } else {
    switch scheme {
    case "https":
      port = 443
    case "http":
      port = 80
    default:
      port = 0
    }
  }
  let path = url.path
  return (scheme, host, port, path)
}
