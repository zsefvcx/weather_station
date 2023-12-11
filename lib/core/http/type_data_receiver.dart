enum TypeDataReceiver{
  type0,
  type1,
  type2,
  type3;

  @override
  String toString(){
    switch (index){
      case 0:
        return 'type0None';
      case 1:
        return 'type1Sing';
      case 2:
        return 'type2Broadcast';
      case 3:
        return 'type2Broadcast2';
      default:
        return name;
    }
  }
}
