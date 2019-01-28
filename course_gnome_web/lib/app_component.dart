import 'package:angular/angular.dart';

import 'package:course_gnome/controller/SchedulingPageController.dart';

import 'src/search_page/search_page_components.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [coreDirectives, SearchPageComponent],
  providers: [ClassProvider(SchedulingPageController)]
)
class AppComponent {
  final SchedulingPageController schedulingPageController;
  AppComponent(this.schedulingPageController);

  void ngOnInit() {
    // TODO: save local json
    schedulingPageController.initCalendars(null);
  }
}
