enum TypeDataRcv{
  multi,
  single,
  type2,
  type3;

  @override
  String toString(){
    switch (index){
      case 0:
        return 'multicast';
      case 1:
        return 'singlecast';
      case 2:
        return 'type2Broadcast';
      case 3:
        return 'type2Broadcast2';
      default:
        return name;
    }
  }
}