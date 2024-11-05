import 'package:exit/services/http_client_service.dart';
import 'package:exit/viewmodels/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'providers/provider_setup.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize().then((InitializationStatus status) {
    print('Initialization done: ${status.adapterStatuses}');
  });

  final ioClient = createIoClient();

  runApp(MyApp(httpClient: ioClient));
}

class MyApp extends StatelessWidget {
  final IOClient httpClient;

  const MyApp({super.key, required this.httpClient});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(httpClient),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          final appRoutes = AppRoutes(httpClient: httpClient);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Exit App',
            theme: themeViewModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            initialRoute: RouteNames.splash,
            onGenerateRoute: appRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
