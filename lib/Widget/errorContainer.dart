import 'package:flutter/cupertino.dart';
import 'package:gemlavendeur/Helper/Color.dart';
import 'package:gemlavendeur/Helper/Constant.dart';
import 'package:gemlavendeur/Widget/validation.dart';

class ErrorContainer extends StatelessWidget {
  final String errorMessage;
  final Function onTapRetry;
  const ErrorContainer(
      {Key? key, required this.onTapRetry, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          CupertinoButton(
              child: Text(
                getTranslated(context, tryAgainLabelKey) ?? tryAgainLabelKey,
                style: const TextStyle(color: primary),
              ),
              onPressed: () {
                onTapRetry.call();
              })
        ],
      ),
    );
  }
}
