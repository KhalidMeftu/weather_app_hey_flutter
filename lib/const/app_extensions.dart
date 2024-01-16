import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// extensions

extension SizedBoxExtension on num {
  SizedBox get sizeHeight {
    return SizedBox(height: h);
  }
}
extension StringExtension on String {
  String toLower(){
    return toLowerCase();
  }
}


extension StringFirstLaterToUpper on String{
  String capitalizeFirstLater(){
    if(isEmpty) {
      return this;
    }
    return this[0].toUpperCase()+substring(1);
  }
}
