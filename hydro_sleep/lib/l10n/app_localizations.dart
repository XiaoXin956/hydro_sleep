import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SmartSleep'**
  String get appTitle;

  /// No description provided for @smartSleepMonitor.
  ///
  /// In en, this message translates to:
  /// **'Smart Sleep Monitor'**
  String get smartSleepMonitor;

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get bottomNavReport;

  /// No description provided for @bottomNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get bottomNavProfile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// No description provided for @myDevices.
  ///
  /// In en, this message translates to:
  /// **'My Devices'**
  String get myDevices;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @modePreference.
  ///
  /// In en, this message translates to:
  /// **'Mode Preference'**
  String get modePreference;

  /// No description provided for @modeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get modeAuto;

  /// No description provided for @modeCooling.
  ///
  /// In en, this message translates to:
  /// **'Cooling'**
  String get modeCooling;

  /// No description provided for @modeHeating.
  ///
  /// In en, this message translates to:
  /// **'Heating'**
  String get modeHeating;

  /// No description provided for @bedExitShutdown.
  ///
  /// In en, this message translates to:
  /// **'Bed Exit Shutdown'**
  String get bedExitShutdown;

  /// No description provided for @firmwareVersion.
  ///
  /// In en, this message translates to:
  /// **'Firmware Version'**
  String get firmwareVersion;

  /// No description provided for @restoreFactorySettings.
  ///
  /// In en, this message translates to:
  /// **'Restore Factory Settings'**
  String get restoreFactorySettings;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep Report'**
  String get reportTitle;

  /// No description provided for @sleepScore.
  ///
  /// In en, this message translates to:
  /// **'Sleep Score'**
  String get sleepScore;

  /// No description provided for @totalSleep.
  ///
  /// In en, this message translates to:
  /// **'Total Sleep'**
  String get totalSleep;

  /// No description provided for @bedtimeToWakeUp.
  ///
  /// In en, this message translates to:
  /// **'Bedtime  →  Wake Up'**
  String get bedtimeToWakeUp;

  /// No description provided for @sleepStages.
  ///
  /// In en, this message translates to:
  /// **'Sleep Stages'**
  String get sleepStages;

  /// No description provided for @sleepTempCurve.
  ///
  /// In en, this message translates to:
  /// **'Sleep & Temp Curve'**
  String get sleepTempCurve;

  /// No description provided for @sleepLegend.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleepLegend;

  /// No description provided for @tempLegend.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get tempLegend;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get average;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maximum;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpm;

  /// No description provided for @dateDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dateDay;

  /// No description provided for @dateWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get dateWeek;

  /// No description provided for @dateMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get dateMonth;

  /// No description provided for @dateYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get dateYear;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @currentTemp.
  ///
  /// In en, this message translates to:
  /// **'Current Temp {temp}°C'**
  String currentTemp(int temp);

  /// No description provided for @targetTemp.
  ///
  /// In en, this message translates to:
  /// **'Target Temp {temp}°C'**
  String targetTemp(int temp);

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @autoMode.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get autoMode;

  /// No description provided for @manualMode.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualMode;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @workTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Time'**
  String get workTimeTitle;

  /// No description provided for @autoAdjustDuringSleep.
  ///
  /// In en, this message translates to:
  /// **'Auto adjust during sleep'**
  String get autoAdjustDuringSleep;

  /// No description provided for @searchDevice.
  ///
  /// In en, this message translates to:
  /// **'Search Device'**
  String get searchDevice;

  /// No description provided for @availableDevices.
  ///
  /// In en, this message translates to:
  /// **'Available Devices'**
  String get availableDevices;

  /// No description provided for @previouslyConnected.
  ///
  /// In en, this message translates to:
  /// **'Previously Connected Devices'**
  String get previouslyConnected;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @connectNewDevice.
  ///
  /// In en, this message translates to:
  /// **'Connect New Device'**
  String get connectNewDevice;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Device Not Connected'**
  String get notConnected;

  /// No description provided for @cannotConnect.
  ///
  /// In en, this message translates to:
  /// **'Cannot Connect'**
  String get cannotConnect;

  /// No description provided for @deviceConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get deviceConnected;

  /// No description provided for @sleepStageDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get sleepStageDeep;

  /// No description provided for @sleepStageLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get sleepStageLight;

  /// No description provided for @sleepStageRem.
  ///
  /// In en, this message translates to:
  /// **'REM'**
  String get sleepStageRem;

  /// No description provided for @sleepStageEyeMove.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get sleepStageEyeMove;

  /// No description provided for @sleepStageAwake.
  ///
  /// In en, this message translates to:
  /// **'Awake'**
  String get sleepStageAwake;

  /// No description provided for @factoryResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Factory Settings'**
  String get factoryResetTitle;

  /// No description provided for @factoryResetMessage.
  ///
  /// In en, this message translates to:
  /// **'This will restore all settings to factory defaults. This action cannot be undone.'**
  String get factoryResetMessage;

  /// No description provided for @factoryResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Factory reset completed'**
  String get factoryResetSuccess;

  /// No description provided for @factoryResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Factory reset failed, please try again'**
  String get factoryResetFailed;

  /// No description provided for @deviceNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Device not connected'**
  String get deviceNotConnected;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get showLess;

  /// No description provided for @bluetoothOff.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is off'**
  String get bluetoothOff;

  /// No description provided for @turnOnBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Turn on Bluetooth'**
  String get turnOnBluetooth;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanning;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @connectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connected successfully'**
  String get connectSuccess;

  /// No description provided for @connectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please enable Bluetooth and Location in Settings.'**
  String get permissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get reconnecting;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get deleteDevice;

  /// No description provided for @deleteDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Tap delete again within 2s to confirm'**
  String get deleteDeviceConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
