import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dinda_app/auth/login.dart';
import 'package:dinda_app/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: 'assets/env/.env_production');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  void showSnackBar(BuildContext context, String message,
      {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: isSuccess ? 'Success!' : 'Error!',
          message: message,
          contentType: isSuccess ? ContentType.success : ContentType.failure,
        ),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  bool _showSplashScreen = true; // Track splash screen visibility
  @override
  void initState() {
    super.initState();
    // Delay navigation until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _showSplashScreen = false; // Hide splash screen
        });
        Get.off(() => Agree()); // Use Get.off for navigation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          _showSplashScreen ? SplashScreen() : Agree(), // Conditional rendering
    );
  }
}

class Agree extends StatelessWidget {
  final CheckboxController controller = Get.put(CheckboxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/disney.png",
              fit: BoxFit.contain,
              height: 60,
            )
          ],
        ),
        backgroundColor: Color.fromRGBO(21, 24, 31, 0.92),
      ),
      //show hello world in body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(29, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                """Agreement
         
          Untuk informasi lebih lanjut mengenai paket, fitur, dan harga, silakan lihat Pusat Bantuan kami. Ketersediaan fitur tergantung pada pilihan paket langganan Anda. Kualitas video dan audio tergantung pada layanan internet, kemampuan perangkat/browser, konten, dan jenis langganan. Konten di Disney+ Hotstar tergantung ketersediaan. Diperlukan langganan. Biaya bank tambahan mungkin berlaku. Harga sudah termasuk PPN Indonesia. Hemat lebih dari 40%* untuk Paket Tahunan. *Penghematan dibandingkan dengan 12 bulan harga langganan bulanan. 
          
          Jika Anda berlangganan Disney+ Hotstar, kami akan membebankan biaya bulanan atau tahunan berulang berdasarkan paket yang Anda pilih ke metode pembayaran yang tersimpan. Pastikan metode pembayaran Anda mutakhir dan memiliki saldo yang cukup untuk melanjutkan streaming tanpa gangguan. Jika terjadi kegagalan dalam upaya menagih ke metode pembayaran Anda (misalnya jika metode pembayaran Anda telah kedaluwarsa), kami berhak untuk mencoba menagih kembali metode pembayaran Anda.
          
          Pembatalan harus diterima setidaknya 24/48 jam, tergantung pada metode penagihan yang Anda pilih, sebelum tanggal perpanjangan paket langganan Anda saat ini.
          
          Pengembalian uang atau kredit tidak akan diberikan untuk bulan atau tahun yang terlewati (atau yang setara). Harga di seluruh platform Disney+ Hotstar dapat bervariasi karena persyaratan pihak ketiga.""",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
//              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: controller.isChecked.value,
                          onChanged: (newValue) {
                            controller.toggleCheckbox();
                          },
                        ),
                        Text(
                          "Saya setuju",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    )),
              ),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      colors: [
                        Color(0xFF0859E0),
                        Color(0xFF053A92),
                        Color(0xFF04307A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  onPressed: () {
                    if (controller.isChecked.value) {
                      Get.to(() => LoginPage());
                    } else {
                      Get.snackbar("Peringatan",
                          "Anda harus setuju dengan syarat dan ketentuan");
                    }
                  },
                  child: Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckboxController extends GetxController {
  var isChecked = false.obs;
  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }
}
