import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/temp_settings/temp_settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
              title: Text('Temperature Unit'),
              subtitle: Text('Celsius/Fahrenheit (Defualt: celsius)'),
              trailing: Switch(
                value: context.watch<TempSettingsState>().tempUnit ==
                    TempUnit.celsius,
                onChanged: (_) {
                  context.read<TempSettingsProvider>().toggleTempUnit();
                },
              )),
        ));
  }
}
