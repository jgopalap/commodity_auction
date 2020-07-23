import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkUtils {
  static const Map<String, String> HTTP_HEADER = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const Map<String, String> HTTP_HEADER_1 = {
    'Accept': 'application/json; charset=UTF-8',
  };

  static const String URL_PREFIX =  'http://192.168.2.18:8000/';

  static Future<Response> getRequest(String api) {
    String url = URL_PREFIX + api;
    return http.get(url, headers: HTTP_HEADER_1);
  }

  static Future<Response> postRequest(String api, String body) {
    String url = URL_PREFIX + api;
    return http.post(
      url,
      headers: HTTP_HEADER,
      body: body,
    );
  }

  static Future<Response> putRequest(String api, String body) {
    String url = URL_PREFIX + api;
    return http.put(
      url,
      headers: HTTP_HEADER,
      body: body,
    );
  }
}