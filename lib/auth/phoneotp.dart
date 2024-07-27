import 'dart:async';
import 'package:dinda_app/home%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PhoneOTPVerif extends StatefulWidget {
  final String phoneNumber;

  PhoneOTPVerif(this.phoneNumber);

  @override
  _PhoneOTPVerifState createState() => _PhoneOTPVerifState();
}

class _PhoneOTPVerifState extends State<PhoneOTPVerif> {
  late TextEditingController firstController;
  late TextEditingController secondController;
  late TextEditingController thirdController;
  late TextEditingController fourthController;

  late FocusNode firstFocusNode;
  late FocusNode secondFocusNode;
  late FocusNode thirdFocusNode;
  late FocusNode fourthFocusNode;

  late Timer _timer;
  int _start = 60;
  bool _timerEnded = false;

  @override
  void initState() {
    super.initState();
    firstController = TextEditingController();
    secondController = TextEditingController();
    thirdController = TextEditingController();
    fourthController = TextEditingController();

    firstFocusNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fourthFocusNode = FocusNode();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      firstFocusNode.requestFocus();
    });

    startTimer();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();

    firstFocusNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fourthFocusNode.dispose();

    _timer.cancel();

    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _timerEnded = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      return '';
    }
    String countryCode = phoneNumber.substring(0, 3);
    String maskedNumber = countryCode;
    for (int i = 3; i < phoneNumber.length; i++) {
      if (phoneNumber[i].trim().isNotEmpty) {
        maskedNumber += 'x';
      }
    }
    return maskedNumber;
  }

  void checkAndSubmitOTP() {
    if (firstController.text.isNotEmpty &&
        secondController.text.isNotEmpty &&
        thirdController.text.isNotEmpty &&
        fourthController.text.isNotEmpty) {
      Get.snackbar("Login Success", "Welcome back!",
          backgroundColor: Colors.green[400],
          icon: Icon(Icons.check_circle_outline, color: Colors.black));
      Future.delayed(Duration(seconds: 2), () {
        Get.to(() => HomePageTest());
      });
    } else {
      print("OTP code must be 4 digits");
    }
  }

  Widget buildOTPField(TextEditingController controller, FocusNode focusNode,
      Function(String) onChanged,
      {FocusNode? nextFocusNode}) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: (value) {
          onChanged(value);
          if (value.length == 1 && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          }
        },
        style: TextStyle(fontSize: 35, color: Colors.grey),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          hintStyle: TextStyle(
              color: Colors.grey, fontSize: 40, fontWeight: FontWeight.w300),
          hintText: "|",
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          focusColor: Colors.grey,
        ),
        keyboardType: TextInputType.none,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

  Widget buildTimer() {
    return _timerEnded
        ? InkWell(
            onTap: () {
              setState(() {
                _timerEnded = false;
                _start = 60;
              });
              startTimer();
            },
            child: Text(
              "Resend",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  decoration: TextDecoration.underline),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Kirim ulang kode dalam ",
                  style: TextStyle(
                      color: Color.fromARGB(228, 88, 88, 88), fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Text(
                formatTimer(_start),
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    String maskedPhoneNumber = maskPhoneNumber(widget.phoneNumber);

    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/disney.png", fit: BoxFit.contain, height: 60),
          ],
        ),
        backgroundColor: Color.fromRGBO(21, 24, 31, 0.92),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Masukkan kode yang dikirim\nke $maskedPhoneNumber',
              style: TextStyle(fontSize: 28, color: Colors.grey[300]),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOTPField(firstController, firstFocusNode, (value) {
                  if (value.isEmpty) {
                    secondFocusNode.requestFocus();
                  }
                }, nextFocusNode: secondFocusNode),
                buildOTPField(secondController, secondFocusNode, (value) {
                  if (value.length == 1) {
                    thirdFocusNode.requestFocus();
                  } else {
                    firstFocusNode.requestFocus();
                  }
                }, nextFocusNode: thirdFocusNode),
                buildOTPField(thirdController, thirdFocusNode, (value) {
                  if (value.length == 1) {
                    fourthFocusNode.requestFocus();
                  } else {
                    secondFocusNode.requestFocus();
                  }
                }, nextFocusNode: fourthFocusNode),
                buildOTPField(fourthController, fourthFocusNode, (value) {
                  if (value.length == 1) {
                    checkAndSubmitOTP();
                  } else {
                    thirdFocusNode.requestFocus();
                  }
                }),
              ],
            ),
            SizedBox(height: 50),
            buildTimer(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("SMS button tapped");
                  },
                  icon: Icon(Icons.sms_outlined),
                  label: Text("SMS"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text("|",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    print("Call button tapped");
                  },
                  icon: Icon(Icons.call_outlined),
                  label: Text("Panggilan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 25),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mengalami masalah saat masuk?",
                      style: TextStyle(
                        color: Color.fromARGB(228, 88, 88, 88),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Dapatkan bantuan clicked");
                      },
                      child: Text(
                        "Dapatkan bantuan",
                        style: TextStyle(
                          color: Color.fromRGBO(42, 98, 183, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.5,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  List<String> keySymbols = [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '<-',
                    '0',
                    'Ok',
                  ];

                  void onKeyboardTap(String symbol) {
                    if (symbol == '<-') {
                      if (fourthFocusNode.hasFocus) {
                        fourthController.clear();
                        thirdFocusNode.requestFocus();
                      } else if (thirdFocusNode.hasFocus) {
                        thirdController.clear();
                        secondFocusNode.requestFocus();
                      } else if (secondFocusNode.hasFocus) {
                        secondController.clear();
                        firstFocusNode.requestFocus();
                      } else if (firstFocusNode.hasFocus) {
                        firstController.clear();
                      }
                    } else if (symbol == 'Ok') {
                      checkAndSubmitOTP();
                    } else {
                      if (firstFocusNode.hasFocus) {
                        firstController.text = symbol;
                        secondFocusNode.requestFocus();
                      } else if (secondFocusNode.hasFocus) {
                        secondController.text = symbol;
                        thirdFocusNode.requestFocus();
                      } else if (thirdFocusNode.hasFocus) {
                        thirdController.text = symbol;
                        fourthFocusNode.requestFocus();
                      } else if (fourthFocusNode.hasFocus) {
                        fourthController.text = symbol;
                      }
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15.0),
                      child: InkWell(
                        onTap: () => onKeyboardTap(keySymbols[index]),
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              keySymbols[index],
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
