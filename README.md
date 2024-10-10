Experience Sharing App
=====================================

Table of Contents
Features
Technical Details
Future Development
Getting Started
Features
1. Experience Type Selection Screen
Description
This screen allows users to select from a list of experiences fetched from a provided API.

Key Features
A clean UI with proper spacing and styling
Experience cards displayed with image_url as background
Unselected state displays a grayscale version of the image
Multiple card selection enabled
Selected experience IDs and text stored in the state
State logged and redirected to next page on clicking "Next"
2. Onboarding Question Screen
Description
This screen is navigated to after selecting experiences.

Key Features
Multi-line textfield with a character limit of 600
Support for recording audio answers
Support for recording video answers
Technical Details
Built using Flutter framework
Utilizes API data for experience selection
Employs state management for storing user selections and text input
Implements audio and video recording capabilities
Future Development
Enhance UI/UX for improved user experience
Integrate additional features for experience sharing and discovery
Expand API integration for more comprehensive experience data
Getting Started
Prerequisites
Flutter installed and configured on your machine
Steps
Clone the repository
Navigate to the project directory
Run flutter pub get to fetch dependencies
Run flutter run to launch the app on a connected device or emulator
