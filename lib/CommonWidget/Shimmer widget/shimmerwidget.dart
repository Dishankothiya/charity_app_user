import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget CommonShimmer(
  BuildContext context,
  Widget widget,
) {
  return Shimmer.fromColors(
    child: widget,
    baseColor: Colors.grey[100]!,
    highlightColor: Colors.grey[300]!,
  );
}
