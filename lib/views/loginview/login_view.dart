import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/controllers/login_controller.dart';
import 'package:visiq/views/loginview/dropdown_button_formField_widget.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoaderOverlay(
        overlayColor: Colors.grey.withOpacity(0.1),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/BG Image.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 20,
                      right: 20,
                      bottom: 50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 50, left: 20),
                          child: Lottie.asset('assets/images/face.json'),
                        ),
                        Text(
                          !controller.showUsernamePasswordFields.value
                              ? "To start capturing attendance, please select your branch from the list below."
                              : 'Please contact the admin to obtain your organization’s root username and password. You can change your password later within the organizational admin panel',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        if (controller.showUsernamePasswordFields.value)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 30.0,
                                  right: 30,
                                ),
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: controller.userNameController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    labelText: 'Username *',
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 30.0,
                                  right: 30,
                                ),
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: controller.passwordController,
                                  cursorColor: Colors.white,
                                  obscureText:
                                      !controller.isPasswordVisible.value,
                                  decoration: InputDecoration(
                                    labelText: 'Password *',
                                    labelStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controller.isPasswordVisible.value =
                                            !controller.isPasswordVisible.value;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!controller.showUsernamePasswordFields.value)
                          DropdownButtonFormFieldWidget(
                            onChanged: (newValue) async {
                              print('i am hit always');
                              final branches = controller
                                  .organisationModel!
                                  .organisationDetails!
                                  .branches!
                                  .map((e) => e.branchName)
                                  .where((name) => name != null)
                                  .map((name) => name!)
                                  .toList();
                              await controller.prefs?.setBool(
                                'isAdminLoggedIn',
                                true,
                              );
                              await controller.prefs?.setStringList(
                                'branches',
                                branches,
                              );
                              controller.selectedBranchId = controller
                                  .organisationModel!
                                  .organisationDetails!
                                  .branches!
                                  .where(
                                    (branch) => branch.branchName == newValue,
                                  )
                                  .first;
                              await controller.prefs?.setString(
                                'selectedBranchId',
                                controller.selectedBranchId?.branchId ?? "",
                              );
                              await controller.prefs?.setString(
                                'selectedBranchName',
                                controller.selectedBranchId?.branchName ?? "",
                              );
                              await controller.prefs?.setString(
                                'orgId',
                                controller
                                        .organisationModel
                                        ?.organisationDetails
                                        ?.orgData
                                        ?.first
                                        .orgId ??
                                    "",
                              );
                              await controller.prefs?.setString(
                                'orgName',
                                controller
                                        .organisationModel
                                        ?.organisationDetails
                                        ?.orgData
                                        ?.first
                                        .orgName ??
                                    "",
                              );
                            },
                            branches: controller.organisationModel != null
                                ? controller
                                      .organisationModel
                                      ?.organisationDetails
                                      ?.branches
                                      ?.map((e) => e.branchName)
                                      .toList()
                                : [],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0, bottom: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(Get.context!).unfocus();
                              if (controller.showUsernamePasswordFields.value) {
                                context.loaderOverlay.show();
                                await controller.signInAPI();
                              } else {
                                //SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                //String? userRole = prefs.getString('userRole');
                                if (context.mounted) {
                                  if (controller.selectedBranchId != null) {
                                    print("hello i selected branch${controller.selectedBranchId?.branchId}");
                                    Get.offAllNamed(
                                      '/getStarted',
                                      arguments: controller.selectedBranchId,
                                    );
                                  } else {
                                    Get.showSnackbar(
                                      GetSnackBar(
                                        message:
                                            'Please select the branch and proceed',
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                83,
                                213,
                                227,
                                1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: SizedBox(
                              width: 200,
                              height: 40,
                              child: Center(
                                child: Text(
                                  controller.showUsernamePasswordFields.value
                                      ? 'Login'
                                      : 'Next',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/BG Image.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ],
        ),
      ),
    );
  }
}
