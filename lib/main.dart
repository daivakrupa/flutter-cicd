import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/SDK/FaceRecognisationSDK/face_camera.dart';
import 'package:visiq/controllers/splash_controller.dart';
import 'package:visiq/views/bookvisitform/book_visit_form.dart';
import 'package:visiq/views/entry_form_view/entry_form_view.dart';
import 'package:visiq/views/get_started_view/get_started_view.dart';
import 'package:visiq/views/loginview/login_view.dart';
import 'package:visiq/views/populateuserdetailsview/populate_user_details.dart';
import 'package:visiq/views/privelige_entryform/prevallaged_entryform.dart';
import 'package:visiq/views/splash_view/splash_view.dart';
import 'package:visiq/views/terms_and_conditions_view/data_center_access_policies_view.dart';
import 'package:visiq/views/terms_and_conditions_view/terms_and_conditions_view.dart';
import 'package:visiq/views/vehicle_verification/vehicle_verification.dart';
import 'package:visiq/views/viewvisitors/visitor_card_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VisiQ',
      home: HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginWidget()),
        GetPage(name: '/getStarted', page: () => GetStartedWidget()),
        GetPage(name: '/bookVisitForm', page: () => BookAVisitForm()),
        GetPage(name: '/viewvisitors', page: () => VisitorCardList()),
        GetPage(name: '/privelegeEntryform', page: () => PrevallagedEntryForm()),
        GetPage(name: '/vehicleverificationscreen', page: () => VehicleVerificationScreen()),
        GetPage(name: '/termsandconditions', page: () => TermsAndConditionsScreen()),
        GetPage(name: '/populateuserdetails', page: () => PopulateUserDetails()),
        GetPage(name: '/datacenterpolicies', page: () => DataCenterAccessPolicies()),
        GetPage(name: '/entryform', page: () => EntryFormWidget()),

      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (controller.isAdminLoggedIn.value == null)
          ? null // Remove AppBar when SplashScreen is displayed
          : AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              centerTitle: true,
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    if (controller.isAdminLoggedIn.value != null)
                      if (controller.isAdminLoggedIn.value == true) ...[
                        const TextSpan(
                          text: 'Visi',
                          style: TextStyle(color: Colors.black),
                        ),
                        const TextSpan(
                          text: 'Q',
                          style: TextStyle(
                            color: Color.fromRGBO(120, 210, 224, 1),
                          ),
                        ),
                      ] else ...[
                        const TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.black,
                          ), // Adjust color if needed
                        ),
                      ]
                    else ...[
                      const TextSpan(
                        text: 'Visi',
                        style: TextStyle(color: Colors.black),
                      ),
                      const TextSpan(
                        text: 'Q',
                        style: TextStyle(
                          color: Color.fromRGBO(120, 210, 224, 1),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
      body: SplashScreen(),
    );
  }
}
