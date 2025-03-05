# Wardy - AI-Powered Outfit Recommendation App

Wardy is a Flutter application that helps users manage their wardrobe and get outfit recommendations based on weather and personal style.

## Features

- Add clothing items with photos from camera or gallery
- Organize clothing by categories
- View detailed information about each clothing item
- Store data in Supabase for cloud synchronization
- Upload and retrieve images from Supabase Storage

## Setup Instructions

### 1. Supabase Setup

Follow the instructions in the `setup_supabase.sh` script to set up your Supabase project:

```bash
./setup_supabase.sh
```

This will guide you through:
- Creating the necessary database tables
- Setting up storage buckets
- Configuring access policies

### 2. Environment Variables

Create a `.env` file in the root of your project with your Supabase credentials:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. Permissions

The app requires the following permissions:

#### Android
The following permissions are added to the `AndroidManifest.xml`:
- `android.permission.INTERNET` - For network access
- `android.permission.CAMERA` - For taking photos
- `android.permission.READ_MEDIA_IMAGES` - For accessing gallery images
- `android.permission.READ_EXTERNAL_STORAGE` - For Android 9 and below
- `android.permission.WRITE_EXTERNAL_STORAGE` - For Android 9 and below

#### iOS
The following permissions are added to the `Info.plist`:
- `NSCameraUsageDescription` - For taking photos
- `NSPhotoLibraryUsageDescription` - For accessing gallery images
- `NSMicrophoneUsageDescription` - For video recording (if needed)

## Running the App

```bash
flutter pub get
flutter run
```

## Troubleshooting

### Camera or Gallery Access Issues
- Make sure you've granted the necessary permissions in your device settings
- For iOS, check that the usage descriptions are properly set in Info.plist
- For Android, check that the permissions are properly set in AndroidManifest.xml

### Supabase Connection Issues
- Verify your Supabase URL and anonymous key in the .env file
- Make sure you've run the SQL script to create the necessary tables
- Check that the storage bucket is properly configured with the correct policies

## Dependencies

- Flutter SDK: ^3.7.0
- image_picker: ^1.0.7
- camera: ^0.10.5+9
- permission_handler: ^11.3.1
- supabase_flutter: ^2.8.4
- And more (see pubspec.yaml for the complete list)
