# OpenAI Configuration UI

## Overview

The `OpenAIConfigurationUI` is a SwiftUI-based user interface component designed to configure settings related to the OpenAI API. It allows users to input the API URL, check the connection status, and select the model they wish to use.

## Features

- **URL Input**: Allows users to enter the OpenAI API endpoint URL.
- **Connection Check**: Provides a button to verify the validity of the entered URL.
- **Token Input**: Securely inputs the API token for authentication.
- **Model Selection**: Lets users pick a model from a list of available options.

## Installation

This component is part of a larger project. To integrate it into your SwiftUI application, follow these steps:

1. Add the `OpenAIConfigurationUI.swift` file to your Xcode project.
2. Ensure that your project targets iOS 14 or later as SwiftUI and some features require this version.
3. Import `SwiftUI` in any file where you plan to use the `OpenAIConfigurationView`.

## Usage

To display the configuration view, instantiate the `OpenAIConfigurationView` struct within your SwiftUI views.

```swift
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            OpenAIConfigurationView()
        }
    }
}
```

## ViewModel

The `OpenAIConfigurationUI.swift` file includes a `ViewModel` class named `OpenAIConfigurationUIViewModel`. This class manages the state and behavior of the configuration view, handling tasks such as:

- Validating the URL.
- Checking the connection to the OpenAI API.
- Managing user input for the token and model selection.

## Dependencies

- **SwiftUI**: Required for building the user interface.
- **[KeyChain](https://github.com/evgenyneu/keychain-swift.git)**: Used internally to store the variables. (check or use `ConfigurationKeyName` enum in this project to access the values from your code)
- **[MacPaw/OpenAI](https://github.com/MacPaw/OpenAI.git)** Used internally to check the connection and download the models.

## Contributing

Contributions are welcome! Please submit an issue or a pull request if you have any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.