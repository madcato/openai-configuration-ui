import SwiftUI

public struct OpenAIConfigurationView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject private var viewModel = OpenAIConfigurationUIViewModel()

  public init() {
    
  }
  public var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Configure OpenAI API")
        .font(.largeTitle)
      
      HStack {
        TextField("URL", text: $viewModel.url)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .onChange(of: viewModel.url, perform: { newValue in
            viewModel.isValidUrl = URL(string: newValue) != nil
          })
        if viewModel.isLoading {
          ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
        } else {
          Button(action: viewModel.checkConnection, label: {
            Text("Check")
          })
          .disabled(!viewModel.isValidUrl)
        }
      }
      if viewModel.statusMessage != "" {
        Text(viewModel.statusMessage)
          .foregroundColor(viewModel.isConnectionSuccessful ?? false ? .green : .red)
          .padding()
          .background(Color.black.opacity(0.1))
          .cornerRadius(8)
      }
      
      SecureField("Token", text: $viewModel.token)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      HStack {
        Picker(selection: $viewModel.model, label: Text("Model")) {
          ForEach(viewModel.availableModels, id: \.self) { model in
            Text(model).tag(model)
          }
        }
        .pickerStyle(MenuPickerStyle())
        
        if viewModel.isLoading {
          ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
        } else {
          Button(action: viewModel.downloadModels, label: {
            Text("Download models")
          })
          .disabled(!viewModel.isValidUrl)
        }
      }
      
      TextField("Organization Identifier (Optional)", text: $viewModel.organizationIdentifier)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      
      Button(action: saveConfiguration, label: {
        Text("Save")
      })
      .disabled((viewModel.isConnectionSuccessful ?? false) == false)
    }
    .padding()
  }
  
  
  
  func saveConfiguration() {
    viewModel.saveConfiguration()
    // Dismiss the view
    presentationMode.wrappedValue.dismiss()
  }
}

struct ConfigurationView_Previews: PreviewProvider {
  static var previews: some View {
    OpenAIConfigurationView()
  }
}
