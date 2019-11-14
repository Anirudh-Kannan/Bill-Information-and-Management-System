import 'package:flutter/material.dart';
import 'package:fryo/globals.dart';
import 'auth.dart';
import 'login_page.dart';
import 'src/screens/Dashboard.dart';
import 'globals.dart';
import 'src/screens/Customer.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;
/*
  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus =( (userId != null) ? AuthStatus.signedIn : AuthStatus.notSignedIn);
        print(userId);
      });
    });
  }*/

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = widget.auth;
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
      if(type=='store')
        return Dashboard(
          auth: widget.auth,
          onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );
      else
      return Customer(
          auth: widget.auth,
          onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
          );
    }
  }
}