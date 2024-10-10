Hotspot Hosts
=====================================
## Experience Type Selection Screen

This screen allows users to select from a list of experiences fetched from a provided API.
A clean UI with proper spacing and styling
Experience cards displayed with image_url as background
Unselected state displays a grayscale version of the image
Multiple card selection enabled
Selected experience IDs and text stored in the state
State logged and redirected to next page on clicking "Next"

## Onboarding Question Screen

This screen is navigated to after selecting experiences.
Support for recording audio answers
Support for recording video answers


## Technical Details
Built using Flutter framework
Utilizes API data for experience selection
Employs state management for storing user selections and text input
Implements audio and video recording capabilities

## Additional Features
1. Added BLoc and provider mixture to the architecture 
2. Used to Dio and build runner to create dynamic files and fetch htpp requests and responses
3. Custom Toasts on Success Failures
4. MVVM architure for cleaner and understandable code structure
