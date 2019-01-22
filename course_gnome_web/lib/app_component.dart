import 'package:angular/angular.dart';
import 'src/search_page/search_page_components.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [coreDirectives, SearchPageComponent],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
