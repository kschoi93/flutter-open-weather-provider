import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_provider/pages/search_page.dart';
import 'package:open_weather_provider/pages/settings_page.dart';
import 'package:open_weather_provider/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/temp_settings/temp_settings_provider.dart';
import '../providers/weather/weather_provider.dart';
import '../repositories/weather_repository.dart';
import '../services/weather_api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // _fetchWeather() {
  //   // WeatherRepository(
  //   //   weatherApiServices: WeatherApiServices(
  //   //     httpClient: http.Client(),
  //   //   ),
  //   // ).fetchWeather('london');

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     context.read<WeatherProvider>().fetchWeather('london');
  //   });
  // }

  String? _city;
  late final WeatherProvider _weatherProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _weatherProv = context.read<WeatherProvider>();
    _weatherProv.addListener(_registerListener);
  }

  @override
  void dispose() {
    _weatherProv.removeListener(_registerListener);
    super.dispose();
  }

  void _registerListener() {
    final WeatherState ws = context.read<WeatherProvider>().state;

    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Weather'), actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
              print('city: $_city');
              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SettingsPage();
                  }),
                );
              },
              icon: Icon(Icons.settings))
        ]),
        body: _showWeather());
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsProvider>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget _showWeather() {
    final state = context.watch<WeatherProvider>().state;

    if (state.status == WeatherStatus.initial) {
      return Center(
        child: Text(
          'select a city',
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (state.status == WeatherStatus.loading) {
      if (state.status == WeatherStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }

    if (state.status == WeatherStatus.error && state.weather.name == '') {
      return Center(
        child: Text(
          'select a city',
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    }

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          state.weather.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              style: const TextStyle(fontSize: 18.0),
            ),
            SizedBox(width: 10.0),
            Text(
              '(${state.weather.country})',
              style: const TextStyle(fontSize: 18.0),
            )
          ],
        ),
        const SizedBox(height: 6.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(state.weather.temp),
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20.0),
            Column(children: [
              Text(
                showTemperature(state.weather.tempMax),
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              Text(
                showTemperature(state.weather.tempMin),
                style: TextStyle(fontSize: 16.0),
              ),
            ]),
          ],
        ),
        const SizedBox(
          height: 40.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            ShowIcon(state.weather.icon),
            Expanded(flex: 3, child: formatText(state.weather.description)),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget ShowIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'https://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }
}
