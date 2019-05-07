import 'package:angular/angular.dart';

@Component(
  selector: 'loader',
  template: '<div class="spinner"></div>',
  styles: [
    '''
@keyframes spinner {
  to {transform: rotate(360deg);}
}
.spinner {
} 
.spinner:before {
  content: '';
  box-sizing: border-box;
  position: absolute;
  top: 50%;
  left: 50%;
  width: 20px;
  height: 20px;
  margin-top: -10px;
  margin-left: -10px;
  border-radius: 50%;
  border: 2px solid #ccc;
  border-top-color: #4d4d4d;
  animation: spinner .6s linear infinite;
}
''',
  ],
)
class LoaderComponent {}
