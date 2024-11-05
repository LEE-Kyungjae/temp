import 'package:exit/viewmodels/kakaoregister_viewmodel.dart';
import 'package:exit/views/main/home/home_view.dart';
import 'package:exit/views/register/kakaoregister_view.dart';
import 'package:exit/views/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:exit/views/login/login_view.dart';
import 'package:exit/views/main/main_navigation_view.dart';
import 'package:exit/views/main/personal/my_profile_view.dart';
import 'package:exit/views/onboarding_view.dart';
import 'package:exit/views/main/personal/personal_view.dart';
import 'package:exit/views/register/localregister_view.dart';
import 'package:exit/views/main/reservation/reservation_view.dart';
import 'package:exit/views/splash_view.dart';
import 'package:exit/views/terms_and_conditions_view.dart';
import 'package:exit/views/register/zip_code_search_view.dart';
import 'package:exit/views/main/chat/chat_room_view.dart';
import 'package:exit/views/main/chat/community_view.dart';
import 'package:exit/views/main/crew/crew_view.dart';
import 'package:exit/views/login/find_id_view.dart';
import 'package:exit/views/login/find_password_view.dart';
import 'package:provider/provider.dart';
import 'route_names.dart';

class AppRoutes {
  final IOClient httpClient;
  AppRoutes({required this.httpClient});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginView(httpClient: httpClient));
      case RouteNames.main:
        return MaterialPageRoute(builder: (_) => const MainNavigationView());
      case RouteNames.myProfile:
        return MaterialPageRoute(builder: (_) => const MyProfileView());
      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case RouteNames.personal:
        return MaterialPageRoute(builder: (_) => const PersonalView());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RouteNames.localregister:
        return MaterialPageRoute(builder: (_) => LocalRegisterView(httpClient: httpClient));
      case RouteNames.kakaoregister:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => KakaoRegisterViewModel(httpClient: httpClient),
            child: const KakaoRegisterView(),
          ),
        );
      case RouteNames.reservation:
        return MaterialPageRoute(builder: (_) => const ReservationView());
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case RouteNames.termsAndConditions:
        return MaterialPageRoute(builder: (_) => TermsAndConditionsView(scrollController: ScrollController()));
      case RouteNames.zipCodeSearch:
        return MaterialPageRoute(builder: (_) => const ZipCodeSearchView());
      case RouteNames.chatRoom:
        final chatRoom = settings.arguments as Map<String, String>;
        return MaterialPageRoute(builder: (_) => ChatRoomView(chatRoom: chatRoom));
      case RouteNames.community:
        return MaterialPageRoute(builder: (_) => const CommunityView());
      case RouteNames.crew:
        return MaterialPageRoute(builder: (_) => const CrewView());
      case RouteNames.findId:
        return MaterialPageRoute(builder: (_) => const FindIdView());
      case RouteNames.findPassword:
        return MaterialPageRoute(builder: (_) => const FindPasswordView());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
