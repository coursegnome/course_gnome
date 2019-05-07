import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/focus/focus.dart';
import 'package:angular_components/angular_components.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:angular_forms/angular_forms.dart';
import 'loader_component.dart';

@Component(
  selector: 'login',
  templateUrl: 'login_component.html',
  styleUrls: [
    'login_component.css',
  ],
  directives: [
    coreDirectives,
    formDirectives,
    LoaderComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    AutoFocusDirective,
    materialInputDirectives,
    MaterialDropdownSelectComponent
  ],
  providers: [
    materialProviders,
  ],
)
class LoginComponent implements OnInit {
  String white = "#FFFFFF";

  Future<BrowserOAuth2Flow> flow;
  bool googleLoading = false;
  bool signInLoading = false;

  static final values = ['George Washington University'];
  String selectedValue = values[0];

  @ViewChild('scrollable')
  Element scrollable;

  int scrollLeft = 0;

  String email;
  String password;

  @override
  void ngOnInit() {
    scrollTo(0);
    var id = ClientId(
        "545808437748-e8ovdtj537qhj87srb2mq43n5oih8rfb.apps.googleusercontent.com",
        "XWQo4nreXyWoxBOBMepEqy80");
    List<String> scopes = ['profile', 'email'];
    flow = createImplicitBrowserFlow(id, scopes);
  }

  void scrollTo(int position) async {
    signInLoading = false;
    googleLoading = false;
    int scrollAmount;
    switch (position) {
      case 0:
        scrollAmount = 15;
        break;
      case 1:
        scrollAmount = 245;
        break;
      case 2:
        scrollAmount = 570;
    }

    bool direction = scrollLeft < scrollAmount;

    while (scrollLeft != scrollAmount) {
      await Future.delayed(Duration(milliseconds: 5));
      if (direction) {
        scrollLeft = (scrollLeft + 13).clamp(15, scrollAmount);
      } else {
        print(scrollLeft);
        scrollLeft = (scrollLeft - 13).clamp(scrollAmount, 1000);
        print(scrollLeft);
      }
      scrollable.scrollTo(scrollLeft, 0);
    }
  }

  signInWithEmail() async {
    signInLoading = true;
    await Future.delayed(Duration(seconds: 2));
    signInLoading = false;
  }

  void signUpWithEmail() async {
    signInLoading = true;
    await Future.delayed(Duration(seconds: 2));
    signInLoading = false;
  }

  void signInWithGoogle() async {
    if (googleLoading) return;
    googleLoading = true;
// Initialize the browser oauth2 flow functionality.
    BrowserOAuth2Flow flowTwo = await flow;
    try {
      final AccessCredentials credentials =
          await flowTwo.obtainAccessCredentialsViaUserConsent();
      print(credentials.accessToken);
      print(credentials.idToken);
      flowTwo.close();
    } catch (e) {
      googleLoading = false;
    }
  }
}
