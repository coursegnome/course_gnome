import 'package:angular_router/angular_router.dart';

import '../../routes/routes.dart' as _parent;

import '../scheduling_component/scheduling_component.template.dart'
    as scheduling_component_template;
import '../schedules_component/schedules_component.template.dart'
    as schedules_component_template;
import '../advising_component/advising_component.template.dart'
    as advising_component_template;

class RoutePaths {
  static final schedules = RoutePath(
    path: 'schedules',
    parent: _parent.RoutePaths.home,
  );
  static final advising = RoutePath(
    path: 'advising',
    parent: _parent.RoutePaths.home,
  );
  static final scheduling = RoutePath(
    path: ':query',
    parent: _parent.RoutePaths.home,
  );
}

class Routes {
  // static final baseRedirect = RouteDefinition.redirect(
  //   path: '',
  //   redirectTo: Routes.login.toUrl(),
  // );
  // static final notFound = RouteDefinition.redirect(
  //   path: '.+',
  //   redirectTo: Routes.login.toUrl(),
  // );
  static final schedules = RouteDefinition(
    routePath: RoutePaths.schedules,
    component: schedules_component_template.SchedulesComponentNgFactory,
  );
  static final advising = RouteDefinition(
    routePath: RoutePaths.advising,
    component: advising_component_template.AdvisingComponentNgFactory,
  );
  static final scheduling = RouteDefinition(
    routePath: RoutePaths.scheduling,
    component: scheduling_component_template.SchedulingComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    schedules,
    advising,
    scheduling,
    // baseRedirect,
    // notFound,
  ];
}
