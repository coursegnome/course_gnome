import 'package:angular/angular.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_button/material_button.dart';

import 'package:course_gnome/controller/SchedulingPageController.dart';
import 'package:course_gnome/model/Course.dart';

@Component(
  selector: 'search-page',
  templateUrl: 'search_page_component.html',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'search_page_component.css',
  ],
  directives: [
    coreDirectives,
    CourseCardComponent,
    MaterialIconComponent,
    MaterialButtonComponent,
  ],
  providers: [
    materialProviders,
  ],
)
class SearchPageComponent {
  final title = "Search";
  final courses = ['One', 'Two', 'Three'];
  @Input()
  SchedulingPageController schedulingPageController;
}

@Component(
  selector: 'course-card',
  templateUrl: 'course_card_component.html',
  directives: [
    coreDirectives,
    CourseCardComponent,
    MaterialExpansionPanel,
  ],
  styleUrls: ['course_card_component.css'],
  providers: [
    materialProviders,
  ],
)
class CourseCardComponent {
  @Input()
  Course course;
  final numbers = List(5);
}
