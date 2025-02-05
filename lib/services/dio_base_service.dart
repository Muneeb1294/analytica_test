import 'package:dio/dio.dart';

class DioBaseService {
  static late Dio _dio;

  static Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        // baseUrl: StringConstants.placeholderUrl,
        connectTimeout: const Duration(minutes: 60),
        receiveTimeout: const Duration(minutes: 60),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // log("URL=> ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // log("Response => ${response.data}");
        return handler.next(response);
      },
    ));
  }

  static Dio get dio {
    return _dio;
  }
}
