import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginwithapi/model/login_model.dart';
import 'package:loginwithapi/ProgressHUD.dart';
import 'package:loginwithapi/api/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage> {
  final scafflod = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
  bool observer = true;
  late LoginRequestModel loginRequestModel;
  bool isApiCallProgress = false;

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiState(context), inAsyncCall: isApiCallProgress, opacity: 0.3);
  }

  @override
  Widget _uiState(BuildContext context) {
    return Scaffold(
      key: scafflod,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Image(image: image)
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey,
                      boxShadow: [
                        BoxShadow(
                            color: Theme
                                .of(context)
                                .hintColor
                                .withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Form(
                      key: globalKey,
                      child: Column(
                        children: <Widget>[
                          Image.asset("assets/images/loginLogo.png", width: 300, height: 300,),
                          SizedBox(height: 100,),

                          Text(
                            "Login",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          new TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => loginRequestModel.email = input,
                            validator: (input) =>
                            (input?.contains("@") ?? false)
                                ? null
                                : "Enter a valid email address",
                            decoration: new InputDecoration(
                                hintText: "Email Address",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .canvasColor)),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme
                                      .of(context)
                                      .indicatorColor,
                                )),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          new TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) =>
                            loginRequestModel.password = input,
                            validator: (input) =>
                            (input != null && input.length > 3)
                                ? null
                                : "Password should be more then 3",
                            obscureText: observer,
                            decoration: new InputDecoration(
                                hintText: "Email Password",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme
                                            .of(context)
                                            .cardColor)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme
                                      .of(context)
                                      .indicatorColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      observer = !observer;
                                    });
                                  },
                                  icon: Icon(observer
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (validateState()) {
                                setState(() {
                                  isApiCallProgress = true;
                                });
                                APIService apiservice = new APIService();
                                apiservice.login(loginRequestModel).then((value){
                                    setState(() {
                                      isApiCallProgress = false;
                                    });
                                    print(value.token);
                                    if(value.token != null && value.token!.isNotEmpty){
                                      final snackbar = new SnackBar(content: Text("Sucessfully login"));
                                      if (scafflod.currentState != null) {
                                        ScaffoldMessenger.of(scafflod.currentContext!).showSnackBar(SnackBar(content: Text("Login successfull")));
                                      }
                                    }else{
                                      ScaffoldMessenger.of(scafflod.currentContext!).showSnackBar(SnackBar(content: Text("Login failed")));
                                    }
                                  });
                                print(loginRequestModel.toJson());
                              }
                            },
                            child: Text("Login"),
                          ),
                        ],
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateState() {
    final from = globalKey.currentState;
    if (from != null && from.validate()) {
      from.save();
      return true;
    }
    return false;
  }
}
