import 'package:weather_widget/core/error/failure.dart';

mixin UseCase<T, TD> {
  Stream<({Failure? failure, TD type, T? data})> call();
}
