import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // LOCAL
  // final String _url = 'http://10.0.2.2:8000/';

  // PRODUCTION
  final String _url = 'http://duareadminapi.duare.net/';
  final String _mapurl = 'https://maps.googleapis.com/maps/api/geocode/json';

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    print('token string  -- ${localStorage.getString('token')}');

    var token = localStorage.getString('token');
    return '?token=$token';
  }

  getApiUrl() {
    return "http://duareadmin.duare.net";
  }

  uploadApiUrl() {
    return "http://duareadminapi.duare.net/";
  }

  getDataWithTokenandQuery(apiUrl, queryParams) async {
    var fullUrl = _url + apiUrl + await _getToken() + queryParams;
    print("full get data url with token & percent is : $fullUrl");

    return await http.get(fullUrl, headers: await _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;

    print("full get data url is: $fullUrl");
    return await http.get(fullUrl, headers: _setHeaders());
  }

  // getAddress(apiUrl) async {
  //   var apiMainUri = _mapurl + apiUrl;
  //   print(apiMainUri);
  //   return await http.get(apiMainUri, headers: _setHeaders());
  // }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    print("full post data url is : $fullUrl");

    return await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
  }

  postDataWithToken(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    print("full post data url with token is : $fullUrl");

    return await http.post(fullUrl,
        body: jsonEncode(data), headers: await _setHeaders());
  }

  getDataWithToken(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    print("full get data url with token is : $fullUrl");

    return await http.get(fullUrl, headers: await _setHeaders());
  }
}
