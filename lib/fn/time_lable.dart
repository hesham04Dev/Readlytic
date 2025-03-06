String minLabel(num minutes){
  if(minutes>60){
    return "${(minutes/60).toStringAsFixed(1)}h";
  }else {
    return "${minutes.toStringAsFixed(1)} min";
  }

}