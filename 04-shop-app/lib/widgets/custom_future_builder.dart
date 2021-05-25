import 'package:flutter/material.dart';

typedef FutureFunction = Future Function(BuildContext buildContext);
typedef ErrorWidgetBuilder = Widget Function(Object error, BuildContext context);
typedef SuccessWidgetBuilder = Widget Function(dynamic data, BuildContext context);

class CustomFutureBuilder extends StatefulWidget {
  final FutureFunction _futureProvider;
  final WidgetBuilder _waitingBuilder;
  final ErrorWidgetBuilder _errorBuilder;
  final SuccessWidgetBuilder _successBuilder;

  CustomFutureBuilder({
    required FutureFunction future,
    required SuccessWidgetBuilder successBuilder,
    WidgetBuilder? waitingBuilder,
    ErrorWidgetBuilder? errorBuilder,
  })  : _futureProvider = future,
        _waitingBuilder = waitingBuilder ?? ((_) => const Center(child: CircularProgressIndicator())),
        _errorBuilder = errorBuilder ?? ((_, __) => const Center(child: Text('An error occurred'))),
        _successBuilder = successBuilder;

  @override
  _CustomFutureBuilderState createState() => _CustomFutureBuilderState();
}

class _CustomFutureBuilderState extends State<CustomFutureBuilder> {
  late final Future _future;

  @override
  void initState() {
    super.initState();
    _future = widget._futureProvider(context);
  }

  S? cast<S>(x) => x is S ? x : null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget._waitingBuilder(ctx);
        }
        final error = snapshot.error;
        if (error != null) {
          return widget._errorBuilder(error, ctx);
        }
        return widget._successBuilder(snapshot.data, ctx);
      },
    );
  }
}
