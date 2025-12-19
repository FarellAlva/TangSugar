# TangSugar

TangSugar is a Flutter application designed to help users monitor and manage their daily sugar intake. It allows users to search for products, scan barcodes to get nutritional information, and track their consumption history.

## Features

- **Daily Sugar Tracking**: Monitor your daily sugar consumption against a recommended limit (50g).
- **Product Search**: Search for brands and products to find nutritional information.
- **Barcode Scanning**: Use the camera to scan product barcodes for quick access to sugar content details.
- **Consumption History**: Keep a log of products you've consumed.
- **Sugar Analysis**: Get insights into your sugar intake habits.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android/iOS Emulator or Physical Device

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd tangsugar
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

## Project Structure

- `lib/pages/`: Contains the UI pages (BasePage, BrandPage, BarcodePage, HistoryPage, etc.).
- `lib/model/`: Data models for Brands and Products.
- `lib/providers/`: State management providers (using Riverpod).
- `lib/services/`: Services for database or API interactions.

## Dependencies

- `flutter_riverpod`: State management.
- `shared_preferences`: Local storage for history.
- `ai_barcode_scanner`: Barcode scanning functionality.
- `http`: For API requests (if applicable).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.
