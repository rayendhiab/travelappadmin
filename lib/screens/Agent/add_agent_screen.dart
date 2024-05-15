import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Agent/agents_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/utils/app_focus_helper.dart';
import 'package:travel_app_admin/widgets/card_elements.dart';
import 'package:travel_app_admin/widgets/portal_master_layout.dart';

class AddAgentScreen extends StatefulWidget {
  final String id;

  const AddAgentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  Future<bool>? _future;

  Future<bool> _getDataAsync(BuildContext context) async {
    if (widget.id.isNotEmpty) {
      final agent = Provider.of<DataProvider>(context, listen: false)
          .agents
          .firstWhere((element) => element.id == widget.id);
      //  await Future.delayed(const Duration(seconds: 1), () {
      _formData.id = widget.id;
      _formData.name = agent.nom;
      _formData.email = agent.email;
      _formData.date_de_naissance = agent.date_de_naissance;
      // });
    }

    return true;
  }

  void _doSubmit(BuildContext context) {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final dialog = AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        title: "Confirmer",
        width: 460.0,
        btnOkText: "Yes",
        btnOkOnPress: () async {
          await Provider.of<DataProvider>(context, listen: false).addAgent(
              _formData.name,
              _formData.email,
              _formData.password,
              _formData.date_de_naissance);
          final d = AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: "Submitted",
            width: 460.0,
            btnOkText: 'OK',
            btnOkOnPress: () {},
          );

          await d.show();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => AgentsScreen(),
            ),
          );
        },
        btnCancelText: "Annuler",
        btnCancelOnPress: () {},
      );

      dialog.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final pageTitle = 'Agent - ${widget.id.isEmpty ? "Ajouter" : "Detail"}';

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            pageTitle,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: pageTitle,
                  ),
                  CardBody(
                    child: FutureBuilder<bool>(
                      initialData: null,
                      future: (_future ??= _getDataAsync(context)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          if (snapshot.hasData && snapshot.data!) {
                            return _content(context);
                          }
                        } else if (snapshot.hasData && snapshot.data!) {
                          return _content(context);
                        }

                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  themeData.scaffoldBackgroundColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final themeData = Theme.of(context);

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Email',
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Email',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.email,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.email = value ?? ''),
            ),
          ),
          if (widget.id.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16 * 1.5),
              child: FormBuilderTextField(
                name: 'Password',
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                // initialValue: _formData.name,
                validator: FormBuilderValidators.required(),
                onSaved: (value) => (_formData.password = value ?? ''),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Nom',
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Nom',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.name,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.name = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'date de naissance',
              decoration: const InputDecoration(
                labelText: 'date de naissance',
                hintText: 'date de naissance',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.date_de_naissance,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.date_de_naissance = value ?? ''),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  style:
                      themeData.extension<AppButtonTheme>()!.secondaryElevated,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AgentsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16 * 0.5),
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          size:
                              (themeData.textTheme.labelLarge!.fontSize! + 4.0),
                        ),
                      ),
                      Text("Retourner"),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 40.0,
                child: ElevatedButton(
                  style: themeData.extension<AppButtonTheme>()!.successElevated,
                  onPressed: () => _doSubmit(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16 * 0.5),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size:
                              (themeData.textTheme.labelLarge!.fontSize! + 4.0),
                        ),
                      ),
                      Text("Enregister"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FormData {
  String id = '';
  String name = '';
 String date_de_naissance = '1990-05-14';
  String email = '';
  String password = '';
}
