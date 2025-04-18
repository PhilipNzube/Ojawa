import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/auth_button.dart';
import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_password_field.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/auth_title.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllers/sign_in_controller.dart';
import '../../controllers/sign_up_controller.dart';
import '../verify_email/verify_email.dart';
import 'widgets/bottom_sheets/role_sheet.dart';

class SignInPage extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  const SignInPage(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final signUpController = Provider.of<SignUpController>(context);
    final signInController = Provider.of<SignInController>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child:
                  // SizedBox(
                  //   height: orientation == Orientation.portrait
                  //       ? MediaQuery.of(context).size.height
                  //       : MediaQuery.of(context).size.height * 1.7,
                  //   child:
                  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(MediaQuery.of(context).size.height * 0.1,
                      useMediaQuery: false),
                  const AuthTitle(
                    title: 'Sign In',
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.03,
                      useMediaQuery: false),
                  Center(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.05,
                      useMediaQuery: false),
                  const AuthLabel(title: 'Username'),
                  const Gap(5),
                  CustomTextField(
                    controller: signInController.userNameController,
                    focusNode: signInController.userNameFocusNode,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const AuthLabel(title: 'Password'),
                  const Gap(5),
                  AuthPasswordField(
                    controller: signInController.passwordController,
                    focusNode: signInController.passwordFocusNode,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: AuthLabel(title: 'Role'),
                  ),
                  const Gap(5),
                  CustomTextField(
                    controller: signInController.roleController,
                    focusNode: signInController.roleFocusNode,
                    label: 'Select Role',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        showRoleSelection(
                            context, signInController.setSelectedRole);
                      },
                    ),
                    readOnly: true,
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            activeColor: const Color(0xFF008000),
                            checkColor: Colors.white,
                            value: signInController.rememberMe,
                            onChanged: (bool? value) {
                              signInController.setRemberMe(value!);
                            },
                          ),
                          Text(
                            "Remember me",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ForgotPassword(
                            //         key: UniqueKey(),
                            //         onToggleDarkMode: widget.onToggleDarkMode,
                            //         isDarkMode: widget.isDarkMode),
                            //   ),
                            // );
                          },
                          child: const Text(
                            'Forgot password?',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(MediaQuery.of(context).size.height * 0.05,
                      useMediaQuery: false),
                  AuthButton(
                    onPressed: () {
                      if (signInController.isLoading == false) {
                        signInController.submitForm(context,
                            widget.onToggleDarkMode, widget.isDarkMode);
                      }
                    },
                    isLoading: signInController.isLoading,
                    label: 'Next',
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // const Center(
                  //   child: Text(
                  //     '- Or -',
                  //     style: TextStyle(
                  //       fontFamily: 'Poppins',
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         'images/flat-color-icons_google.png',
                  //       ),
                  //       SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.05),
                  //       Image.asset(
                  //         'images/logos_facebook.png',
                  //       ),
                  //       SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.05),
                  //       Image.asset(
                  //         'images/bi_apple.png',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      GestureDetector(
                        onTap: () {
                          signUpController.resetSelectedRole();
                          signInController.setIsLoading(false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyEmail(
                                  key: UniqueKey(),
                                  onToggleDarkMode: widget.onToggleDarkMode,
                                  isDarkMode: widget.isDarkMode),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //),
            ),
          ),
        );
      },
    );
  }
}
