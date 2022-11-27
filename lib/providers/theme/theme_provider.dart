// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:open_weather_provider/constants/constants.dart';
import 'package:state_notifier/state_notifier.dart';

import '../weather/weather_provider.dart';

part 'theme_state.dart';

class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initial());

  @override
  void update(Locator watch) {
    final wp = watch<WeatherState>().weather;

    if (wp.temp > kWarmOrNot) {
      state = state.copyWith(appTheme: AppTheme.light);
    } else {
      state = state.copyWith(appTheme: AppTheme.dark);
    }
    // TODO: implement update
    super.update(watch);
  }
  // final WeatherProvider wp;
  // ThemeProvider({
  //   required this.wp,
  // });
  // ThemeState get state {
  //   if (wp.state.weather.temp > kWarmOrNot) {
  //     return ThemeState();
  //   } else {
  //     return ThemeState(appTheme: AppTheme.dark);
  //   }
  // }
}
