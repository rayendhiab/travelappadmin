import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Event/events_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/utils/app_focus_helper.dart';
import 'package:travel_app_admin/widgets/card_elements.dart';
import 'package:travel_app_admin/widgets/portal_master_layout.dart';
import 'package:flutter/foundation.dart' as ff;

class AddEventScreen extends StatefulWidget {
  final String id;

  const AddEventScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  Future<bool>? _future;

  XFile? _image;

  Image? image;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        if (ff.kIsWeb) {
          image = Image.network(
            pickedFile.path,
            width: 300,
            height: 300,
          );
        } else {
          image = Image.file(
            File(pickedFile.path),
            width: 300,
            height: 300,
          );
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future<bool> _getDataAsync(BuildContext context) async {
    if (widget.id.isNotEmpty) {
      final event = Provider.of<DataProvider>(context, listen: false)
          .events
          .firstWhere((element) => element.id == widget.id);
      //  await Future.delayed(const Duration(seconds: 1), () {
      _formData.id = widget.id;
      _formData.name = event.name;
      _formData.numMax = event.numMax;
      _formData.prix = event.prix;
      _formData.address = event.address;
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
          await Provider.of<DataProvider>(context, listen: false).addEvent(
              _formData.name,
              _formData.numMax,
              _formData.address,
              _formData.prix,
              _image!);
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
              builder: (BuildContext context) => EventsScreen(),
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

    final pageTitle = 'Tache - ${widget.id.isEmpty ? "Ajouter" : "Detail"}';

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
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Num Max',
              decoration: const InputDecoration(
                labelText: 'Num Max',
                hintText: 'Num Max',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.numMax.toString(),
              validator: FormBuilderValidators.required(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              onSaved: (value) => (_formData.numMax = int.parse(value!)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Address',
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Address',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.address,
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.address = value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Prix',
              decoration: const InputDecoration(
                labelText: 'Prix',
                hintText: 'Prix',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: _formData.prix.toString(),
              validator: FormBuilderValidators.required(),
              onSaved: (value) => (_formData.prix = double.parse(value!)),
            ),
          ),
          if (image != null) image!,
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Choisir photo"),
              )),
          SizedBox(
            height: 20,
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
                        builder: (BuildContext context) => EventsScreen(),
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
  int numMax = 0;
  String address = '';
  double prix = 0;
}
