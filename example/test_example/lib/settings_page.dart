import 'package:flutter_control/core.dart';

import 'main.dart';
import 'settings_controller.dart';

class SettingsPage extends ControlWidget with ThemeProvider<MyTheme> {
  SettingsController get controller => controls[0];

  @override
  List<BaseControl> initControls() {
    return [SettingsController()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                localize('lorem_ipsum'),
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              onPressed: controller.changeLocaleToEN,
              child: Text('change locale to EN'),
            ),
            RaisedButton(
              onPressed: controller.changeLocaleToCS,
              child: Text('change locale to CS'),
            ),
            RaisedButton(
              onPressed: controller.toggleTheme,
              child: ThemeText(),
            ),
            RaisedButton(
              onPressed: controller.unloadApp,
              child: Text('unload'),
            ),
            StableWidget(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  localize('localization_info'),
                  textAlign: TextAlign.center,
                  style: font.body1.copyWith(color: theme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeText extends StatelessWidget with ThemeProvider {
  @override
  Widget build(BuildContext context) {
    invalidateTheme(context);

    return Text(
      'toggle Theme',
      style: font.button.copyWith(color: theme.primaryColor),
    );
  }
}
