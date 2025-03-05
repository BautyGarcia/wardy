class AppConstants {
  // App Info
  static const String appName = 'Wardy';
  static const String appTagline = 'Your Personal Outfit Assistant';
  static const String appDescription =
      'Let Wardy help you find the perfect outfit for any occasion';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Clothing Categories
  static const List<String> clothingCategories = [
    'Tops',
    'Bottoms',
    'Outerwear',
    'Dresses',
    'Footwear',
    'Accessories',
  ];

  // Clothing Properties
  static const List<String> occasionTypes = [
    'Casual',
    'Formal',
    'Business',
    'Sport',
    'Party',
    'Beach',
    'Other',
  ];

  static const List<String> seasons = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
    'All Seasons',
  ];

  static const List<String> weatherConditions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Snowy',
    'Windy',
    'Hot',
    'Cold',
  ];

  // Wardy AI Phrases
  static const List<String> wardyGreetings = [
    'Hello! I\'m Wardy, your personal outfit assistant!',
    'Hi there! Ready to find your perfect outfit today?',
    'Good to see you! Let me help you look fantastic today!',
    'Welcome back! I\'ve been thinking about your style!',
    'Hello! Let\'s make you look and feel amazing today!',
  ];

  static const List<String> wardyThinkingPhrases = [
    'Hmm, let me think...',
    'Going through your wardrobe...',
    'Matching styles and colors...',
    'Considering the weather forecast...',
    'Analyzing your personal style...',
    'Finding the perfect combination...',
  ];

  static const List<String> wardyCompliments = [
    'You\'re going to look amazing in this!',
    'This outfit suits your style perfectly!',
    'I think this combination will make you shine!',
    'You\'ll definitely stand out with this look!',
    'This outfit complements your personal style so well!',
  ];
}
