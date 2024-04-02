
///Расширение класа стринг на случай если придеться заниматься локализацией
extension StringHardcoded on String {
  @Deprecated("Don't forget to remove hardcoded strings")
  String get hrd => this;
}
