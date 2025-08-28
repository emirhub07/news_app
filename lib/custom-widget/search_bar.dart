import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable search bar that uses an externally-owned TextEditingController.
/// - Shows a clear (X) button only when text is present
/// - Calls [onSearch] when the text length is >= 3, and calls onSearch('') when cleared or < 3
/// - Closes keyboard on submit
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'Search headlines...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Icon(Icons.search, color: Colors.grey[600], size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                final q = value.trim();
                if (q.length >= 3) {
                  onSearch(q);
                } else {
                  // less than 3 -> treat as cleared/no search
                  onSearch('');
                }
              },
              onSubmitted: (value) {
                // close keyboard
                FocusScope.of(context).unfocus();
                final q = value.trim();
                if (q.length >= 3) {
                  onSearch(q);
                } else {
                  onSearch('');
                }
              },
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
          ),

          // show clear icon only when there is input
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return SizedBox(width: 12.w);
              }
              return IconButton(
                splashRadius: 20.r,
                icon: Icon(Icons.close, size: 20.sp, color: Colors.grey[700]),
                onPressed: () {
                  controller.clear();
                  onSearch(''); // show all data
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
