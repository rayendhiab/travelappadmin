import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Auth/dashboard_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/utils/app_focus_helper.dart';
import 'package:travel_app_admin/widgets/public_master_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  var _isFormLoading = false;

  Future<void> _doLogin(BuildContext ctx) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();

      setState(() => _isFormLoading = true);

      final res = await Provider.of<DataProvider>(context, listen: false)
          .login(_formData.username, _formData.password);

      if (!res) {
        _onLoginError(ctx, "Invalid username or password");
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DashboardScreen(),
          ),
        );
      }

      setState(() => _isFormLoading = false);
    }
  }

  void _onLoginError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      desc: message,
      width: 460,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return PublicMasterLayout(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: 16 * 5.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        height: 80.0,
                      ),
                    ),
                    Text(
                      "Travel App Admin",
                      style: themeData.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16 * 2.0),
                      child: Text(
                        "Admin Portal Login",
                        style: themeData.textTheme.titleMedium,
                      ),
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16 * 1.5),
                            child: FormBuilderTextField(
                              name: 'username',
                              initialValue: "admin@gmail.com",
                              decoration: const InputDecoration(
                                labelText: 'username',
                                hintText: 'username',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.username = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16 * 2.0),
                            child: FormBuilderTextField(
                              name: 'password',
                              initialValue: "azerty",
                              decoration: InputDecoration(
                                labelText: 'password',
                                hintText: 'password',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) =>
                                  (_formData.password = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData
                                    .extension<AppButtonTheme>()!
                                    .primaryElevated,
                                onPressed: (_isFormLoading
                                    ? null
                                    : () => _doLogin(context)),
                                child: const Text("Login"),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 40.0,
                          //   width: double.infinity,
                          //   child: TextButton(
                          //     style: themeData
                          //         .extension<AppButtonTheme>()!
                          //         .secondaryText,
                          //     onPressed: () =>
                          //         GoRouter.of(context).go(RouteUri.register),
                          //     child: RichText(
                          //       text: TextSpan(
                          //         text: '${lang.dontHaveAnAccount} ',
                          //         style: TextStyle(
                          //           color: themeData.colorScheme.onSurface,
                          //         ),
                          //         children: [
                          //           TextSpan(
                          //             text: lang.registerNow,
                          //             style: TextStyle(
                          //               color: themeData
                          //                   .extension<AppColorScheme>()!
                          //                   .hyperlink,
                          //               decoration: TextDecoration.underline,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormData {
  String username = '';
  String password = '';
}
