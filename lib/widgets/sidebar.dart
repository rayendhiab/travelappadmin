import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app_admin/providers/data_provider.dart';
import 'package:travel_app_admin/providers/user_data_provider.dart';
import 'package:travel_app_admin/screens/Agent/add_agent_screen.dart';
import 'package:travel_app_admin/screens/Agent/agents_screen.dart';
import 'package:travel_app_admin/screens/Auth/dashboard_screen.dart';
import 'package:travel_app_admin/screens/Event/add_event_screen.dart';
import 'package:travel_app_admin/screens/Event/events_screen.dart';
import 'package:travel_app_admin/screens/Hotel/add_hotel_screen.dart';
import 'package:travel_app_admin/screens/Hotel/hotels_screen.dart';
import 'package:travel_app_admin/screens/Reservation/reservation_screen.dart';
import 'package:travel_app_admin/screens/Theme/theme_extensions/app_sidebar_theme.dart';
import 'package:travel_app_admin/screens/Client/users_screen.dart';
import 'package:travel_app_admin/screens/Voyage/add_voyage_screen.dart';
import 'package:travel_app_admin/screens/Voyage/voyages_screen.dart';
import 'package:travel_app_admin/widgets/master_layout_config.dart';

class SidebarMenuConfig {
  final String uri;
  final IconData icon;
  final String Function(BuildContext context) title;
  final List<SidebarChildMenuConfig> children;

  const SidebarMenuConfig({
    required this.uri,
    required this.icon,
    required this.title,
    List<SidebarChildMenuConfig>? children,
  }) : children = children ?? const [];
}

class SidebarChildMenuConfig {
  final String uri;
  final IconData icon;
  final String Function(BuildContext context) title;

  const SidebarChildMenuConfig({
    required this.uri,
    required this.icon,
    required this.title,
  });
}

class Sidebar extends StatefulWidget {
  final bool autoSelectMenu;
  final String? selectedMenuUri;
  final void Function() onAccountButtonPressed;
  final void Function() onLogoutButtonPressed;
  final List<SidebarMenuConfig> sidebarConfigs;

  const Sidebar({
    Key? key,
    this.autoSelectMenu = true,
    this.selectedMenuUri,
    required this.onAccountButtonPressed,
    required this.onLogoutButtonPressed,
    required this.sidebarConfigs,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final themeData = Theme.of(context);
    final sidebarTheme = themeData.extension<AppSidebarTheme>()!;

    return Drawer(
      child: Column(
        children: [
          Visibility(
            visible: (mediaQueryData.size.width <= 992),
            child: Container(
              alignment: Alignment.centerLeft,
              height: kToolbarHeight,
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                onPressed: () {
                  if (Scaffold.of(context).isDrawerOpen) {
                    Scaffold.of(context).closeDrawer();
                  }
                },
                icon: const Icon(Icons.close_rounded),
                color: sidebarTheme.foregroundColor,
                tooltip: "Close Navigation Menu",
              ),
            ),
          ),
          Expanded(
            child: Theme(
              data: themeData.copyWith(
                scrollbarTheme: themeData.scrollbarTheme.copyWith(
                  thumbColor: MaterialStateProperty.all(
                      sidebarTheme.foregroundColor.withOpacity(0.2)),
                ),
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    sidebarTheme.sidebarLeftPadding,
                    sidebarTheme.sidebarTopPadding,
                    sidebarTheme.sidebarRightPadding,
                    sidebarTheme.sidebarBottomPadding,
                  ),
                  children: [
                    SidebarHeader(
                      onAccountButtonPressed: widget.onAccountButtonPressed,
                      onLogoutButtonPressed: widget.onLogoutButtonPressed,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(
                        height: 2.0,
                        thickness: 1.0,
                        color: sidebarTheme.foregroundColor.withOpacity(0.5),
                      ),
                    ),
                    _sidebarMenuList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarMenuList(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;

    var currentLocation = widget.selectedMenuUri ?? '';

    if (currentLocation.isEmpty && widget.autoSelectMenu) {
      //currentLocation = GoRouter.of(context).location;
    }
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

    return Column(
      children: sidebarMenuConfigs.map<Widget>((menu) {
        if (menu.children.isEmpty) {
          return _sidebarMenu(
            context,
            EdgeInsets.fromLTRB(
              sidebarTheme.menuLeftPadding,
              sidebarTheme.menuTopPadding,
              sidebarTheme.menuRightPadding,
              sidebarTheme.menuBottomPadding,
            ),
            menu.uri,
            menu.icon,
            menu.title(context),
            (currentLocation.startsWith(menu.uri)),
          );
        } else {
          return _expandableSidebarMenu(
            context,
            EdgeInsets.fromLTRB(
              sidebarTheme.menuLeftPadding,
              sidebarTheme.menuTopPadding,
              sidebarTheme.menuRightPadding,
              sidebarTheme.menuBottomPadding,
            ),
            menu.uri,
            menu.icon,
            menu.title(context),
            menu.children,
            currentLocation,
          );
        }
      }).toList(growable: false),
    );
  }

  Widget _sidebarMenu(
    BuildContext context,
    EdgeInsets padding,
    String uri,
    IconData icon,
    String title,
    bool isSelected,
  ) {
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;
    final textColor = (isSelected
        ? sidebarTheme.menuSelectedFontColor
        : sidebarTheme.foregroundColor);

    return Padding(
      padding: padding,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sidebarTheme.menuBorderRadius)),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: (sidebarTheme.menuFontSize + 4.0),
                color: textColor,
              ),
              const SizedBox(width: 16 * 0.5),
              Text(
                title,
                style: TextStyle(
                  fontSize: sidebarTheme.menuFontSize,
                  color: textColor,
                ),
              ),
            ],
          ),
          onTap: () {
            switch (uri) {
              case 'dashboard':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DashboardScreen(),
                  ),
                );
                break;
              case 'reservations':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ReservationsScreen(),
                  ),
                );
                break;
              case 'users':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => UsersScreen(),
                  ),
                );
                break;
              case 'agents':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AgentsScreen(),
                  ),
                );
                break;
              case 'voyages':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => VoyagesScreen(),
                  ),
                );
                break;
              case 'events':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => EventsScreen(),
                  ),
                );
                break;
              case 'hotels':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HotelsScreen(),
                  ),
                );
                break;
              case 'add-agent':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddAgentScreen(id: ''),
                  ),
                );
                break;
              case 'add-event':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddEventScreen(id: ''),
                  ),
                );
                break;
              case 'add-voyage':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddVoyageScreen(id: ''),
                  ),
                );
                break;
              case 'add-hotel':
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddHotelScreen(id: ''),
                  ),
                );
                break;
              default:
            }
            //=> GoRouter.of(context).go(uri)
          },
          selected: isSelected,
          selectedTileColor: sidebarTheme.menuSelectedBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(sidebarTheme.menuBorderRadius)),
          textColor: textColor,
          hoverColor: sidebarTheme.menuHoverColor,
        ),
      ),
    );
  }

  Widget _expandableSidebarMenu(
    BuildContext context,
    EdgeInsets padding,
    String uri,
    IconData icon,
    String title,
    List<SidebarChildMenuConfig> children,
    String currentLocation,
  ) {
    final themeData = Theme.of(context);
    final sidebarTheme = Theme.of(context).extension<AppSidebarTheme>()!;
    final hasSelectedChild =
        children.any((e) => currentLocation.startsWith(e.uri));
    final parentTextColor = (hasSelectedChild
        ? sidebarTheme.menuSelectedFontColor
        : sidebarTheme.foregroundColor);

    return Padding(
      padding: padding,
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sidebarTheme.menuBorderRadius)),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: themeData.copyWith(
            hoverColor: sidebarTheme.menuExpandedHoverColor,
          ),
          child: ExpansionTile(
            key: UniqueKey(),
            textColor: parentTextColor,
            collapsedTextColor: parentTextColor,
            iconColor: parentTextColor,
            collapsedIconColor: parentTextColor,
            backgroundColor: sidebarTheme.menuExpandedBackgroundColor,
            collapsedBackgroundColor: (hasSelectedChild
                ? sidebarTheme.menuExpandedBackgroundColor
                : Colors.transparent),
            initiallyExpanded: hasSelectedChild,
            childrenPadding: EdgeInsets.only(
              top: sidebarTheme.menuExpandedChildTopPadding,
              bottom: sidebarTheme.menuExpandedChildBottomPadding,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: (sidebarTheme.menuFontSize + 4.0),
                ),
                const SizedBox(width: 16 * 0.5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sidebarTheme.menuFontSize,
                  ),
                ),
              ],
            ),
            children: children.map<Widget>((childMenu) {
              return _sidebarMenu(
                context,
                EdgeInsets.fromLTRB(
                  sidebarTheme.menuExpandedChildLeftPadding,
                  sidebarTheme.menuExpandedChildTopPadding,
                  sidebarTheme.menuExpandedChildRightPadding,
                  sidebarTheme.menuExpandedChildBottomPadding,
                ),
                childMenu.uri,
                childMenu.icon,
                childMenu.title(context),
                (currentLocation.startsWith(childMenu.uri)),
              );
            }).toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class SidebarHeader extends StatelessWidget {
  final void Function() onAccountButtonPressed;
  final void Function() onLogoutButtonPressed;

  const SidebarHeader({
    Key? key,
    required this.onAccountButtonPressed,
    required this.onLogoutButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final sidebarTheme = themeData.extension<AppSidebarTheme>()!;
    final user = Provider.of<DataProvider>(context).user;

    return Column(
      children: [
        Row(
          children: [
            Selector<UserDataProvider, String>(
              selector: (context, provider) => provider.userProfileImageUrl,
              builder: (context, value, child) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(value),
                  radius: 20.0,
                );
              },
            ),
            const SizedBox(width: 16 * 0.5),
            Selector<UserDataProvider, String>(
              selector: (context, provider) => provider.username,
              builder: (context, value, child) {
                return Text(
                  'Hi, ' + user.nom,
                  style: TextStyle(
                    fontSize: sidebarTheme.headerUsernameFontSize,
                    color: sidebarTheme.foregroundColor,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16 * 0.5),
        Align(
          alignment: Alignment.centerRight,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textButton(
                    themeData,
                    sidebarTheme,
                    Icons.manage_accounts_rounded,
                    "Account",
                    onAccountButtonPressed),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: VerticalDivider(
                    width: 2.0,
                    thickness: 1.0,
                    color: sidebarTheme.foregroundColor.withOpacity(0.5),
                    indent: 4,
                    endIndent: 4,
                  ),
                ),
                _textButton(themeData, sidebarTheme, Icons.login_rounded,
                    "Logout", onLogoutButtonPressed),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _textButton(ThemeData themeData, AppSidebarTheme sidebarTheme,
      IconData icon, String text, void Function() onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: sidebarTheme.foregroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: (sidebarTheme.headerUsernameFontSize + 4.0),
          ),
          const SizedBox(width: 16 * 0.5),
          Text(
            text,
            style: TextStyle(
              fontSize: sidebarTheme.headerUsernameFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
