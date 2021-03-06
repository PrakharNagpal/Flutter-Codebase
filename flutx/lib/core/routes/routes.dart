/// [FxRoutes] - able to create add and map routes.

import 'package:flutter/material.dart';
import 'package:flutx/core/routes/middlewares/middleware.dart';
import 'route.dart';

class FxRoutes {
  static List<FxRoute> _routes = [];

  static void create(List<FxRoute> routes) {
    _routes = [];
    _routes.addAll(routes);
  }

  static void add(FxRoute route) {
    _routes.add(route);
  }

  static void addAll(List<FxRoute> routes) {
    _routes.addAll(routes);
  }

  static Map<String, WidgetBuilder> getMapped() {
    Map<String, WidgetBuilder> routesMap = {};

    for (FxRoute route in _routes) {
      routesMap[route.name] = route.widgetBuilder;
    }

    return routesMap;
  }

  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    FxRoute? fxRoute = getRouteFromName(routeName);
    if (fxRoute == null) throw ("This route is not implemented");

    if (fxRoute.middlewares != null) {
      for (FxMiddleware middleware in fxRoute.middlewares!) {
        String redirectedRouteName = await middleware.handle(routeName);
        if (redirectedRouteName.compareTo(routeName) != 0) {
          return pushNamed(context, redirectedRouteName, arguments: arguments);
        }
      }
    }

    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  static FxRoute? getRouteFromName(String routeName) {
    for (FxRoute route in _routes) {
      if (route.name.compareTo(routeName) == 0) return route;
    }
    return null;
  }
}
