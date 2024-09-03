class LoginResponseModel {
  String? token;
  String? error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return LoginResponseModel(
        token: json["token"] ?? "",
        error: json["error"] ?? ""
    );
  }
}

class LoginRequestModel {
  String? email;
  String? password;

  LoginRequestModel({this.email, this.password});

  Map<String, dynamic> toJson() {
    return {
      "email": email?.trim() ?? "",    // Use ?.trim() to avoid calling trim on null
      "password": password?.trim() ?? ""  // Provide a default value of an empty string
    };
  }
}