import 'package:flutter/cupertino.dart';
import 'package:hmsapp/constants/controllers.dart';
import 'package:hmsapp/routing/router.dart';
import 'package:hmsapp/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: OverViewPageRoute,
    );
