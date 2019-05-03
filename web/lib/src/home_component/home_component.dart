import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'routes/routes.dart';

@Component(
  selector: 'home',
  templateUrl: 'home_component.html',
  styleUrls: ['home_component.css'],
  directives: [routerDirectives],
  exports: [Routes],
)
class HomeComponent {
}
