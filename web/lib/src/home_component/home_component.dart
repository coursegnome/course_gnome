import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:core/core.dart';

import 'src/routes/routes.dart';
import 'src/utils/auth.dart';

@Component(
  selector: 'home',
  template: '',
  directives: [routerDirectives],
  exports: [Routes],
)
class HomeComponent {
}
