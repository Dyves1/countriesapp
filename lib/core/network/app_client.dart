import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://restcountries.com/v3.1'));

  /// Fetch all countries (summary)
Future<List<dynamic>> getAllCountries() async {
  final url = '/all?fields=name,flags,population,capital,cca2'; // ⬅ added capital
  final response = await _dio.get(url);
  return response.data;
}


  /// Fetch detailed country info by its 2-letter code (cca2)
  Future<Map<String, dynamic>> getCountryDetails(String code) async {
    final url =
        '/alpha/$code?fields=name,flags,population,capital,region,subregion,area,timezones';
    final response = await _dio.get(url);
    return (response.data is List && response.data.isNotEmpty)
        ? response.data.first
        : response.data;
  }
}
