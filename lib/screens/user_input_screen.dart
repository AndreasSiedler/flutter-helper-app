import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../widgets/user_input_form.dart';
import '../widgets/custom_confirmation.dart';

class UserInputScreen extends StatefulWidget {
  static const routeName = '/user-input';

  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<User>(context).fetchAndSetUserData().then((_) => {
            setState(() {
              _isLoading = false;
            })
          });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await showDialog(
  //         context: context,
  //         child: CustomConfirmation(
  //           title: "Kontakt prüfen",
  //           description:
  //               "Bevor Sie eine Suche aktivieren prüfen Sie bitte Ihre Kontaktdaten.",
  //           buttonText: "Ok",
  //         ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontakt'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    UserInputForm(),
                  ]),
            )),
    );
  }
}
