class ApiConstant {
  static String baseURL = "https://api.dev-server.one/";

  /// Home
  static String getAllProperty = "${baseURL}api/guest/property/getAllProperty";
  static String getSingleProperty = "${baseURL}api/guest/property/single/";

  Map<String,dynamic>? headers= {"Authorization": "Bearer"};
}
