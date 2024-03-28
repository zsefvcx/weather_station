
///Расширение класа стринг на случай если придеться заниматься локализацией
extension StringHardcoded on String {
  @Deprecated("Don't forget to remove hardcoded strings")
  String get hrd => this;

  String get cleanString => (
      split('')..removeWhere((element) => element == ' ')
  ).join();

  String get cleanStringFirstLast {
    final data = split('');
    if (data.isNotEmpty){
      if(data[0] == ' ') data.removeAt(0);
    }
    if (data.isNotEmpty && data.length > 1){
      if(data[data.length-1] == ' ') data.removeAt(data.length-1);
    }
    return data.join();
  }
}
