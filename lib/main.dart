import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pupl_app/screens/Authentication/AuthInitiateScreen.dart';
import 'package:pupl_app/screens/HomeScreen.dart';
import 'package:pupl_app/screens/authentication/AuthAfterVerifyScreen.dart';
import 'package:pupl_app/screens/passion_timeline/passage/TimelinePassageScreen.dart';
import 'package:pupl_app/utils/custom/navigation/nav_icons_icons.dart';
import 'package:flutx/themes/app_theme.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:pupl_app/AppTheme.dart';
import 'package:pupl_app/AppThemeNotifier.dart';
import 'package:pupl_app/utils/SizeConfig.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://0a47fd7a13f44fed8bed9e9f9609db7f@o924170.ingest.sentry.io/5872184';
      },
      appRunner: () => {
        runApp(ChangeNotifierProvider<AppThemeNotifier>(
          create: (context) => AppThemeNotifier(),
          child: ChangeNotifierProvider<FxAppThemeNotifier>(
            create: (context) => FxAppThemeNotifier(),
            child: PuplApp(),
          ),
        ))
      },
    );
  });
}

class PuplApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FxAppTheme.getThemeFromThemeMode(),
            home: PuplRootPage());
      },
    );
  }
}

class PuplRootPage extends StatefulWidget {
  PuplRootPage({Key? key}) : super(key: key);

  @override
  _PuplRootPageState createState() => _PuplRootPageState();
}

class _PuplRootPageState extends State<PuplRootPage>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;
  int _currentScreenIndex = 0;
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  TabController? _tabController;

  _handleTabSelection() {
    setState(() {
      _currentScreenIndex = _tabController!.index;
    });
  }

  Future<bool> checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bearerTokenPref = await prefs.getString('userJwtToken');
    if (bearerTokenPref != null) isLoggedIn = true;
    return true;
  }

  final List<Widget> _fragmentView = [
    HomeScreen(),
    TimelinePassageScreen(),
    AuthAfterVerifyScreen(name: ''),
    AuthInitiateScreen()
  ];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    _tabController = new TabController(
        length: _fragmentView.length, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabSelection);
    checkUser();
    super.initState();
  }

  onTapped(value) {
    setState(() {
      if (isLoggedIn) {
        _currentScreenIndex = value;
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return AuthInitiateScreen();
          },
        ), (Route<dynamic> route) => false);
      }
    });
  }

  dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    themeData = Theme.of(context);

    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FxAppTheme.theme.copyWith(
                colorScheme: AppTheme.theme.colorScheme.copyWith(
                    secondary:
                        AppTheme.theme.colorScheme.primary.withAlpha(80))),
            home: Scaffold(
                key: _drawerKey,
                bottomNavigationBar: BottomAppBar(
                    elevation: 0,
                    shape: CircularNotchedRectangle(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: customAppTheme.bgLayer1,
                        boxShadow: [
                          BoxShadow(
                            color: customAppTheme.colorInfo.withAlpha(8),
                            blurRadius: 4,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: Spacing.only(top: 16, bottom: 16),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: themeData.colorScheme.primary,
                        tabs: <Widget>[
                          Container(
                            child: Icon(
                              NavIcons.home,
                              key: const Key('home_tab_icon'),
                              color: (_currentScreenIndex == 0)
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          Container(
                            child: Icon(
                              NavIcons.learn,
                              key: const Key('learn_tab_icon'),
                              color: (_currentScreenIndex == 1)
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          Container(
                            child: Icon(
                              NavIcons.calender,
                              key: const Key('calender_tab_icon'),
                              color: (_currentScreenIndex == 2)
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                          Container(
                            child: Icon(
                              NavIcons.settings,
                              key: const Key('settings_tab_icon'),
                              color: (_currentScreenIndex == 3)
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    )),
                backgroundColor: AppTheme.theme.backgroundColor,
                body: _fragmentView[_currentScreenIndex]));
      },
    );
  }
}
