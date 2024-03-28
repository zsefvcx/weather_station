enum TypeData{
  internal,
  external,
  another;

  @override
  String toString() {
    switch (index) {
      case 0:
        return 'internal';
      case 1:
        return 'external';
      case 3:
        return 'another';
      default:
        return name;
    }
  }
}
