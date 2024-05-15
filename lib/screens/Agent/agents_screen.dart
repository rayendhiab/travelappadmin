import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/models/user.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Agent/add_agent_screen.dart';
import 'package:travel_app_admin/screens/Reservation/detail_reservation_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_data_table_theme.dart';
import 'package:travel_app_admin/widgets/card_elements.dart';
import 'package:travel_app_admin/widgets/portal_master_layout.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({Key? key}) : super(key: key);

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  final _scrollController = ScrollController();

  late DataSource _dataSource;

  List<User> agents = [];

  @override
  void initState() {
    super.initState();
    agents = Provider.of<DataProvider>(context, listen: false).agents;

    final data = List.generate(agents.length, (index) {
      return {
        'id': agents[index].id,
        'nom': agents[index].nom,
        'email': agents[index].email,
        'date_de_naissance': agents[index].date_de_naissance,
      };
    });

    _dataSource = DataSource(
      onDetailButtonPressed: (data) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ReservationDetailScreen(
              reservationId: data['id'],
            ),
          ),
        );
      },
      onDeleteButtonPressed: (data) {},
      reservations: data,
    );
    Provider.of<DataProvider>(context, listen: false).getReservations();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final appDataTableTheme = themeData.extension<AppDataTableTheme>()!;
    agents = Provider.of<DataProvider>(context).agents;
    print(agents.length);
    var data = List.generate(agents.length, (index) {
      return {
        'id': agents[index].id,
        'nom': agents[index].nom,
        'email': agents[index].email,
      };
    });

    _dataSource = DataSource(
      onDetailButtonPressed: (data) {},
      onDeleteButtonPressed: (data) {},
      reservations: data,
    );

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Agents',
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'List agent',
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16 * 2.0),
                          child: FormBuilder(
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 16,
                                runSpacing: 16,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 40.0,
                                        child: ElevatedButton(
                                          style: themeData
                                              .extension<AppButtonTheme>()!
                                              .successElevated,
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        AddAgentScreen(
                                                  id: '',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16 * 0.5),
                                                child: Icon(
                                                  Icons.add,
                                                  size: (themeData
                                                          .textTheme
                                                          .labelLarge!
                                                          .fontSize! +
                                                      4.0),
                                                ),
                                              ),
                                              Text("New"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double dataTableWidth =
                                  max(768.0, constraints.maxWidth);

                              return Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  child: SizedBox(
                                    width: dataTableWidth,
                                    child: Theme(
                                      data: themeData.copyWith(
                                        cardTheme: appDataTableTheme.cardTheme,
                                        dataTableTheme: appDataTableTheme
                                            .dataTableThemeData,
                                      ),
                                      child: PaginatedDataTable(
                                        source: _dataSource,
                                        rowsPerPage: 20,
                                        showCheckboxColumn: false,
                                        showFirstLastButtons: true,
                                        columns: const [
                                          DataColumn(
                                            label: Text('Id'),
                                          ),
                                          DataColumn(label: Text('Nom')),
                                          DataColumn(
                                            label: Text('Email'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
}

class DataSource extends DataTableSource {
  final void Function(Map<String, dynamic> data) onDetailButtonPressed;
  final void Function(Map<String, dynamic> data) onDeleteButtonPressed;
  //final List<Reservation> reservations;
  final reservations;

  DataSource({
    required this.onDetailButtonPressed,
    required this.onDeleteButtonPressed,
    required this.reservations,
  });

  @override
  DataRow? getRow(int index) {
    final data = reservations[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(data['id'].toString())),
      DataCell(Text(data['name'].toString())),
      DataCell(Text(data['email'].toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => reservations.length;

  @override
  int get selectedRowCount => 0;
}
