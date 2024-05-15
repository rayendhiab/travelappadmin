import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/models/reservation.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Reservation/reservation_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/widgets/card_elements.dart';
import 'package:travel_app_admin/widgets/portal_master_layout.dart';

class ReservationDetailScreen extends StatefulWidget {
  final String reservationId;

  const ReservationDetailScreen({
    Key? key,
    required this.reservationId,
  }) : super(key: key);

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  void _doSubmit(BuildContext context) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      title: "Confirm Reservation payment",
      width: 460.0,
      btnOkText: "Yes",
      btnOkOnPress: () {
        final d = AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Reservation Confirmed",
          width: 460.0,
          btnOkText: 'OK',
          btnOkOnPress: () {
            Provider.of<DataProvider>(context, listen: false)
                .confirmReservation(reservation.id);
            reservation.validated = true;
            setState(() {});
          },
        );

        d.show();
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {},
    );

    dialog.show();
  }

  late Reservation reservation;
  late String clientName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservation = Provider.of<DataProvider>(context, listen: false)
        .reservations
        .firstWhere((element) => element.id == widget.reservationId);
    clientName = Provider.of<DataProvider>(context, listen: false)
        .clients
        .firstWhere((element) => element.id == reservation.userId)
        .nom;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final pageTitle = 'Detail Reservation';

    return PortalMasterLayout(
      // selectedMenuUri: RouteUri.crud,
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
                    child: _content(context),
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
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Id Reservation',
              decoration: const InputDecoration(
                labelText: 'Id Reservation',
                hintText: 'Id Reservation',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.id,
              readOnly: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Nom Client',
              decoration: const InputDecoration(
                labelText: 'Nom Client',
                hintText: 'Nom Client',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: clientName,
              readOnly: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 1.5),
            child: FormBuilderTextField(
              name: 'Date Reservation',
              decoration: const InputDecoration(
                labelText: 'Date Reservation',
                hintText: 'Date Reservation',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.dateReservation,
              readOnly: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Price',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Price',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.prix.toStringAsFixed(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Date Debut',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date Debut',
                hintText: 'Date Debut',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.dateDep,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Date Fin',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date Fin',
                hintText: 'Date Fin',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.dateDep,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Person',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Person',
                hintText: 'Person',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue: reservation.numPerson.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16 * 2.0),
            child: FormBuilderTextField(
              name: 'Status',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Status',
                hintText: 'Status',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              initialValue:
                  reservation.validated ? "Validated" : "Not validated",
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
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ReservationsScreen(),
                    ),
                  ),
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
                      Text("Back"),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (!reservation.validated)
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    style:
                        themeData.extension<AppButtonTheme>()!.successElevated,
                    onPressed: () => _doSubmit(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16 * 0.5),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: (themeData.textTheme.labelLarge!.fontSize! +
                                4.0),
                          ),
                        ),
                        Text("Confirm"),
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
