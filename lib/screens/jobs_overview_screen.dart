import 'package:flutter/material.dart';
import 'package:helper_app_2/widgets/job_item.dart';
import 'package:provider/provider.dart';

import '../providers/jobs.dart';
import './info_screen.dart';
import '../helpers/location_helper.dart';
import '../widgets/custom_confirmation.dart';

// Enum singning labels to integers
enum FilterOptions { Favorites, All }

class JobsOverviewScreen extends StatefulWidget {
  static const routeName = '/jobs-overview';

  @override
  _JobsOverviewScreenState createState() => _JobsOverviewScreenState();
}

class _JobsOverviewScreenState extends State<JobsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  String dropdownValue = '1';
  List<Map<String, String>> _locations;

  // In initState all the of context methods like Provider.of or ModalRoute.of do not work
  // Besides you insert listen: false
  // Possible solution: Future.delayed(Duration.zero).then(
  // Or use didChangeDependencies
  // Runs after widgets has fully initialized

  // @override
  // void initState() {
  //   Provider.of<Jobs>(context).fetchAndSetJobs();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      LocationHelper.fetchLocations().then((locations) {
        setState(() {
          _locations = locations;
          dropdownValue = locations[0]['value'];
        });
      });
      Provider.of<Jobs>(context)
          .fetchAndSetJobs(dropdownValue)
          .then((_) => {
                setState(() {
                  _isLoading = false;
                })
              })
          .catchError((err) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Achtung Fehler',
                    style: TextStyle(fontSize: 35),
                  ),
                  content: Text(
                      'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut',
                      style: TextStyle(fontSize: 20)),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        //Resolves the showDialog Future
                        Navigator.of(ctx).pushReplacementNamed("/");
                      },
                    )
                  ],
                ));
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
          context: context,
          child: CustomConfirmation(
            title: "Lieber Helfer",
            description:
                "Hier finden Sie Suchanzeigen von Personen die sich über Ihre Hilfe freuen.",
            buttonText: "Ok",
          ));
    });
  }

  // Here you have to pass BuildContext manually
  Future<void> _refreshJobs(BuildContext context) async {
    await Provider.of<Jobs>(context).fetchAndSetJobs(dropdownValue);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Here just we are just changing values with calling provider methods
    // BUT we do not need to listen to changes HERE
    // final jobsContainer = Provider.of<Jobs>(context, listen: false);

    // But we dont want to apply filters globally so we will use ant Stateful Widget

    final jobData = Provider.of<Jobs>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('TÖ Nachbarhilfe'),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.of(context).pushNamed(InfoScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshJobs(context),
                child: ListView.builder(
                    itemCount: jobData.items.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        // Columns
                        return Column(
                          children: <Widget>[
                            if (_locations != null)
                              // Location Selection
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
                                      _isLoading = true;
                                      dropdownValue = newValue;
                                    });
                                    _refreshJobs(context);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Select Location';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            jobData.items.length == 0
                                ? Column(
                                    children: <Widget>[
                                      SizedBox(height: 100),
                                      Text(
                                        "Keine Suchanzeigen vorhanden",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Container(
                                        width: 50,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.refresh,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () => {
                                                  setState(() {
                                                    _isLoading = true;
                                                  }),
                                                  _refreshJobs(context),
                                                }),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        );
                      }
                      index -= 1;
                      return ChangeNotifierProvider.value(
                        value: jobData.items[index],
                        child: JobItem(),
                      );
                    }),
              ));
  }
}
