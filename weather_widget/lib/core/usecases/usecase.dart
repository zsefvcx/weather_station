
import 'package:weather_widget/core/core.dart';

mixin UseCase<T> {
  Stream<TypeOfResponse<T>> call();
}
