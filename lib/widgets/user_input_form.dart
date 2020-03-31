import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../helpers/location_helper.dart';

class UserInputForm extends StatefulWidget {
  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  var _init = true;
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  String dropdownValue = '1';
  List<Map<String, String>> _locations;
  User _userData;

  var _editedUserData = {
    'name': "",
    'phone': "",
    'location': "",
    'acceptedTerms': false,
  };

  @override
  void didChangeDependencies() {
    if (_init) {
      _isLoading = true;
      LocationHelper.fetchLocations().then((locations) {
        _userData = Provider.of<User>(context);
        print(locations[0]);
        Map<String, String> newElement = {
          'value': '',
          'name': 'Wähle einen Ort'
        };
        locations.insert(0, newElement);
        setState(() {
          _locations = locations;
          _isLoading = false;

          _editedUserData['name'] = _userData.name;
          _editedUserData['phone'] = _userData.phone;
          _editedUserData['location'] = _userData.location;
          _editedUserData['acceptedTerms'] = _userData.acceptedTerms;

          dropdownValue = _userData.location.isNotEmpty
              ? _userData.location
              : locations[0]['value'];
        });
      });
    }
    _init = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedUserData['acceptedTerms']) {
      _userData.storeUser(
        _editedUserData['name'],
        _editedUserData['phone'],
        _editedUserData['location'],
        _editedUserData['acceptedTerms'],
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Kontaktdaten",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    initialValue: _editedUserData['name'],
                    decoration: InputDecoration(
                      labelText: 'Vorname',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Bitte Name angeben.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedUserData['name'] = value;
                    },
                  ),
                ),
                if (_locations != null)
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: DropdownButtonFormField(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: 'Ort',
                        border: OutlineInputBorder(),
                      ),
                      items: _locations.map((Map item) {
                        return new DropdownMenuItem<String>(
                          child: new Text(item['name']),
                          value: item['value'],
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      onSaved: (value) {
                        _editedUserData['location'] = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bitte Ort auswählen.';
                        }
                        return null;
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    initialValue: _editedUserData['phone'],
                    decoration: InputDecoration(
                      labelText: 'Telefonnummer',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Bitte Nummer angeben.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedUserData['phone'] = value;
                    },
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: FormField(
                        validator: (value) {
                          print(value);
                          if (value == false) {
                            return 'Bitte ankreuzen';
                          }
                        },
                        builder: (FormFieldState<dynamic> field) =>
                            CheckboxListTile(
                              value: _editedUserData['acceptedTerms'],
                              onChanged: (val) {
                                if (val == true) {
                                  setState(() {
                                    _editedUserData['acceptedTerms'] = true;
                                  });
                                } else if (val == false) {
                                  setState(() {
                                    _editedUserData['acceptedTerms'] = false;
                                  });
                                }
                              },
                              subtitle: !_editedUserData['acceptedTerms']
                                  ? Text(
                                      'Bitte ankreuzen.',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : null,
                              title: new Text(
                                'Hiermit bestätige ich, dass meine Kontaktdaten für andere User sichtbar sind.',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.green,
                            ))),
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 75,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _saveForm,
                    child: Text(
                      'Okay',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ));
  }
}
