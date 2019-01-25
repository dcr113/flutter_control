import 'package:flutter_control/core.dart';

/// Defines language and asset path to file with localization data.
class LocalizationAsset {
  /// Locale key in iso2 standard (en, es, etc.).
  final String iso2Locale;

  /// Asset path to file with localization data.
  final String assetPath;

  /// Default constructor
  LocalizationAsset(this.iso2Locale, this.assetPath);
}

class AppLocalization {
  /// default app locale in iso2 standard.
  final String defaultLocale;

  /// List of available localization assets.
  /// LocalizationAssets defines language and asset path to file with localization data.
  final List<LocalizationAsset> assets;

  /// returns locale in iso2 standard (en, es, etc.).
  String get locale => _locale;

  /// Current locale in iso2 standard (en, es, etc.).
  String _locale;

  /// Current localization data.
  Map<String, String> _data = Map();

  /// Default constructor
  AppLocalization(this.defaultLocale, this.assets, {bool preloadDefaultLocalization: true}) {
    if (preloadDefaultLocalization) {
      changeLocale(defaultLocale);
    }
  }

  /// Enables debug mode for localization.
  /// When localization key isn't found for given locale, then localize() returns key and current locale (key_locale).
  bool debug = true;

  /// returns current Locale of device.
  Locale deviceLocale(BuildContext context) {
    return Localizations.localeOf(context, nullOk: true);
  }

  /// returns true if localization file is available and is possible to load it.
  bool isLocalizationAvailable(String iso2Locale) {
    for (final asset in assets) {
      if (asset.iso2Locale == iso2Locale) {
        //TODO: check if file is available
        return true;
      }
    }

    return false;
  }

  /// Changes localization data inside this object.
  /// If localization isn't available, default localization is then used.
  /// It can take a while because localization is loaded from json file.
  Future<bool> changeLocale(String iso2Locale) async {
    if (!isLocalizationAvailable(iso2Locale)) {
      iso2Locale = defaultLocale;
    }

    if (_locale == iso2Locale) {
      return true;
    }

    _locale = iso2Locale;
    await _initLocalization(_locale);

    return true;
  }

  /// Loads localization from asset file for given locale.
  Future _initLocalization(String iso2Locale) async {
    _data = Map();
    //TODO: load file
  }

  /// Tries to localize text by given key.
  /// Enable/Disable debug mode to show/hide missing localizations.
  String localize(String key) {
    if (_data.containsKey(key)) {
      return _data[key];
    }

    return debug ? "${key}_$_locale" : '';
  }

  /// Tries to localize text by given key.
  /// Enable/Disable debug mode to show/hide missing localizations.
  String extractLocalization(Map<String, String> map, String iso2Locale, String defaultLocale) {
    if (map != null) {
      if (map.containsKey(iso2Locale)) {
        return map[iso2Locale];
      }

      if (map.containsKey(defaultLocale)) {
        return map[defaultLocale];
      }
    }

    return debug ? "empty_${iso2Locale}_or_$defaultLocale" : '';
  }
}