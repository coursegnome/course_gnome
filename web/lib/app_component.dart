import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:core/core.dart';

import 'src/routes/routes.dart';
import 'src/utils/auth.dart';

@Component(
  selector: 'my-app',
  template: '',
  directives: [routerDirectives],
  exports: [Routes],
)
class AppComponent implements OnInit, OnDestroy {
  AuthBloc _authBloc;

  @override
  void ngOnInit() {
    final UserRepository userRepository = UserRepository(
      getStoredAuth: getStoredAuth,
      storeAuth: storeAuth,
    );
    final AuthRepository authRepository = AuthRepository(
      userRepository: userRepository,
    );
    _authBloc = AuthBloc(authRepository: authRepository);
    //_authBloc.dispatch(Init());
  }

  @override
  void ngOnDestroy() {
    _authBloc.dispose();
  }
}
