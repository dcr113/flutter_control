import 'package:flutter/material.dart';
import 'package:flutter_control/core.dart';

import 'cards_controller.dart';
import 'menu_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with LocalizationProvider, PrefsProvider {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ControlBase(
      debug: true,
      defaultLocale: 'en',
      locales: {
        'en': AssetPath().localization('en'),
        'cs': 'assets/localization/cs.json',
      },
      entries: {
        'cards': CardsController(),
      },
      initializers: {
        DetailController: (args) => DetailController(),
      },
      theme: (context) => MyTheme.of(context),
      root: (context) => MenuPage(),
      app: (context, key, home) {
        return BroadcastBuilder<ThemeData>(
            key: 'theme',
            defaultValue: ThemeData(
              primaryColor: Colors.orange,
            ),
            builder: (context, theme) {
              return MaterialApp(
                key: key,
                home: home,
                title: localizeDynamic('app_name', defaultValue: 'Flutter Example') as String,
                theme: theme,
              );
            });
      },
    );
  }
}

class MyTheme extends ControlTheme {
  @override
  final padding = 24.0;

  @override
  final paddingHalf = 12.0;

  final superColor = Colors.red;

  MyTheme(Device device, ThemeData data) : super(device, data);

  factory MyTheme.of(BuildContext context) {
    return MyTheme(Device.of(context), Theme.of(context));
  }

  MyTheme copy(ThemeData data) => MyTheme(
        device,
        data,
      );
}
