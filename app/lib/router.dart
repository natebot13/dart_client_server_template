import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginWrapperRoute.page,
          path: '/auth',
          children: [
            AutoRoute(path: '', page: LoginRoute.page),
            AutoRoute(path: 'forgot', page: ForgotPasswordRoute.page),
            AutoRoute(path: 'verify', page: VerifyEmailRoute.page)
          ],
        ),
        AutoRoute(page: HomeRoute.page),
      ];
}
