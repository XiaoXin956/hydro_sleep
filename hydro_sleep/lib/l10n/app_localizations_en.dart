// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SmartSleep';

  @override
  String get smartSleepMonitor => 'Smart Sleep Monitor';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavReport => 'Report';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get defaultUserName => 'User';

  @override
  String get myDevices => 'My Devices';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get language => 'Language';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get modePreference => 'Mode Preference';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modeCooling => 'Cooling';

  @override
  String get modeHeating => 'Heating';

  @override
  String get bedExitShutdown => 'Bed Exit Shutdown';

  @override
  String get firmwareVersion => 'Firmware Version';

  @override
  String get restoreFactorySettings => 'Restore Factory Settings';

  @override
  String get reportTitle => 'Sleep Report';

  @override
  String get sleepScore => 'Sleep Score';

  @override
  String get totalSleep => 'Total Sleep';

  @override
  String get bedtimeToWakeUp => 'Bedtime  →  Wake Up';

  @override
  String get sleepStages => 'Sleep Stages';

  @override
  String get sleepTempCurve => 'Sleep & Temp Curve';

  @override
  String get sleepLegend => 'Sleep';

  @override
  String get tempLegend => 'Temp';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get average => 'Avg';

  @override
  String get minimum => 'Min';

  @override
  String get maximum => 'Max';

  @override
  String get bpm => 'BPM';

  @override
  String get dateDay => 'Day';

  @override
  String get dateWeek => 'Week';

  @override
  String get dateMonth => 'Month';

  @override
  String get temperature => 'Temperature';

  @override
  String currentTemp(int temp) {
    return 'Current Temp $temp°C';
  }

  @override
  String targetTemp(int temp) {
    return 'Target Temp $temp°C';
  }

  @override
  String get mode => 'Mode';

  @override
  String get autoMode => 'Auto';

  @override
  String get manualMode => 'Manual';

  @override
  String get schedule => 'Schedule';

  @override
  String get workTimeTitle => 'Work Time';

  @override
  String workTimeHours(int hours) {
    return '$hours h';
  }

  @override
  String get waterLevel => 'Water Level';

  @override
  String get waterLevelNormal => 'Normal';

  @override
  String get waterLevelAbnormal => 'Abnormal';

  @override
  String get autoAdjustDuringSleep => 'Auto adjust during sleep';

  @override
  String get searchDevice => 'Search Device';

  @override
  String get availableDevices => 'Available Devices';

  @override
  String get previouslyConnected => 'Previously Connected Devices';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get connectNewDevice => 'Connect New Device';

  @override
  String get addDevice => 'Add Device';

  @override
  String get connect => 'Connect';

  @override
  String get notConnected => 'Device Not Connected';

  @override
  String get cannotConnect => 'Cannot Connect';

  @override
  String get deviceConnected => 'Connected';

  @override
  String get sleepStageDeep => 'Deep';

  @override
  String get sleepStageLight => 'Light';

  @override
  String get sleepStageRem => 'REM';

  @override
  String get sleepStageEyeMove => 'Active';

  @override
  String get sleepStageAwake => 'Awake';

  @override
  String get factoryResetTitle => 'Restore Factory Settings';

  @override
  String get factoryResetMessage =>
      'This will restore all settings to factory defaults. This action cannot be undone.';

  @override
  String get factoryResetSuccess => 'Factory reset completed';

  @override
  String get factoryResetFailed => 'Factory reset failed, please try again';

  @override
  String get deviceNotConnected => 'Device not connected';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get showMore => 'More';

  @override
  String get showLess => 'Less';

  @override
  String get bluetoothOff => 'Bluetooth is off';

  @override
  String get turnOnBluetooth => 'Turn on Bluetooth';

  @override
  String get noDevicesFound => 'No devices found';

  @override
  String get scanning => 'Scanning…';

  @override
  String get connecting => 'Connecting…';

  @override
  String get connectSuccess => 'Connected successfully';

  @override
  String get connectFailed => 'Connection failed';

  @override
  String get retry => 'Retry';

  @override
  String get done => 'Done';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get permissionDenied =>
      'Permission denied. Please enable Bluetooth and Location in Settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get reconnecting => 'Reconnecting…';

  @override
  String get delete => 'Delete';

  @override
  String get deleteDevice => 'Delete device';

  @override
  String get deleteDeviceConfirm => 'Tap delete again within 2s to confirm';
}
