String minLabel(num minutes){
  if(minutes>60){
    return "${(minutes/60).round()}h";
  }else {
    return "$minutes min";
  }

}