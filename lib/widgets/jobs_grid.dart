import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/jobs.dart';
import '../widgets/job_item.dart';

class JobsGrid extends StatelessWidget {
  final bool showFavs;

  JobsGrid(this.showFavs);

  // Only this Widget (and Child Widgets) will rebuild (build runs again)
  // if smthingchanges in provided object
  @override
  Widget build(BuildContext context) {
    // Set up Connection to provided onjects(classes) (like jobs)
    // And listen to changes in provided object
    // Goes up the whole widget tree and searches for the provided instance
    final jobsData = Provider.of<Jobs>(context);
    final jobs = showFavs ? jobsData.favoriteItems : jobsData.items;

    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: jobs.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: jobs[index],
          child: JobItem(),
        );
      },
    );
  }
}
