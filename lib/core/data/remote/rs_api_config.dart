mixin RSApiConfig {
  static String apiUrl = '${_getProductionBaseURL()}/api';
  static String authorizationHeader = 'Authorization';
}

String _getProductionBaseURL() {
  return '';
}
