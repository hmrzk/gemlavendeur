import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';

// ignore: must_be_immutable
class SimBtn extends StatelessWidget {
  final String? title;
  final VoidCallback? onBtnSelected;
  double? size;

  SimBtn({Key? key, this.title, this.onBtnSelected, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.width * size!;
    return _buildBtnAnimation(context);
  }

  Widget _buildBtnAnimation(BuildContext context) {
    return CupertinoButton(
      child: Container(
        width: size,
        height: 35,
        alignment: FractionalOffset.center,
        decoration: const BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(
            Radius.circular(circularBorderRadius10),
          ),
        ),
        child: Text(
          title!,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: white, fontWeight: FontWeight.normal),
        ),
      ),
      onPressed: () {
        onBtnSelected!();
      },
    );
  }
}

class AppBtn extends StatelessWidget {
  final String? title;
  final AnimationController? btnCntrl;
  final Animation? btnAnim;
  final VoidCallback? onBtnSelected;
  final bool? paddingRequired;
  final double? height;
  final double? width;
  final Color? color;
  final Color? textcolor;

  const AppBtn({
    Key? key,
    this.title,
    this.btnCntrl,
    this.btnAnim,
    this.color,
    this.textcolor,
    this.width,
    this.onBtnSelected,
    this.paddingRequired,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildBtnAnimation,
      animation: btnCntrl!,
    );
  }

  Widget _buildBtnAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingRequired == null ? 25 : 0,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          // width: btnAnim!.value,
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 45,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: color ?? primary,
            border: Border.all(color: textcolor ?? Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(
                circularBorderRadius7,
              ),
            ),
          ),
          child: btnAnim!.value > 75.0
              ? Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: textcolor ?? white,
                        fontWeight: FontWeight.bold,
                        // fontSize: 15
                      ),
                )
              : const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
        ),
        onPressed: () {
          onBtnSelected!();
        },
      ),
    );
  }
}
