import 'dart:io';
import 'package:auth_dexef/core/rest/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import 'cash_helper.dart';
import 'constants.dart';
import 'package:synchronized/synchronized.dart';

class DioHelper {
  static Dio? dio;
  static Dio? dioWorkSpace;
  static bool isRefreshing = false;
  static Dio? dioTicket;
  static final Lock lock = Lock();

  static Future<void> dioClient() async {
    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken =
          CacheHelper.getData(key: Constants.token.toString());
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response != null && error.response!.statusCode == 401) {
            RequestOptions origin = error.response!.requestOptions;

            if (!isRefreshing) {
              isRefreshing = true;
              try {
                final Response refreshTokenResponse =
                await dio!.post('/api/Auth/RefreshToken', data: {
                  'token': CacheHelper.getData(key: Constants.token.toString()),
                  'refreshToken': CacheHelper.getData(
                      key: Constants.refreshToken.toString()),
                });

                if (refreshTokenResponse.statusCode == 401) {
                  CacheHelper.clearAllData();
                  Router.neglect(navigatorKey.currentContext!, () {
                    navigatorKey.currentContext!.go(Routes.loginScreen);
                  });
                  return handler.reject(error);
                }

                String token = refreshTokenResponse.data['data']['token'];
                String refreshToken =
                refreshTokenResponse.data['data']['refreshToken'];
                CacheHelper.saveData(
                    key: Constants.token.toString(), value: token);
                CacheHelper.saveData(
                    key: Constants.refreshToken.toString(),
                    value: refreshToken);

                dio!.options.headers["Authorization"] = "Bearer $token";
                origin.headers["Authorization"] = "Bearer $token";

                if (origin.data is FormData) {
                  origin.data = await recreateFormData(origin.data);
                }

                final Response response = await dio!.fetch(origin);
                return handler.resolve(response);
              } catch (err) {
                debugPrint(err.toString());
                Fluttertoast.showToast(msg: 'Error Refreshing Token');
                CacheHelper.clearAllData();
                Router.neglect(navigatorKey.currentContext!, () {
                  navigatorKey.currentContext!.go(Routes.loginScreen);
                });
                return handler.reject(error);
              } finally {
                isRefreshing = false;
              }
            } else {
              await lock.synchronized(() {});
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<FormData> recreateFormData(FormData originalFormData) async {
    final FormData newFormData = FormData();
    originalFormData.fields.forEach((field) {
      newFormData.fields.add(MapEntry(field.key, field.value));
    });

    for (final MapEntry<String, MultipartFile> file in originalFormData.files) {
      final MultipartFile newFile = file.value.clone();
      newFormData.files.add(MapEntry(file.key, newFile));
    }

    return newFormData;
  }

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://mydexefcustomerapilive.azurewebsites.net/',
        receiveDataWhenStatusError: true,
        headers: {
          'Authorization':
          "Bearer ${CacheHelper.getData(key: Constants.token.toString())}",
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      ),
    );
    dioClient();
  }

  static void initDioTicket() {
    dioTicket = Dio(
      BaseOptions(
        baseUrl: 'https://mydexefcustomerapilive.azurewebsites.net/',
        receiveDataWhenStatusError: true,
        headers: {
          'Authorization':
          'Bearer ${CacheHelper.getData(key: Constants.token.toString())}',
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      ),
    );
  }

  static CancelToken cancelToken = CancelToken();
  static Future<Response> _getWithRetry(
      Future<Response> Function() request, {
        int retries = 2,
        int delayInSeconds = 1,
      })
  async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        final response = await request();
        return response;
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          // Rate-limited, backoff before retrying
          attempt++;
          final delay = Duration(seconds: delayInSeconds * attempt);
          print('Rate limited. Retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
        } else {
          rethrow;
        }
      }
    }
    throw DioException(
      requestOptions: RequestOptions(path: ''),
      error: 'Maximum retry attempts exceeded for 429 error',
    );
  }

  static Future<Response> getData({
    @required String? url,
    @required Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.get(
          url!,
          queryParameters: query,
          cancelToken: cancelToken,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "Accept-Language": Localizations.localeOf(currentContext).languageCode,
          }),
        );
      });
    });
  }

  static Future<Response> getInitialData({
    @required String? url,
    @required Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.get(
          url!,
          queryParameters: query,
          cancelToken: cancelToken,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "Accept-Language": Localizations.localeOf(currentContext).languageCode,
            "countryCode": CacheHelper.getData(
                key: Constants.countryCodeDownloadCenter.toString()) ??
                '20'
          }),
        );
      });
    });
  }

  static Future<Response> getDataTicket({
    @required String? url,
    @required Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dioTicket!
            .get(url!, queryParameters: query, cancelToken: cancelToken);
      });
    });
  }

  static Future<Response> getPostUpdatePhotoUser({
    @required String? url,
    @required dynamic data,
    String? token,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.post(
          url!,
          queryParameters: query,
          data: data,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "multipart/form-data",
            "Accept-Language": Localizations.localeOf(currentContext).languageCode
          }),
          cancelToken: cancelToken,
        );
      });
    });
  }

  static Future<Response> getPostData({
    @required String? url,
    @required dynamic data,
    String? token,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.post(
          url!,
          queryParameters: query,
          data: data,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "Accept-Language": Localizations.localeOf(currentContext).languageCode
          }),
          cancelToken: cancelToken,
        );
      });
    });
  }

  static Future<Response> getPostDataCreateWorkSpace({
    @required String? url,
    @required dynamic data,
    String? token,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.post(
          url!,
          queryParameters: query,
          data: data,
          cancelToken: cancelToken,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "multipart/form-data",
            "Accept-Language": Localizations.localeOf(currentContext).languageCode
          }),
        );
      });
    });
  }

  static Future<Response> updateData({
    @required String? url,
    @required dynamic data,
    String? token,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.put(
          url!,
          queryParameters: query,
          data: data,
          cancelToken: cancelToken,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
        );
      });
    });
  }

  static Future<Response> deleteData({
    @required String? url,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    return await lock.synchronized(() async {
      return await _getWithRetry(() async {
        return await dio!.delete(
          url!,
          queryParameters: query,
          cancelToken: cancelToken,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
        );
      });
    });
  }
}
////////////////////////////////////////////////////////////////////////////////

///check this
// class DioHelper {
//   static Dio? dio;
//   static Dio? dioWorkSpace;
//   static bool isRefreshing = false;
//   static final Lock lock = Lock();
//
//   static Future<void> dioClient() async {
//     dio!.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // Add access token to headers if available
//           final accessToken = CacheHelper.getData(key: Constants.token.toString());
//           if (accessToken != null) {
//             options.headers['Authorization'] = 'Bearer $accessToken';
//           }
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           // Handle token expiration or any other logic
//           return handler.next(response);
//         },
//         onError: (DioException error, ErrorInterceptorHandler handler) async {
//           if (error.response != null && error.response!.statusCode == 401) {
//             RequestOptions origin = error.response!.requestOptions;
//
//             // Check if a refresh token request is already in progress
//             if (!isRefreshing) {
//               isRefreshing = true;
//               try {
//                 final Response refreshTokenResponse =
//                 await dio!.post('/api/Auth/RefreshToken', data: {
//                   'token': CacheHelper.getData(key: Constants.token.toString()),
//                   'refreshToken': CacheHelper.getData(
//                       key: Constants.refreshToken.toString())
//                 });
//
//                 String token = refreshTokenResponse.data['data']['token'];
//                 String refreshToken =
//                 refreshTokenResponse.data['data']['refreshToken'];
//                 CacheHelper.saveData(
//                     key: Constants.token.toString(), value: token);
//                 CacheHelper.saveData(
//                     key: Constants.refreshToken.toString(),
//                     value: refreshToken);
//
//                 // Update the authorization header
//                 origin.headers["Authorization"] = "Bearer $token";
//                 dio!.options.headers["Authorization"] = "Bearer $token";
//
//                 // Retry the original request
//                 final Response response = await dio!.fetch(origin);
//                 if (response.statusCode == 200) {
//                   isRefreshing = false;
//                   return handler.resolve(response);
//                 }
//               } catch (err) {
//                 print('eeeeeeeeeeeeeeeeeeeeeeeeeee$err');
//                 print('eeeeeeeeeeeeeeeeeeeeeeeeeee$isRefreshing');
//                 isRefreshing = false;
//                 Fluttertoast.showToast(msg: 'Error Refresh Token');
//                 debugPrint(err.toString());
//
//                 CacheHelper.clearAllData();
//                 // Navigate to the login page
//                 Router.neglect(navigatorKey.currentContext!, () {
//                   navigatorKey.currentContext!.go(Routes.loginScreen);
//                 });
//                 return handler.next(error);
//               }
//             } else {
//               // Wait for the refresh token process to complete
//               await lock.synchronized(() {});
//               // Retry the original request after refresh token process is complete
//               // return handler.resolve(await dio!.fetch(origin));
//             }
//           }
//           // continue with the error if it's not a 401
//           return handler.next(error);
//         },
//       ),
//     );
//   }
//
//   static init() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://mydexefcustomerapi.azurewebsites.net/',
//         receiveDataWhenStatusError: true,
//         headers: {
//           'Authorization':
//           "Bearer ${CacheHelper.getData(key: Constants.token.toString())}",
//         },
//       ),
//     );
//
//     dioClient();
//   }
//
//   static CancelToken cancelToken = CancelToken();
//
//   static Future<Response> getData({
//     @required String? url,
//     @required Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.get(
//       url!,
//       queryParameters: query,
//       cancelToken: cancelToken,
//     );
//   }
//
//   static Future<Response> getPostUpdatePhotoUser({
//     @required String? url,
//     @required dynamic data,
//     String? token,
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.post(
//       url!,
//       queryParameters: query,
//       data: data,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "multipart/form-data",
//       }),
//       cancelToken: cancelToken,
//     );
//   }
//
//   static Future<Response> getPostData({
//     @required String? url,
//     @required dynamic data,
//     String? token,
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.post(
//       url!,
//       queryParameters: query,
//       data: data,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//       }),
//       cancelToken: cancelToken,
//     );
//   }
//
//   static Future<Response> getPostDataCreateWorkSpace({
//     @required String? url,
//     @required dynamic data,
//     String? token,
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.post(
//       url!,
//       queryParameters: query,
//       data: data,
//       cancelToken: cancelToken,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "multipart/form-data",
//       }),
//     );
//   }
//
//   static Future<Response> updateData({
//     @required String? url,
//     @required dynamic data,
//     String? token,
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.put(
//       url!,
//       queryParameters: query,
//       data: data,
//       cancelToken: cancelToken,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//       }),
//     );
//   }
//
//   // delete
//   static Future<Response> deleteData({
//     @required String? url,
//     Map<String, dynamic>? query,
//     CancelToken? cancelToken,
//   }) async {
//     return await dio!.delete(
//       url!,
//       queryParameters: query,
//       cancelToken: cancelToken,
//       options: Options(headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//       }),
//     );
//   }
// }
