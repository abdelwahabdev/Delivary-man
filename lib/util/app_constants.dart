import 'package:efood_multivendor_driver/data/model/response/language_model.dart';
import 'package:efood_multivendor_driver/util/images.dart';

class AppConstants {
  static const String APP_NAME = 'StackFood Delivery';
  static const double APP_VERSION = 6.1;

  static const String BASE_URL = 'https://stackfood-admin.6amtech.com';
  static const String CONFIG_URI = '/api/v1/config';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/delivery-man/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/delivery-man/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/delivery-man/reset-password';
  static const String LOGIN_URI = '/api/v1/auth/delivery-man/login';
  static const String TOKEN_URI = '/api/v1/delivery-man/update-fcm-token';
  static const String CURRENT_ORDERS_URI = '/api/v1/delivery-man/current-orders?token=';
  static const String ALL_ORDERS_URI = '/api/v1/delivery-man/all-orders';
  static const String LATEST_ORDERS_URI = '/api/v1/delivery-man/latest-orders?token=';
  static const String RECORD_LOCATION_URI = '/api/v1/delivery-man/record-location-data';
  static const String PROFILE_URI = '/api/v1/delivery-man/profile?token=';
  static const String UPDATE_ORDER_STATUS_URI = '/api/v1/delivery-man/update-order-status';
  static const String UPDATE_PAYMENT_STATUS_URI = '/api/v1/delivery-man/update-payment-status';
  static const String ORDER_DETAILS_URI = '/api/v1/delivery-man/order-details?token=';
  static const String ACCEPT_ORDER_URI = '/api/v1/delivery-man/accept-order';
  static const String ACTIVE_STATUS_URI = '/api/v1/delivery-man/update-active-status';
  static const String UPDATE_PROFILE_URI = '/api/v1/delivery-man/update-profile';
  static const String NOTIFICATION_URI = '/api/v1/delivery-man/notifications?token=';
  static const String DRIVER_REMOVE = '/api/v1/delivery-man/remove-account?token=';
  static const String CURRENT_ORDER_URI = '/api/v1/delivery-man/order?token=';
  static const String DM_REGISTER_URI = '/api/v1/auth/delivery-man/store';
  static const String ZONE_LIST_URI = '/api/v1/zone/list';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String ORDER_CANCELLATION_URI = '/api/v1/customer/order/cancellation-reasons';
  static const String VEHICLES_URI = '/api/v1/get-vehicles';

  //chat url
  static const String GET_CONVERSATION_LIST = '/api/v1/delivery-man/message/list';
  static const String GET_MESSAGE_LIST_URI = '/api/v1/delivery-man/message/details';
  static const String SEND_MESSAGE_URI = '/api/v1/delivery-man/message/send';
  static const String SEARCH_CONVERSATION_LIST_URI = '/api/v1/delivery-man/message/search-list';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'efood_multivendor_driver_token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_NUMBER = 'user_number';
  static const String USER_COUNTRY_CODE = 'user_country_code';
  static const String NOTIFICATION = 'notification';
  static const String NOTIFICATION_COUNT = 'notification_count';
  static const String IGNORE_LIST = 'ignore_list';
  static const String TOPIC = 'all_zone_delivery_man';
  static const String ZONE_TOPIC = 'zone_topic';
  static const String VEHICLE_TOPIC = 'vehicle_topic';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String ZONE_ID = 'zoneId';
  static const String LANG_INTRO = 'language_intro';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
  ];
}
