class Urls {
  static const String baseUrl = "http://185.128.138.205:8009/";
  static const String baseUrlWithoutSlash = "http://185.128.138.205:8009";


  //static const String baseUrl = "http://185.36.228.100";
  //static const String baseUrlWithoutSlash = "http://185.36.228.100";
  static const String apiUrl = "$baseUrl/api/";

  //api`s
  static const String auth = 'auth';
  static const String book = 'book';
  static const String user = 'user';
  static const String bulk = 'bulk/';
  static const String action = 'action/';
  static const String notification = 'notification/';
  static const String push = 'push/';
  static const String devices = 'devices/';
  static const String pushNotification = '${notification}${push}${devices}';
  static const String cardboard = 'cardboard/';
  static const String scoring = 'scoring/';
  static const String checkUpdate = 'check-update/tenotas/';
  static const String likePost = '$scoring/like-dislike/';
  static const String comments = 'comment/';
  static const String html = 'html/';
  static const String podcast = '$book/podcast';
  static const String course = 'course/';
  static const String courseFeed = '$course/feed/';
  static const String tenotas = 'tenotas/';
  static const String tenotasFeed = '$tenotas/feed/';
  static const String bookExamFetch = '$book/exam/fetch/';
  static const String bookExam = '$book/exam/';
  static const String answer = 'answer/';
  static const String authLogin = '$auth/login/';
  static const String authLogout = '$auth/logout/';
  static const String authMobile = '$auth/mobile';
  static const String authRegister = '$auth/register';
  static const String bookFeed = '$book/feed/';
  static const String category = 'category/';
  static const String interests = '$category/interests/';
  static const String sendInterest = '${category}/';
  static const String categoryList = '${category}/?no_page';
  static const String authRegisterRequest = '$authRegister/request/';
  static const String authRegisterVerify = '$authRegister/verify/';
  static const String bookMark = '$book/bookmark/';
  static const String changePassword = '$user/password/set/';
  static const String authMobileLoginRequest = '$authLogin/request/';
  static const String authMobileLoginVerify = '$authLogin/verify/';
  static const String company = 'company/';
  static const String knowledge = 'knowledge/';
  static const String management = 'management/';
  static const String managements = 'managements/';
  static const String multiple = 'multiple/';
  static const String group = 'group/';
  static const String users = 'users/';
  static const String groupsUsers = '$group$user/';
  static const String userCompany = '$user/$company/users/';
  static const String bookListKnowledgeManagement = '$book/$knowledge$management$multiple';
  static const String courseListKnowledgeManagement = '$course/$knowledge$management$multiple';
  static const String deleteListUserBook = '$book/$knowledge$management$bulk$action';
  static const String deleteListGroupBook = '$group/$bulk$action';
  static const String deleteListCourse = '$course/$knowledge$management$bulk$action';
}
