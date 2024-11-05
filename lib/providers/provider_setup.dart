import 'package:exit/viewmodels/kakaoregister_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:exit/viewmodels/splash_viewmodel.dart';
import 'package:exit/viewmodels/theme_viewmodel.dart';
import 'package:exit/viewmodels/onboarding_viewmodel.dart';
import 'package:exit/viewmodels/login_viewmodel.dart';
import 'package:exit/viewmodels/localregister_viewmodel.dart';
import 'package:http/io_client.dart';

List<SingleChildWidget> providers(IOClient httpClient) {
  return [
    ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel(httpClient: httpClient)),
    ChangeNotifierProvider(create: (_) => LocalRegisterViewModel(httpClient: httpClient)),
    ChangeNotifierProvider(create: (_) => SplashViewModel()),
    ChangeNotifierProvider(create: (_) => ThemeViewModel()),
    ChangeNotifierProvider(create: (_) => KakaoRegisterViewModel(httpClient:httpClient)),
  ];
}
