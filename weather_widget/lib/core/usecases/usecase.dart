import 'package:weather_widget/core/error/failure.dart';

mixin UseCase<T> {
  Stream<(Failure?, T?)> call();
}
