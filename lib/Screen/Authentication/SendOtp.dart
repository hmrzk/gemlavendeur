import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:gemlavendeur/Repository/appSettingsRepository.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';
import '../../Provider/privacyProvider.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import '../TermFeed/policys.dart';
import 'VerifyOTP.dart';

class SendOtp extends StatefulWidget {
  final String? title;

  const SendOtp({Key? key, this.title}) : super(key: key);

  @override
  _SendOtpState createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, id, countrycode, mobileno;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyUser();
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) async {
          setState(() {
            isNetworkAvail = false;
          });
          await buttonController!.reverse();
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: fontColor),
        ),
        backgroundColor: lightWhite,
        elevation: 1.0,
      ),
    );
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  Future<void> getVerifyUser() async {
    var data = {
      Mobile: mobile!.replaceAll(' ', ''),
      'country_code': countrycode,
      "is_forgot_password":
          widget.title == getTranslated(context, "FORGOT_PASS_TITLE")!
              ? "1"
              : "0"
    };
    apiBaseHelper.postAPICall(verifyUserApi, data).then(
      (getdata) async {
        bool error = getdata["error"];

        String? msg = getdata["message"];
        await buttonController!.reverse();
        if (widget.title == getTranslated(context, "SEND_OTP_TITLE")!) {
          if (!error) {
            print("-------$msg");
            setSnackbar(msg!);

            setPrefrence(Mobile, mobile!);
            setPrefrence(COUNTRY_CODE, countrycode!);
            Future.delayed(const Duration(seconds: 1)).then(
              (_) {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => VerifyOtp(
                      mobileNumber: mobile!,
                      countryCode: countrycode,
                      title: getTranslated(context, "SEND_OTP_TITLE")!,
                    ),
                  ),
                );
              },
            );
          } else {
            setSnackbar(msg!);
          }
        }
        if (widget.title == getTranslated(context, "FORGOT_PASS_TITLE")!) {
          if (!error) {
            setSnackbar(msg!);
            setPrefrence(Mobile, mobile!);
            setPrefrence(COUNTRY_CODE, countrycode!);

            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => VerifyOtp(
                  mobileNumber: mobile!,
                  countryCode: countrycode,
                  title: getTranslated(context, "FORGOT_PASS_TITLE")!,
                ),
              ),
            );
          } else {
            setSnackbar(msg!);
          }
        }
      },
      onError: (error) async {
        await buttonController!.reverse();
      },
    );
  }

  verifyCodeTxt() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: Text(
        getTranslated(context, 'SEND_VERIFY_CODE_LBL')!,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: black,
              fontWeight: FontWeight.normal,
              fontFamily: 'ubuntu',
            ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 3,
      ),
    );
  }

  setCodeWithMono() {
    return Padding(
        padding: const EdgeInsets.only(top: 45),
        child: IntlPhoneField(
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: black, fontWeight: FontWeight.normal),
          controller: mobileController,
          decoration: InputDecoration(
            hintStyle: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: black, fontWeight: FontWeight.normal),
            hintText: getTranslated(context, 'MOBILEHINT_LBL'),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(circularBorderRadius7)),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            fillColor: lightWhite.withOpacity(0.4),
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          initialCountryCode:
              AppSettingsRepository.appSettings.defaultCountryCode,
          onTap: () {},
          onSaved: (phoneNumber) {
            setState(() {
              countrycode = phoneNumber!.countryCode.toString();
              mobile = phoneNumber.number;
            });

            print("phone number2222****${phoneNumber!.countryCode}");
          },
          onCountryChanged: (country) {
            setState(() {
              countrycode = country.dialCode;
            });
            print(
                "phone number111*****${country.name}****${country.code}*****${country.dialCode}");
          },
          onChanged: (phone) {
            /* setState(() {
              mobile = phone.number;
            });*/
            print(
                "phone number*****${phone.completeNumber}****${phone.countryCode}*****${phone.number}****");
          },
          showDropdownIcon: false,
          invalidNumberMessage: getTranslated(context, "VALID_MOB"),
          keyboardType: TextInputType.number,
          flagsButtonMargin: const EdgeInsets.only(left: 20, right: 20),
          pickerDialogStyle: PickerDialogStyle(
            padding: const EdgeInsets.only(left: 10, right: 10),
          ),
        ));
  }

  setContryCode() {
    return IntlPhoneField(
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: black, fontWeight: FontWeight.normal),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      dropdownIconPosition: IconPosition.trailing,
      showCountryFlag: true,
      pickerDialogStyle: PickerDialogStyle(),
      initialCountryCode: AppSettingsRepository.appSettings.defaultCountryCode,
      controller: mobileController,
      onTap: () {},
      onSaved: (phoneNumber) {
        print("phone number2222****${phoneNumber!.countryCode}");
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        alignLabelWithHint: true,
        fillColor: lightWhite,
        filled: true,
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        hintText: getTranslated(context, 'MOBILEHINT_LBL'),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (phone) {
        print(
            "phone***${phone.countryCode}****${phone.number}****${phone.completeNumber}***${phone.countryISOCode}");
        print(phone.completeNumber);
      },
      onCountryChanged: (country) {
        print('Country changed to: ${country.name}');
      },
    );
  }

  setMono() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: mobileController,
      style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(color: black, fontWeight: FontWeight.normal),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (val) => StringValidation.validateMob(val!, context),
      onSaved: (String? value) {
        mobile = value;
      },
      decoration: InputDecoration(
        hintText: getTranslated(context, 'MOBILEHINT_LBL'),
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: black, fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: primary),
          borderRadius: BorderRadius.circular(circularBorderRadius7),
        ),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightWhite,
          ),
        ),
      ),
    );
  }

  verifyBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: AppBtn(
          title: widget.title == getTranslated(context, "SEND_OTP_TITLE")
              ? getTranslated(context, "Send OTP")!
              : getTranslated(context, "GET_PASSWORD")!,
          btnAnim: buttonSqueezeanimation,
          btnCntrl: buttonController,
          onBtnSelected: () async {
            validateAndSubmit();
          },
        ),
      ),
    );
  }

  termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 3.0,
        left: 25.0,
        right: 25.0,
        top: 40.0,
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: '    ${getTranslated(context, "CONTINUE_AGREE_LBL")}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.normal,
                ),
            children: [
              TextSpan(
                text: "\n${getTranslated(context, 'TERMS_SERVICE_LBL')}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.normal),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<SystemProvider>(
                          create: (context) => SystemProvider(),
                          child: Policy(
                            title: getTranslated(context, "TERM_CONDITIONS")!,
                          ),
                        ),
                      ),
                    );
                  },
              ),
              TextSpan(
                text: "  ${getTranslated(context, 'AND_LBL')}  ",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: black, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                  text: getTranslated(context, "PRIVACYPOLICY"),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<SystemProvider>(
                            create: (context) => SystemProvider(),
                            child: Policy(
                              title: getTranslated(context, "PRIVACYPOLICY")!,
                            ),
                          ),
                        ),
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      key: _scaffoldKey,
      body: isNetworkAvail
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 23),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DesignConfiguration.backButton(context),
                        // getLogo(),
                        signUpTxt(),
                        verifyCodeTxt(),
                        setCodeWithMono(),
                        verifyBtn(),
                        // termAndPolicyTxt()
                      ],
                    ),
                  ),
                ),
              ),
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Widget verifyCodeTxt1() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          getTranslated(context, "SEND_VERIFY_CODE_LBL")!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: fontColor,
                fontWeight: FontWeight.normal,
              ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget signUpTxt() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 40.0,
      ),
      child: Text(
        widget.title == getTranslated(context, 'SEND_OTP_TITLE')
            ? getTranslated(context, 'SIGN_UP_LBL')!
            : getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: textFontSize23,
              fontFamily: 'ubuntu',
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}
