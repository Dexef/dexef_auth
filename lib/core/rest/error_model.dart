class Errors {
  String? fieldName;
  String? code;
  String? message;
  String? fieldLang;

  Errors({this.fieldName, this.code, this.message, this.fieldLang});

  Errors.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    code = json['code'];
    message = json['message'];
    fieldLang = json['fieldLang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldName'] = this.fieldName;
    data['code'] = this.code;
    data['message'] = this.message;
    data['fieldLang'] = this.fieldLang;
    return data;
  }
}