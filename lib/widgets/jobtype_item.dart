import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import './custom_dialog.dart';
import '../screens/user_input_screen.dart';
import './custom_confirmation.dart';

import '../providers/jobtypes.dart';
import '../providers/jobs.dart';
import '../providers/local_jobs.dart';
import '../providers/user.dart';

class JobtypeItem extends StatefulWidget {
  static const int duration = 10;
  final Map jobTypeStatus;

  JobtypeItem(@required this.jobTypeStatus);

  @override
  _JobtypeItemState createState() => _JobtypeItemState(jobTypeStatus);
}

class _JobtypeItemState extends State<JobtypeItem> {
  var timer;
  var _isLoading = false;
  final Map _jobTypeStatus;

  _JobtypeItemState(this._jobTypeStatus);

  void showDeactivateDialog(
    BuildContext context,
    Jobtype jobtype,
    Jobs jobsData,
    LocalJob localJobData,
    LocalJobs localJobsData,
  ) {
    showDialog(
        context: context,
        child: CustomDialog(
          title: "Suche deaktivieren",
          description: "Möchten Sie die Suche deaktivieren?",
          buttonText: "Ja bitte",
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
            size: 60,
          ),
        )).then((res) {
      if (!res) {
        return;
      }
      setState(() {
        _isLoading = true;
      });
      jobsData.removeJob(localJobData.id).then((_) {
        localJobsData.removeLocalJob(localJobData.id).then((_) {
          setState(() {
            _isLoading = false;
            showDialog(
              context: context,
              child: CustomConfirmation(
                title: "Suche erfolgreich deaktiviert",
                description: "Helfer können diese nun nicht mehr sehen.",
                buttonText: "Ok",
              ),
            );
          });
        });
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        print(err);
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
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      });
    });
  }

  void showActivateDialog(
    BuildContext context,
    Jobtype jobtype,
    Jobs jobsData,
    LocalJob localJob,
    LocalJobs localJobsData,
    User userData,
  ) {
    Future activatedJob = showDialog(
        context: context,
        child: CustomDialog(
          title: "Helfer finder",
          description:
              "Möchten Sie die Suche aktivieren? Nette Helfer werden Sie daraufhin möglichst bald kontaktieren.",
          buttonText: "Ja bitte",
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 60,
          ),
        ));

    activatedJob.then((el) => {
          if (el == true)
            {
              setState(() {
                _isLoading = true;
              }),
              jobsData
                  .addJob(
                jobtype.title,
                jobtype.description,
                jobtype.imageName,
                jobtype.id,
                userData.name,
                userData.phone,
                userData.location,
              )
                  .then((id) {
                localJobsData.addLocalJob(id, jobtype.id).then((_) {
                  showDialog(
                    context: context,
                    child: CustomConfirmation(
                      title: "Glückwunsch!",
                      description:
                          "Ihre Suche wurde erfolgreich aktiviert. Nette Helfer melden sich bei Ihnen in Kürze.",
                      buttonText: "Ok",
                    ),
                  );
                });
                setState(() {
                  _isLoading = false;
                });
              }).catchError((error) {
                print(error);
                // U can use the error.toString Method to get nice techical error message
                // Catch error returns also a future

                // to only resolve a Future for catchError when user clicked we can return the showDialog FUture
                // Is resolved when Navigator.of(ctx).pop(); is executed
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
                              child:
                                  Text('Okay', style: TextStyle(fontSize: 20)),
                              onPressed: () {
                                //Resolves the showDialog Future
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ));
              })
                  // if error occured call this then
                  .then((_) {
                setState(() {
                  _isLoading = false;
                });
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    final jobtype = Provider.of<Jobtype>(context);
    final jobsData = Provider.of<Jobs>(context);
    final localJobData = Provider.of<LocalJob>(context);
    final localJobsData = Provider.of<LocalJobs>(context);
    final userData = Provider.of<User>(context);

    return CupertinoButton(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/detail/${jobtype.imageName}.jpg"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _isLoading
                    ? CircularProgressIndicator()
                    : ((localJobData?.isActive ?? false)
                        ? Icon(
                            Icons.check_box,
                            size: 50.0,
                          )
                        : Icon(
                            Icons.check_box_outline_blank,
                            size: 50.0,
                          )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black54),
                      child: Text(
                        "${jobtype.title}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onPressed: () => _isLoading == false
            ? (localJobData?.isActive ?? false
                ? showDeactivateDialog(
                    context,
                    jobtype,
                    jobsData,
                    localJobData,
                    localJobsData,
                  )
                : (userData.name.isNotEmpty &&
                        userData.phone.isNotEmpty &&
                        userData.location.isNotEmpty &&
                        userData.acceptedTerms == true
                    ? showActivateDialog(
                        context,
                        jobtype,
                        jobsData,
                        localJobData,
                        localJobsData,
                        userData,
                      )
                    : showDialog(
                        context: context,
                        child: CustomConfirmation(
                          title: "Kontakt ausfüllen",
                          description:
                              "Bevor Sie eine Helfer-Suche starten können, geben Sie bitte Ihre Kontaktdaten an.",
                          buttonText: "Ok",
                        )).then((_) {
                        Navigator.of(context)
                            .pushNamed(UserInputScreen.routeName);
                      })))
            : {});
  }
}
