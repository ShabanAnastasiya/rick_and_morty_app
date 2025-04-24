abstract class AppConstants {
  static const Duration INTERNET_OBSERVING_INTERVAL = Duration(seconds: 7);
  static const String INTERNET_OBSERVING_URL = 'https://www.google.com/';
  static const String DEFAULT_CHARACTER_STATUS = 'Alive';
  static const String DEFAULT_CHARACTER_SPECIES = 'Human';
  static const String SP_THEME_FLAG = 'isDarkMode';

  static const String CHARACTER_STATUS_DEAD = 'Dead';
  static const String CHARACTER_STATUS_UNKNOWN = 'Unknown';
  static const String CHARACTER_SPECIES_ALIEN = 'Alien';
  static const String LAST_KNOWN_LOCATION = 'Last known location:';
  static const String FIRST_SEEN_IN = 'First seen in:';

  static const String SETTINGS_SCREEN_TITLE = 'Light/Dark Theme';
  static const String HOME_LABEL = 'Home';
  static const String SETTINGS_LABEL = 'Settings';
  static const String NAME_LABEL = 'Name';
  static const String STATUS_LABEL = 'Status';
  static const String SPECIES_LABEL = 'Species';
  static const String CREATED_LABEL = 'Created';
  static const String GENDER_LABEL = 'Gender';
  static const String LOCATION_LABEL = 'Location';
  static const String ORIGIN_LABEL = 'Origin';

  static const String CHECK_CONNECTION = 'Check connection';
  static const String TRY_AGAIN = 'Try again';
  static const String CHARACTER_ERROR_MESSAGE = 'No internet and no cached data available';
  static const String SELECT_PAGE = 'Select a page';
  static const String ERROR_MESSAGE = 'Smth went wrong';
}
