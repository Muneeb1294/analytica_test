# Studio93 Test

A Flutter application that demonstrates integration with Google's Generative AI (Gemini) for text and speech-based interactions.

## Features

- **Text-based Chat**: Users can interact with the AI through text input
- **Speech-to-Text Integration**: Users can speak to the AI using their device's microphone
- **Real-time AI Responses**: Get instant responses from Google's Generative AI
- **Modern UI**: Clean and intuitive user interface
- **Cross-platform Support**: Works on iOS, Android, and web platforms

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.6.0 or higher)
- Dart SDK (version 3.6.0 or higher)
- Google API Key for Gemini AI

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd analytica_test
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## LLM Integration

The application uses Google's Generative AI (Gemini) through the `google_generative_ai` package. The integration works as follows:

1. **Text Processing**:
   - User input is sent to the Gemini API
   - The API processes the input and generates a response
   - Responses are displayed in real-time

2. **Speech Processing**:
   - Uses the `speech_to_text` package for voice input
   - Converts speech to text
   - Sends the converted text to Gemini API
   - Displays the AI response

## State Management

The application uses a combination of Provider and GetIt for state management:

- **Provider**: Used for managing UI state and local state management

This combination provides:
- Clean separation of concerns
- Easy state management
- Efficient dependency injection
- Scalable architecture

## Dependencies

- `google_generative_ai`: For Gemini AI integration
- `speech_to_text`: For voice input functionality
- `provider`: For state management
- `intl`: For internationalization
- `uuid`: For unique ID generation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
