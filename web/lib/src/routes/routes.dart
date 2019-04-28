import 'package:angular_router/angular_router.dart';

import '../login_component/login_component.template.dart'
    as login_component_template;

class RoutePaths {
  static final login = RoutePath(path: 'login');
  static final home = RoutePath(path: ':school');
}

class Routes {
  static final baseRedirect = RouteDefinition.redirect(
    path: '',
    redirectTo: Routes.login.toUrl(),
  );
  static final notFound = RouteDefinition.redirect(
    path: '.+',
    redirectTo: Routes.login.toUrl(),
  );
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_component_template.LoginComponentNgFactory,
  );
  static final home = RouteDefinition(
    routePath: RoutePaths.search,
    component: home_component_template.HomeComponentNgFactory,
  );
  static final all = <RouteDefinition>[login, baseRedirect, notFound, home];
}
