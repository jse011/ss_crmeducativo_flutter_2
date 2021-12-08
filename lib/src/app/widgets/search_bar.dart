import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';


class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.controller,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Row(
          children: [
          Padding(padding: EdgeInsets.only(right: 6)),
            Expanded(
              child: CupertinoTextField(
                controller: controller,
                focusNode: focusNode,
                style: TextStyle(
                  fontSize: 14
                ),
                cursorColor: AppTheme.colorPrimary,
                decoration: null,
              ),
            ),
            controller.text.isNotEmpty?
            Padding(
              padding: EdgeInsets.only(right: 6),
              child:  GestureDetector(
                onTap: (){
                  controller.clear();
                  focusNode.unfocus();
                },
                child: Icon(
                  CupertinoIcons.clear_thick_circled,
                  color: AppTheme.colorPrimary,
                  size: 18,
                ),
              ),
            ):Padding(
              padding: EdgeInsets.only(right: 6),
              child:  Icon(
                CupertinoIcons.search,
                color: AppTheme.colorPrimary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}