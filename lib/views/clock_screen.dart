import 'package:flutter/material.dart';
import 'package:tempus/views/clock_screen_portrait.dart';

import '../services/common/route_observer.dart';
import '../services/system_chrome_service.dart';
import 'clock_screen_landscape.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> with RouteAware{
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChromeService.to.enableFullScreenMode();
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChromeService.to.enableFullScreenMode();
    });
  }

  @override
  void didPushNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChromeService.to.disableFullScreenMode();
    });
  }

  @override
  void didPop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChromeService.to.disableFullScreenMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          if(orientation == Orientation.portrait) {
            return const ClockScreenPortrait();
          }
          else{
            return const ClockScreenLandscape();
          }
        }
    );
  }
}