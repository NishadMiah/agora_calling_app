class ApiUrl {
  static const String baseUrl = "http://apps.adff.co.za/api/v1";
  static const String imageUrl = "https://apps.adff.co.za/public/";

  ///========================= Authentication =========================
  static const String register = "/signup";
  static const String forgot = "/password/send-code";
  static const String forgotVerification = "/password/verify-code";
  static const String reset = "/password/reset";
  static const String google = "/auth/google";
  static const String joinevent = "/event/join";
  static const String login = "/login";

  ///========================= Home =========================
  static const String faqs = "/faqs";
  static const String home = "/home";
  static const String photoUpload = "/upload-profile-photo";
  static const String notifications = "/notifications";
  static const String gallery = "/gallery-categories";
  static String access({required String userId}) => "/my-access/$userId";
  static String accessd({required String userId}) => "/download-access/$userId";

  static String getProfile({required String userId}) => "/users/$userId";
  static String getSearchEvent({required String quarry}) =>
      "/search/events?q=$quarry";

  static String updateProfile({required String id}) => '/users/$id';
  static String singleCategory({required String categorisId}) =>
      '/category/$categorisId/events';
  static String singleEvent({required String categorisId}) =>
      '/events/$categorisId';
  static String singleGallery({required String categorisId}) =>
      '/gallery-category/$categorisId/photos';
  static String participent({required String categorisId}) =>
      '/event/$categorisId/joins';
  static String shareEvent({required String categorisId}) =>
      '/event/share/$categorisId';
}
