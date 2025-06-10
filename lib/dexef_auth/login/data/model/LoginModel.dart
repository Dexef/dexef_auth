import '../../../../core/rest/error_model.dart';
import '../../domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {

  LoginModel({ bool? isSuccess, List <Errors>? errors, LoginData? data})
      : super(data: data, errors: errors, isSuccess: isSuccess);

  LoginModel.fromJson(dynamic json) {
    isSuccess = json['isSuccess'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isSuccess'] = isSuccess;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    if (data != null) {
      map['data'] = data?.toJson();
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

