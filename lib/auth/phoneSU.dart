import 'package:dinda_app/auth/phoneotp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneSignupPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'ID');
  final Function(BuildContext, String, {bool isSuccess}) showSnackBar;

  PhoneSignupPage({required this.showSnackBar});

  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/disney.png",
              fit: BoxFit.contain,
              height: 60,
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(21, 24, 31, 0.92),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100.0, right: 30.0, left: 30.0, bottom: 30),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Masuk atau daftar untuk melanjutkan',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 25.0, color: Colors.grey[400]),
                    ),
                    SizedBox(height: 70.0),
                    Form(
                      key: formKey,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Stack(
                                children: [
                                  // Main content of the page
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left: 10,
                                        bottom: 20,
                                        right: 10),
                                    child: Column(
                                      children: [
                                        InternationalPhoneNumberInput(
                                          textStyle: TextStyle(
                                              color: Colors.grey, fontSize: 20),
                                          onInputChanged: (PhoneNumber number) {
                                            print(number.phoneNumber);
                                          },
                                          onInputValidated: (bool value) {
                                            print(value);
                                          },
                                          selectorConfig: SelectorConfig(
                                              selectorType:
                                                  PhoneInputSelectorType
                                                      .BOTTOM_SHEET,
                                              useBottomSheetSafeArea: true,
                                              leadingPadding: 0),
                                          inputDecoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            labelText: 'Phone Number',
                                            focusedBorder: OutlineInputBorder(
                                              // Customize the focused border
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 1),
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                          ),
                                          ignoreBlank: false,
                                          autoValidateMode:
                                              AutovalidateMode.disabled,
                                          selectorTextStyle: TextStyle(
                                              color: Colors.grey, fontSize: 18),
                                          initialValue: number,
                                          textFieldController: controller,
                                          formatInput: true,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true, decimal: true),
                                          onSaved: (PhoneNumber number) {
                                            print('On Saved: $number');
                                            phoneNumber = number.phoneNumber!;
                                          },
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                  // Positioned box
                                  Positioned(
                                    top: 19,
                                    right: 222,
                                    child: IgnorePointer(
                                      // Wrap with IgnorePointer
                                      child: Container(
                                        width: 105,
                                        height: 63,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) //button login
                  ],
                ),
              ),
              Positioned(
                bottom: 40.0,
                right: 16.0,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 0),
                      child: Text(
                        'Mengalami masalah saat masuk?',
                        style: TextStyle(
                            color: Color.fromRGBO(95, 94, 94, 1), fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add functionality here
                        print("MASUK PAK EKo123");
                      },
                      child: Text(
                        'Dapatkan bantuan',
                        style: TextStyle(
                            color: Color.fromRGBO(42, 98, 183, 1),
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50.0,
                right: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    bool isValid = formKey.currentState?.validate() ??
                        false; // Perform validation
                    if (isValid) {
                      formKey.currentState
                          ?.save(); // Save the form data if valid
                      // Show success snackbar
                      showSnackBar(context, 'Phone number is valid.',
                          isSuccess: true);

                      // Delay navigation for snackbar visibility
                      Future.delayed(Duration(seconds: 2), () {
                        // Navigate to another page after delay
                        Get.to(() => PhoneOTPVerif(
                            phoneNumber)); // Replace NextPage with your destination page
                      });
                    } else {
                      // Show error snackbar
                      showSnackBar(
                          context, 'Please enter a valid phone number.',
                          isSuccess: false);
                    }
                  },
                  tooltip: 'Increment',
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0859E0),
                          Color(0xFF053A92),
                          Color(0xFF04307A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 60,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
  }
}
