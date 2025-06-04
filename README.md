# Adsy - iOS App

A lightweight marketplace app similar to Blocket, built with modern iOS technologies.

## Overview

Adsy is a mobile application that allows users to browse marketplace listings. The app fetches ads from a remote server, displays them in customizable list/grid views, and enables users to save favorites for offline viewing.

## Technical Solution

### Architecture

This application is built using:

- **SwiftUI**: For modern, declarative UI development
- **MVVM Pattern**: Clear separation of view, view model and model layers
- **Clean Architecture**: Organized code structure with clear responsibilities
- **SwiftData**: For local persistence of favorite ads
- **Combine**: For reactive programming patterns

The architecture follows these key principles:
- **Separation of concerns**: Each component has a clear responsibility
- **Testability**: Components are designed to be testable in isolation
- **Reusability**: Common UI elements are abstracted into reusable components
- **Reactive UI**: The interface reacts to data changes using SwiftUI's data flow mechanisms

### Key Features

- Fetch and display ads from a remote API
- Toggle between list and grid views
- Filter ads by category
- Search functionality
- Favorite ads for offline viewing
- Custom image caching solution
- Dark Mode Support

## Proud Achievements

For this project, I built a lightweight and fully testable networking package called [`SBNetworking`](https://github.com/berberoglus/SBNetworking). It separates network requests, responses, and error handling into clear, simple parts, making it easy to use and maintain.

I also wrote a full set of tests to make sure it works reliably. I’d be happy if you take a look at the package and include it in your evaluation, as I believe it shows my focus on writing clean and testable code.

## Areas for Improvement

While the current implementation works well, there are several areas that could be improved:

1. **Error Handling**: The error handling could be more robust with specific error types and better user feedback
2. **Image Caching**: While the custom caching solution works, it could benefit from more advanced features like prefetching
3. **Documentation**: More comprehensive code documentation would benefit future maintenance

## Future Enhancements

With more time, I would focus on:

1. **Testing**: Adding comprehensive unit tests and UI tests for critical user flows and view models
2. **Advanced Search**: Adding more search filters and sorting options
3. **Localization**: Supporting multiple languages

## Architecture Details

### Data Flow

1. **Networking Layer**: Handles API requests using the custom SBNetworking package
2. **Models**: Convert network data to domain models
3. **View Models**: Process business logic and prepare data for views
4. **Views**: Display data and handle user interactions

### Persistence

The app uses SwiftData to persist favorite ads locally, allowing users to view them offline.

### Caching Strategy

The app implements a custom image caching solution that:
- Stores images in memory with NSCache
- Handles memory warnings appropriately
- Tracks failed image loads to avoid repeated failures

## Getting Started

### Requirements

- iOS 17.0+
- Xcode 16.3+

### Setup

1. Clone the repository
2. Open `Adsy.xcodeproj` in Xcode
3. Run the project on your simulator

## Technologies Used

- SwiftUI
- SwiftData
- Combine
- URLSession
- SBNetworking

## License

This project is for demonstration purposes only.

