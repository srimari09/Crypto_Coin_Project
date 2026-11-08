
# CryptoCoin – Cryptocurrency Tracking App

A cross-platform cryptocurrency tracking application built using Flutter and Node.js, powered by the CoinGecko API.

## Features

- Cryptocurrency listing with live market data
- Search cryptocurrencies
- Currency selection (USD, INR, EUR, GBP, JPY, AUD)
- Detailed cryptocurrency information
- Price history charts
- Global market statistics
- Watchlist management
- REST API integration

## Tech Stack

### Frontend
- Flutter
- Dart
- Provider (State Management)
- Dio (API Requests)
- FL Chart (Charts)

### Backend
- Node.js
- Express.js
- Axios
- CoinGecko API

## Project Structure

crypto_project/
- crypto_coin/       # Flutter application
- crypto_backend/    # Node.js backend
- README.md
- .gitignore

## Backend Setup

1. Navigate to the backend folder:

   cd crypto_backend

2. Install dependencies:

   npm install

3. Create a `.env` file using `.env.example`.

4. Add your CoinGecko API key to `.env`.

5. Start the backend:

   npm start

The backend runs on port 3000 by default.

## Flutter Setup

1. Navigate to the Flutter project:

   cd crypto_coin

2. Install dependencies:

   flutter pub get

3. Configure the API base URL according to your platform.

4. Run the application:

   flutter run

## API Configuration

- Android Emulator: http://10.0.2.2:3000
- iOS Simulator: http://localhost:3000
- Web: http://localhost:3000

The backend must be running before launching the application.

## Environment Variables

The backend requires a CoinGecko API key.

Never commit the actual `.env` file or API credentials to GitHub.

## Developer

Developed as part of a Flutter Developer technical assignment.
