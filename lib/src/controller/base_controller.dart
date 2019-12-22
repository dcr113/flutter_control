import 'dart:async';

import 'package:flutter_control/core.dart';

/// Standard initialization of object right after constructor.
abstract class Initializable {
  /// Is typically called right after constructor.
  void init(Map args) {}
}

/// General subscription for controllers.
abstract class Subscriptionable {
  /// Is typically called right after state initialization.
  void subscribe(dynamic object) {}
}

/// Standard disposable implementation.
abstract class Disposable {
  /// Used to clear and dispose object.
  /// After this method call is object typically unusable and ready for GC.
  /// Can be called multiple times!
  void dispose();
}

/// Base abstract class for communication between Controller - [StateController] and [State].
/// Controller can notify State about changes.
/// This class needs to be implemented in State.
abstract class StateNotifier {
  /// Notifies about state changes and requests State to rebuild UI.
  void notifyState([dynamic state]);
}

/// Super base model to use with [ControlWidget]
/// [init] -> [onInit] is called during Widget's construction phase.
/// [subscribe] is called during State's init phase.
///
/// [BaseController]
/// [BaseModel]
///
/// Extend this class to create custom controllers and models.
///
/// Mixin your model with [LocalizationProvider] to enable localization.
class BaseControlModel with DisposeHandler implements Initializable, Subscriptionable {
  /// returns instance of [ControlFactory] if available.
  /// nullable
  ControlFactory get factory => ControlFactory.of(this);

  /// returns instance of [AppControl] if available.
  /// nullable
  AppControl get control => factory.get<AppControl>();

  @override
  void init(Map args) {}

  /// Used to subscribe interface/handler/notifier etc.
  /// Can be called multiple times with different objects!
  @override
  void subscribe(dynamic object) {}

  /// Called during State initialization.
  /// Check [TickerControl] mixin.
  void onTickerInitialized(TickerProvider ticker) {}
}

/// Base controller to use with [ControlWidget]
/// [init] -> [onInit] is called during Widget's construction phase.
/// [subscribe] is called during State's init phase.
///
/// [AppControl]
/// [ControlFactory]
///
/// Mixin your model with [LocalizationProvider] to enable localization.
class BaseController extends BaseControlModel {
  /// init check.
  bool _isInitialized = false;

  /// return true if init function was called before.
  bool get isInitialized => _isInitialized;

  /// prevent multiple times init and [onInit] will be called just once
  bool get preventMultiInit => true;

  /// Set [preventMultiInit] enable multi init / re-init
  @override
  @mustCallSuper
  BaseController init([Map args]) {
    if (isInitialized && preventMultiInit) {
      printDebug('controller is already initialized: ${this.toString()}');
      return this;
    }

    _isInitialized = true;
    onInit(args);

    return this;
  }

  /// Is typically called right after constructor or when init is available.
  /// In most of times [Widget] or [State] isn't ready yet.
  /// check [init] and [preventMultiInit]
  void onInit(Map args) {}

  /// Used to reload Controller.
  /// Currently empty and is ready to override.
  Future<void> reload() async {}

  /// Typically is this method called during State disable phase.
  /// Disables linking between Controller and State.
  @override
  @mustCallSuper
  void dispose() {
    _isInitialized = false;
  }
}

/// [State] must implement [StateNotifier] for proper functionality.
/// Typically [ControlState] is used on the other side.
mixin StateController on BaseControlModel implements StateNotifier {
  /// Notify listeners.
  final _notifier = ActionControl.broadcast();

  ActionControlSub get stateNotifier => _notifier.sub;

  /// Called during State initialization.
  void onStateInitialized() {}

  @override
  void notifyState([dynamic state]) => _notifier.setValue(state);

  ControlSubscription subscribeStateNotifier(ValueCallback action) => _notifier.subscribe(action);

  void cancelStateNotifier(ControlSubscription sub) => _notifier.cancel(sub);

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();

    _notifier.dispose();
  }
}

/// Mixin for [BaseController]
/// Enables navigation from Controller.
///
/// [ControlWidget] with [RouteControl]
/// [RouteNavigator]
/// [RouteHandler] & [PageRouteProvider]
mixin RouteController on BaseControlModel {
  /// Implementation of [RouteNavigator] where [Navigator] is used.
  RouteNavigator _navigator;

  /// Check if is [RouteNavigator] valid.
  bool get isNavigatorAvailable => _navigator != null;

  /// Subscribes [RouteNavigator] for later user.
  @override
  @mustCallSuper
  void subscribe(dynamic object) {
    super.subscribe(object);

    if (object is RouteNavigator) {
      _navigator = object;
    }
  }

  /// [RouteNavigator.openRoute].
  /// [RouteHandler] -> [PageRouteProvider]
  RouteHandler openPage(
    PageRouteProvider provider, {
    bool root: false,
    bool replacement: false,
    Map args,
    FutureOr<dynamic> result(dynamic value),
  }) {
    final handler = RouteHandler(_navigator, provider);

    final future = handler.openRoute(root: root, replacement: replacement, args: args);

    if (result != null) {
      future.then(result);
    }

    return handler;
  }

  /// [RouteNavigator.openRoot].
  /// [RouteHandler] -> [PageRouteProvider]
  RouteHandler openRoot(
    PageRouteProvider provider, {
    Map args,
    FutureOr<dynamic> result(dynamic value),
  }) {
    final handler = RouteHandler(_navigator, provider);

    final future = handler.openRoot(args: args);

    if (result != null) {
      future.then(result);
    }

    return handler;
  }

  /// [RouteNavigator.openDialog].
  /// [RouteHandler] -> [PageRouteProvider]
  Future<dynamic> openDialog(
    PageRouteProvider provider, {
    bool root: false,
    DialogType type: DialogType.popup,
    Map args,
  }) {
    return RouteHandler(_navigator, provider).openDialog(root: root, type: type, args: args);
  }

  /// [RouteNavigator.close].
  void close([dynamic result]) => _navigator?.close(result);

  /// [RouteNavigator.backTo].
  void backTo({
    Route route,
    String identifier,
    bool Function(Route<dynamic>) predicate,
  }) =>
      _navigator?.backTo(
        route: route,
        identifier: identifier,
        predicate: predicate,
      );

  /// [RouteNavigator.openRoot].
  void backToRoot() => _navigator?.backToRoot();

  /// Disables [RouteNavigator].
  @override
  void dispose() {
    super.dispose();

    _navigator = null;
  }
}

mixin DisposeHandler implements Disposable {
  bool get preventDispose => false;

  bool get preferSoftDispose => false;

  void requestDispose() {
    if (preventDispose) {
      return;
    }

    if (preferSoftDispose) {
      softDispose();
    } else {
      dispose();
    }
  }

  void softDispose() {}

  @override
  void dispose() {}
}
