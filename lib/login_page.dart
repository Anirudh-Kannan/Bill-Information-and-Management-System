import 'package:flutter/material.dart';
import 'auth.dart';
import 'primary_button.dart';
import 'src/shared/styles.dart';
import 'src/shared/colors.dart';
import 'globals.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.auth, this.onSignIn}) : super(key: key);

  final String title;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}


class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;
  String _authHint = '';
  List<bool> isSelected;

    @override
    void initState() {
        isSelected = [true, false];
        super.initState();
        }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n Please check username and password.';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [

      padded(child: new TextFormField(
      key: new Key('email'),
      cursorColor: primaryColor,
      style: inputFieldTextStyle,
      keyboardType: TextInputType.emailAddress,

      decoration: new InputDecoration(
        labelText: 'Email',
        fillColor: primaryColor,
        focusedBorder:OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),),),
      
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
      onSaved: (val) => _email = val,
      )),



      padded(child: new TextFormField(
        key: new Key('password'),
        cursorColor: primaryColor,

        decoration: new InputDecoration(
          fillColor: primaryColor,
          labelText: 'Password',
          focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),),),
        
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          new PrimaryButton(
            key: new Key('login'),
            text: 'Login',
            height: 44.0,
            onPressed: validateAndSubmit
          ),
          new FlatButton(
            key: new Key('need-account'),
            child: new Text("Need an account? Register"),
            onPressed: moveToRegister
          ),
        ];
      case FormType.register:
        return [
          new PrimaryButton(
            key: new Key('register'),
            text: 'Create an account',
            height: 44.0,
            onPressed: validateAndSubmit
          ),
          new FlatButton(
            key: new Key('need-login'),
            child: new Text("Have an account? Login"),
            onPressed: moveToLogin
          ),
        ];
    }
    return null;
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(
            _authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        title: Center(child:Text(getSignOrReg(),
        style: TextStyle(
        color: primaryColor, fontFamily: 'Poppins', fontSize: 15)),
        ),),
      backgroundColor: Colors.grey[100],
      body: new SingleChildScrollView(child: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          children: [
            Text('Welcome', style: h3),
            Text('Let\'s authenticate', style: taglineText),
            new Card(
              child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[custtype(),
                new Container(
                    padding: const EdgeInsets.all(16.0),
                    child: new Form(
                        key: formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: usernameAndPassword() + submitWidgets(),
                        )
                    )
                ),
                
              ])
            ),
            
            hintText()
          ]
        )
      ))
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }


String getSignOrReg()
{
  switch (_formType) {
      case FormType.login:
                        return "Sign In";
      case FormType.register:
                        return "Register";
}

return "Sign in";
}



Widget custtype(){
switch(_formType)
{
case FormType.login:
return ToggleButtons(
                borderColor: Colors.white,
                fillColor: primaryColor,
                selectedBorderColor: primaryColor,
                selectedColor: Colors.white,
                children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                        'Customer',
                        style: inputFieldTextStyle
                        
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                        'Store',style: inputFieldTextStyle
                    ),
                    ),
                ],
                onPressed: (int index) {
                    setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                        if (i == index) {
                        isSelected[i] = true;
                        
                        } else {
                        isSelected[i] = false;
                        }

                        if(isSelected[0] == true)
                        type = 'customer';
                        else
                        type = 'store';
                        print(type);

                    }
                    });
                },
                isSelected: isSelected,
                );

case FormType.register: return Container();

}

}}