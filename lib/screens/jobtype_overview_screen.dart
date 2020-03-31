import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/jobtypes.dart';
import '../providers/local_jobs.dart';
import '../providers/user.dart';

import '../widgets/jobtype_item.dart';
import './user_input_screen.dart';
import '../helpers/db_helper.dart';
import './info_screen.dart';

class JobtypeOverviewScreen extends StatefulWidget {
  static const routeName = '/jobtype-overview';

  @override
  _JobtypeOverviewScreenState createState() => _JobtypeOverviewScreenState();
}

class _JobtypeOverviewScreenState extends State<JobtypeOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  final Map<String, dynamic> _activeJobsMap = {};

  Future _loadPage(ctx) async {
    try {
      Provider.of<LocalJobs>(context).fetchLocalJobs();
      final activeJobs = await DBHelper.getData('active_jobs');
      activeJobs.forEach((aj) {
        _activeJobsMap[aj['jobtype']] = {
          'id': aj['id'],
          'active': aj['active'],
        };
      });
      await Provider.of<Jobtypes>(context).fetchJobTypes();
      await Provider.of<User>(context).fetchAndSetUserData();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
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
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _loadPage(context);
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final jobtypeData = Provider.of<Jobtypes>(context);
    final localJobsData = Provider.of<LocalJobs>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("TÖ Nachbarhilfe"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed(UserInputScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(InfoScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _loadPage(context),
              child: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                              child: Text(
                                "Wobei kann dich das Team Österreich unterstützen?",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              padding: EdgeInsets.all(20),
                            );
                          }
                          index -= 1;

                          return MultiProvider(
                              providers: [
                                ChangeNotifierProvider.value(
                                    value: jobtypeData.items[index]),
                                ChangeNotifierProvider.value(
                                    value: localJobsData
                                        .findById(jobtypeData.items[index].id))
                              ],
                              child: JobtypeItem(_activeJobsMap
                                      .containsKey(jobtypeData.items[index].id)
                                  ? _activeJobsMap[jobtypeData.items[index].id]
                                  : {'id': null, 'active': 0}));
                        },
                        childCount: jobtypeData.items.length + 1,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
