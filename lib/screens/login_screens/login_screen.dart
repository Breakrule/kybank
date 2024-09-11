import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:kybank/provider/login_provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  bool hidePassword = true; // State to toggle password visibility
  String? errorMessage; // For inline error display
  bool isLoading = false; // Loading state for the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Allows the content to be scrollable
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150.h), // Add space at the top for better layout

              // Lottie animation at the top
              Lottie.asset(
                'assets/lottie/login.json', // Path to Lottie animation file
                height: 150.h, // Adjust the height using ScreenUtil
              ),
              SizedBox(
                  height: 20.h), // Spacing between Lottie animation and form

              // Login form
              FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode
                    .onUserInteraction, // Automatically show validation errors
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'username',
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3,
                            errorText: "Min 3 characters"),
                      ]),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(6,
                            errorText: "Min 6 characters"),
                      ]),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password logic here
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                  ],
                ),
              ),

              // Display inline error message
              if (errorMessage != null) ...[
                SizedBox(height: 10.h),
                Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              ],
              SizedBox(height: 20.h),

              // Login button - matches the width of the text fields
              SizedBox(
                width: double.infinity, // Full width button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState?.saveAndValidate() ??
                              false) {
                            final username =
                                formKey.currentState?.fields['username']?.value;
                            final password =
                                formKey.currentState?.fields['password']?.value;

                            setState(() {
                              isLoading = true;
                              errorMessage =
                                  null; // Clear error message on success
                            });

                            // Store the context locally before the async operation
                            final localContext = context;

                            try {
                              // Simulate async login process
                              bool success = await Provider.of<LoginProvider>(
                                      context,
                                      listen: false)
                                  .login(username, password);

                              setState(() {
                                isLoading = false; // Stop loading
                              });

                              if (success) {
                                // Safely use the stored context after async operation
                                localContext.mounted
                                    ? localContext.go('/home')
                                    : success; // Navigate to home screen on success
                              } else {
                                setState(() {
                                  errorMessage =
                                      'Invalid login credentials'; // Handle incorrect login
                                });
                              }
                            } catch (error) {
                              setState(() {
                                isLoading = false;
                                errorMessage = 'An error occurred during login';
                              });
                            }
                          } else {
                            setState(() {
                              errorMessage =
                                  'Please correct the errors above'; // Set error message
                            });
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white) // Show loading spinner
                      : Text('Login', style: TextStyle(fontSize: 18.sp)),
                ),
              ),

              SizedBox(height: 30.h),

              // Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google login button
                  GestureDetector(
                    onTap: () {
                      // Handle Google login here
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.asset(
                        'assets/icon/google.png', // Path to Google icon
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w), // Spacing between social icons

                  // Facebook login button
                  GestureDetector(
                    onTap: () {
                      // Handle Facebook login here
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.asset(
                        'assets/icon/facebook.png', // Path to Facebook icon
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
