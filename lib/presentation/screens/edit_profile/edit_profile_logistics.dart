import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../core/widgets/auth_label.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../controllers/edit_profile_controllers.dart';
import '../../../core/widgets/custom_button.dart';

class EditProfileLogistics extends StatefulWidget {
  const EditProfileLogistics({super.key});

  @override
  _EditProfileLogisticsState createState() => _EditProfileLogisticsState();
}

class _EditProfileLogisticsState extends State<EditProfileLogistics> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final editProfileController = Provider.of<EditProfileControllers>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
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
                                        return const Icon(Icons.error);
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Your Name'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.nameController,
                          focusNode: editProfileController.nameFocusNode,
                          label: 'Full name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Mobile Number'),
                        ),
                        const Gap(5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode ? Colors.grey[900] : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(5), // Smoother corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(
                                      0, 2), // Position shadow for depth
                                ),
                              ],
                            ),
                            child: IntlPhoneField(
                              controller: editProfileController.phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
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
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Email'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.emailController,
                          focusNode: editProfileController.emailFocusNode,
                          label: 'Your Email Address',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Address'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.addressController,
                          focusNode: editProfileController.addressFocusNode,
                          label: 'Your Preferred Address',
                          maxLines: 4,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Store Name'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.storeNameController,
                          focusNode: editProfileController.storeNameFocusNode,
                          label: 'Your Preferred Store Name',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Store URL'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.storeUrlController,
                          focusNode: editProfileController.storeUrlFocusNode,
                          label: 'e.g. www.mystore@example.com',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Description'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller:
                              editProfileController.descriptionController,
                          focusNode: editProfileController.descriptionFocusNode,
                          label: 'Your Preferred Store Description',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Latitude'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.latitudeController,
                          focusNode: editProfileController.latitudeFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'Longitude'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.longitudeController,
                          focusNode: editProfileController.longitudeFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'TAX Name'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.taxNameController,
                          focusNode: editProfileController.taxNameFocusNode,
                          label: '',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AuthLabel(title: 'TAX Number'),
                        ),
                        const Gap(5),
                        CustomTextField(
                          controller: editProfileController.taxNumberController,
                          focusNode: editProfileController.taxNumberFocusNode,
                          label: '',
                        ),
                        const Gap(50),
                        CustomButton(
                          width: double.infinity,
                          isLoading: editProfileController.isLoading,
                          text: 'Change Password',
                          bgColor: Colors.black,
                          borderColor: Colors.black,
                        ),
                        const Gap(50),
                        CustomButton(
                          width: double.infinity,
                          isLoading: editProfileController.isLoading2,
                          text: 'Update Profile',
                        ),
                        const Gap(10),
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
