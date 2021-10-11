///

import 'package:flutter/material.dart';
import 'package:flutx/core/routes/middlewares/middleware.dart';

class FxRoute {
  String name;
  WidgetBuilder widgetBuilder;
  List<FxMiddleware>? middlewares;

  FxRoute({required this.name, required this.widgetBuilder, this.middlewares});
}
