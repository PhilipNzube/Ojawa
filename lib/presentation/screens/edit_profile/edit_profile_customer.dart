import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/filter.dart';
import '../../controllers/edit_profile_controllers.dart';

class EditProfileCustomer extends StatefulWidget {
  const EditProfileCustomer({super.key});

  @override
  _EditProfileCustomerState createState() => _EditProfileCustomerState();
}

class _EditProfileCustomerState extends State<EditProfileCustomer> {
  @override
  Widget build(BuildContext context) {
    final editProfileController = Provider.of<EditProfileControllers>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Edit Profile',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              if (editProfileController.profileImage == null ||
                                  editProfileController.profileImage!
                                      .isEmpty) // Check if image path is null or empty
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width: (85 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (85 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: Image.asset('images/Profile.png',
                                        fit: BoxFit.cover),
                                  ),
                                )
                              else if (editProfileController.profileImage!
                                  .startsWith('http'))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width: (85 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (85 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: Image.network(
                                      editProfileController.profileImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons
                                            .error); // Show an error icon if image fails to load
                                      },
                                    ),
                                  ),
                                )
                              else
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(55),
                                  child: Container(
                                    width: (85 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (85 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey,
                                    child: Image.file(
                                        File(editProfileController
                                            .profileImage!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    editProfileController.selectImage();
                                  },
                                  child: Image.asset(
                                    height: 30,
                                    'images/profile_edit.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        // AuthTextField(
                        //   label: 'Name',
                        //   controller: editProfileController.nameController,
                        //   focusNode: editProfileController.nameFocusNode,
                        //   floatingLabelBehavior: FloatingLabelBehavior.auto,
                        // ),

                        AuthTextField(
                          label: 'Firstname',
                          controller: editProfileController.firstNameController,
                          focusNode: editProfileController.firstNameFocusNode,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),

                        AuthTextField(
                          label: 'Lastname',
                          controller: editProfileController.lastNameController,
                          focusNode: editProfileController.lastNameFocusNode,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        AuthTextField(
                          label: 'Email',
                          controller: editProfileController.emailController,
                          focusNode: editProfileController.emailFocusNode,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: IntlPhoneField(
                            controller: editProfileController.phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              counterText: '',
                            ),
                            initialCountryCode: 'NG',
                            // Set initial country code
                            onChanged: (phone) {
                              editProfileController.setPhoneNumber(phone
                                  .completeNumber); // Store the phone number
                            },
                            onCountryChanged: (country) {
                              print('Country changed to: ${country.name}');
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        AuthTextField(
                          label: 'Location',
                          controller: editProfileController.locationController,
                          focusNode: editProfileController.locationFocusNode,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AuthLabel(
                              title: 'Gender',
                              fontWeight: FontWeight.bold,
                              isPaddingActive: false,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Filter(
                                text: 'Male',
                                value: 1,
                                controllerMethod:
                                    editProfileController.setSelectedRadioValue,
                                controllerVariable:
                                    editProfileController.selectedRadioValue!,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              Filter(
                                text: 'Female',
                                value: 2,
                                controllerMethod:
                                    editProfileController.setSelectedRadioValue,
                                controllerVariable:
                                    editProfileController.selectedRadioValue!,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              Filter(
                                text: 'Other',
                                value: 3,
                                controllerMethod:
                                    editProfileController.setSelectedRadioValue,
                                controllerVariable:
                                    editProfileController.selectedRadioValue!,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                (28.0 / MediaQuery.of(context).size.height) *
                                    MediaQuery.of(context).size.height),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: (60 / MediaQuery.of(context).size.height) *
                                MediaQuery.of(context).size.height,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: ElevatedButton(
                              onPressed: () {
                                editProfileController.updateProfile();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.white;
                                    }
                                    return const Color(0xFF1D4ED8);
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0xFF1D4ED8);
                                    }
                                    return Colors.white;
                                  },
                                ),
                                elevation: WidgetStateProperty.all<double>(4.0),
                                shape: WidgetStateProperty.resolveWith<
                                    RoundedRectangleBorder>(
                                  (Set<WidgetState> states) {
                                    return const RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 3,
                                        color: Color(0xFF1D4ED8),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    );
                                  },
                                ),
                              ),
                              child: editProfileController.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
