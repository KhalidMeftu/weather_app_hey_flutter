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
