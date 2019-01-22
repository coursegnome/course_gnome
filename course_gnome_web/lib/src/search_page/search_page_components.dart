import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_button/material_button.dart';

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
}

@Component(
  selector: 'course-card',
  templateUrl: 'course_card_component.html',
  directives: [
    CourseCardComponent,
    MaterialExpansionPanel,
  ],
  styleUrls: ['course_card_component.css'],
  providers: [
    materialProviders,
  ],
)
class CourseCardComponent {
  var name = 'Angular';
}
