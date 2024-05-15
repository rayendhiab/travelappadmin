import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/app_preferences_provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/screens/Auth/login_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_color_scheme.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_sidebar_theme.dart';
import 'package:travel_app_admin/widgets/master_layout_config.dart';
import 'package:travel_app_admin/widgets/sidebar.dart';

class LocaleMenuConfig {
  final String languageCode;
  final String? scriptCode;
  final String name;

  const LocaleMenuConfig({
    required this.languageCode,
    this.scriptCode,
    required this.name,
  });
}

class PortalMasterLayout extends StatelessWidget {
  final Widget body;
  final bool autoSelectMenu;
  final String? selectedMenuUri;
  final void Function(bool isOpened)? onDrawerChanged;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;

  const PortalMasterLayout({
    Key? key,
    required this.body,
    this.autoSelectMenu = true,
    this.selectedMenuUri,
    this.onDrawerChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final themeData = Theme.of(context);
    final drawer =
        (mediaQueryData.size.width <= 992 ? _sidebar(context) : null);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: (drawer != null),
        title: ResponsiveAppBarTitle(
          onAppBarTitlePressed: () {
            //GoRouter.of(context).go(RouteUri.home)
          },
        ),
        actions: [
          _toggleThemeButton(context),
          const SizedBox(width: 16 * 0.5),
        ],
      ),
      drawer: drawer,
      drawerEnableOpenDragGesture: false,
      onDrawerChanged: onDrawerChanged,
      body: _responsiveBody(context),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
    );
  }

  Widget _responsiveBody(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 992) {
      return body;
    } else {
      return Row(
        children: [
          SizedBox(
            width: Theme.of(context).extension<AppSidebarTheme>()!.sidebarWidth,
            child: _sidebar(context),
          ),
          Expanded(child: body),
        ],
      );
    }
  }

  Widget _sidebar(BuildContext context) {
    // final goRouter = GoRouter.of(context);

    final user = Provider.of<DataProvider>(context).user;

    final sidebarMenuConfigs = [
      SidebarMenuConfig(
        uri: "dashboard",
        icon: Icons.dashboard_rounded,
        title: (context) => "Dashboard",
      ),
      SidebarMenuConfig(
        uri: "reservations",
        icon: Icons.library_books_rounded,
        title: (context) => "Reservations",
      ),
      if (user.role == "admin")
        SidebarMenuConfig(
          uri: 'users',
          icon: Icons.people_alt_outlined,
          title: (context) => "Users",
        ),
      if (user.role == "admin")
        SidebarMenuConfig(
          uri: '',
          icon: Icons.assignment_ind_outlined,
          title: (context) => "Agents",
          children: [
            SidebarChildMenuConfig(
              uri: "add-agent",
              icon: Icons.circle_outlined,
              title: (context) => "Ajouter",
            ),
            SidebarChildMenuConfig(
              uri: "agents",
              icon: Icons.circle_outlined,
              title: (context) => 'List',
            ),
          ],
        ),

      SidebarMenuConfig(
        uri: '',
        icon: Icons.flight_takeoff,
        title: (context) => "Offer",
        children: [
          SidebarChildMenuConfig(
            uri: "add-voyage",
            icon: Icons.circle_outlined,
            title: (context) => "Ajouter",
          ),
          SidebarChildMenuConfig(
            uri: "voyages",
            icon: Icons.circle_outlined,
            title: (context) => 'List',
          ),
        ],
      ),
      SidebarMenuConfig(
        uri: '',
        icon: Icons.event,
        title: (context) => "Taches",
        children: [
          SidebarChildMenuConfig(
            uri: "add-event",
            icon: Icons.circle_outlined,
            title: (context) => "Ajouter",
          ),
          SidebarChildMenuConfig(
            uri: "events",
            icon: Icons.circle_outlined,
            title: (context) => 'List',
          ),
        ],
      ),

      SidebarMenuConfig(
        uri: '',
        icon: Icons.local_hotel_outlined,
        title: (context) => "Employee",
        children: [
          SidebarChildMenuConfig(
            uri: "add-hotel",
            icon: Icons.circle_outlined,
            title: (context) => "Ajouter",
          ),
          SidebarChildMenuConfig(
            uri: "hotels",
            icon: Icons.circle_outlined,
            title: (context) => 'List',
          ),
        ],
      ),

      // SidebarMenuConfig(
      //   uri: '/info',
      //   icon: Icons.laptop_windows_rounded,
      //   title: (context) => "Info",
      // ),
    ];

    return Sidebar(
      autoSelectMenu: autoSelectMenu,
      selectedMenuUri: selectedMenuUri,
      onAccountButtonPressed: () {
        //  => goRouter.go(RouteUri.myProfile)
      },
      onLogoutButtonPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginScreen(),
          ),
        );
      },
      sidebarConfigs: sidebarMenuConfigs,
    );
  }

  Widget _toggleThemeButton(BuildContext context) {
    final themeData = Theme.of(context);
    final isFullWidthButton = (MediaQuery.of(context).size.width > 768);

    return SizedBox(
      width: (isFullWidthButton ? null : 48.0),
      child: TextButton(
        onPressed: () async {
          final provider = context.read<AppPreferencesProvider>();
          final currentThemeMode = provider.themeMode;
          final themeMode = (currentThemeMode != ThemeMode.dark
              ? ThemeMode.dark
              : ThemeMode.light);

          provider.setThemeModeAsync(themeMode: themeMode);
        },
        style: TextButton.styleFrom(
          foregroundColor: themeData.colorScheme.onPrimary,
          disabledForegroundColor:
              themeData.extension<AppColorScheme>()!.primary.withOpacity(0.38),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Selector<AppPreferencesProvider, ThemeMode>(
          selector: (context, provider) => provider.themeMode,
          builder: (context, value, child) {
            var icon = Icons.dark_mode_rounded;
            var text = "Dark Theme";

            if (value == ThemeMode.dark) {
              icon = Icons.light_mode_rounded;
              text = "LightTheme";
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
                ),
                Visibility(
                  visible: isFullWidthButton,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16 * 0.5),
                    child: Text(text),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ResponsiveAppBarTitle extends StatelessWidget {
  final void Function() onAppBarTitlePressed;

  const ResponsiveAppBarTitle({
    Key? key,
    required this.onAppBarTitlePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onAppBarTitlePressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: (mediaQueryData.size.width > 576),
              child: Container(
                padding: const EdgeInsets.only(right: 16 * 0.7),
                height: 40.0,
                child: Image.asset(
                  'assets/images/logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text("Travel App Admin"),
          ],
        ),
      ),
    );
  }
}
