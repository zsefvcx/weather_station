import 'package:weather_widget/core/error/failure.dart';

mixin UseCase<T> {
  Future<(Failure?, T?)> call();
}
