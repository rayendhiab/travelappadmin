import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Reservation/reservation_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_button_theme.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_color_scheme.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_data_table_theme.dart';
import 'package:travel_app_admin/widgets/card_elements.dart';
import 'package:travel_app_admin/widgets/portal_master_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final reservations = Provider.of<DataProvider>(context).reservations;
    final clientsCount = Provider.of<DataProvider>(context).clients.length;
    final totalIcome = Provider.of<DataProvider>(context).totalIcome;
    final clients = Provider.of<DataProvider>(context).clients;

    final summaryCardCrossAxisCount = (size.width >= 992 ? 4 : 2);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Dashboard",
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth -
                        (16 * (summaryCardCrossAxisCount - 1))) /
                    summaryCardCrossAxisCount);

                return Wrap(
                  direction: Axis.horizontal,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SummaryCard(
                      title: "Total Reservations",
                      value: reservations.length.toString(),
                      icon: Icons.shopping_cart_rounded,
                      backgroundColor: appColorScheme.info,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: "Today Reservations",
                      value: '6',
                      icon: Icons.calendar_today,
                      backgroundColor: appColorScheme.secondary,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: "Total Users",
                      value: clientsCount.toString(),
                      icon: Icons.group_add_rounded,
                      backgroundColor: appColorScheme.warning,
                      textColor: appColorScheme.buttonTextBlack,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: "Total Income",
                      value: totalIcome.toStringAsFixed(2),
                      icon: Icons.monetization_on_outlined,
                      backgroundColor: appColorScheme.success,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: "Recent Reservations",
                    showDivider: false,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double dataTableWidth =
                            max(768, constraints.maxWidth);

                        return Scrollbar(
                          controller: _dataTableHorizontalScrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _dataTableHorizontalScrollController,
                            child: SizedBox(
                              width: dataTableWidth,
                              child: Theme(
                                data: themeData.copyWith(
                                  cardTheme: appDataTableTheme.cardTheme,
                                  dataTableTheme:
                                      appDataTableTheme.dataTableThemeData,
                                ),
                                child: DataTable(
                                  showCheckboxColumn: false,
                                  showBottomBorder: true,
                                  columns: const [
                                    DataColumn(
                                        label: Text('No.'), numeric: true),
                                    DataColumn(label: Text('Date')),
                                    DataColumn(label: Text('Client')),
                                    DataColumn(
                                        label: Text('Price'), numeric: true),
                                    DataColumn(
                                        label: Text('People'), numeric: true),
                                  ],
                                  rows: List.generate(5, (index) {
                                    return DataRow.byIndex(
                                      index: index,
                                      cells: [
                                        DataCell(Text('#${index + 1}')),
                                        DataCell(Text(reservations[
                                                (reservations.length - index) -
                                                    1]
                                            .dateReservation)),
                                        DataCell(Text(clients
                                            .firstWhere((element) =>
                                                element.id ==
                                                reservations[
                                                        (reservations.length -
                                                                index) -
                                                            1]
                                                    .userId)
                                            .nom)),
                                        DataCell(Text(reservations[
                                                (reservations.length - index) -
                                                    1]
                                            .prix
                                            .toStringAsFixed(2))),
                                        DataCell(Text(reservations[
                                                (reservations.length - index) -
                                                    1]
                                            .numPerson
                                            .toString())),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 40.0,
                        width: 120.0,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ReservationsScreen(),
                            ),
                          ),
                          style: themeData
                              .extension<AppButtonTheme>()!
                              .infoElevated,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16 * 0.5),
                                child: Icon(
                                  Icons.visibility_rounded,
                                  size: (themeData
                                          .textTheme.labelLarge!.fontSize! +
                                      4.0),
                                ),
                              ),
                              const Text('View All'),
                            ],
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
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120.0,
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: 16 * 0.5,
              right: 16 * 0.5,
              child: Icon(
                icon,
                size: 80.0,
                color: iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16 * 0.5),
                    child: Text(
                      value,
                      style: textTheme.headlineMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: textTheme.labelLarge!.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
