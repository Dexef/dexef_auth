import '../../../../core/rest/error_model.dart';
import '../../domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    bool? isSuccess,
    List<Errors>? errors,
    LoginData? data,
  }) {
    _isSuccess = isSuccess;
    _errors = errors;
    _data = data;
  }

  LoginModel.fromJson(dynamic json) {
    _isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      _errors = [];
      json['errors'].forEach((v) {
        _errors?.add(Errors.fromJson(v));
      });
    }
    _data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  bool? _isSuccess;
  List<Errors>? _errors;
  LoginData? _data;

  @override
  bool? get isSuccess => _isSuccess;

  @override
  List<Errors>? get errors => _errors;

  @override
  LoginData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = _isSuccess;
    if (_errors != null) {
      map['errors'] = _errors?.map((v) => v.toJson()).toList();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE4OCIsIkRleGVmQ291bnRyeUlkIjoiNDYiLCJlbWFpbCI6InN1bGx5QG1haWxzYWMuY29tIiwic3ViIjoic3VsbHlAbWFpbHNhYy5jb20iLCJDb3VudHJ5SWQiOiI2NiIsIlN0YXR1c0lkIjoiNCIsIk5hbWUiOiJTdWxseSIsImp0aSI6IjFhY2Y2MThlLTAxMjQtNGRkZS1iMjMzLTMxN2FlY2E4NmIyZCIsIk1vYmlsZSI6IisyMDEwMDU4ODk0NzYiLCJDcm1JZCI6Ijg2NzZmM2Y2LTRmYjctZWQxMS1iZDBiLWQ5MTFkYTU3Nzc0OCIsIm5iZiI6MTcwNzk5OTQ4NSwiZXhwIjoxNzA4MDAwMDg1LCJpYXQiOjE3MDc5OTk0ODUsImlzcyI6ImRmam9sRUk1MkVUcGx4Y1dtdjJ4NlEifQ.PpRFC1gbDDijvVhLZ95_APXUzm2Y6xSSmeHUm7PJup4"
/// refreshToken : "V96402NAB68SLU7P0Z2JKX02PN8XO28MMHX1f8511df-479a-4baf-abf7-1e478c998b80"

class LoginData {
  LoginData({
    String? token,
    String? refreshToken,
  }) {
    _token = token;
    _refreshToken = refreshToken;
  }

  LoginData.fromJson(dynamic json) {
    _token = json['token'];
    _refreshToken = json['refreshToken'];
  }

  String? _token;
  String? _refreshToken;

  String? get token => _token;

  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['refreshToken'] = _refreshToken;
    return map;
  }
}

