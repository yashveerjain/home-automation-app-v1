import 'package:flutter/material.dart';

import '../../../breakpoint.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Good Evening Yash!",
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){},
            )
          ],
        ),
      ),
    );
  }
}