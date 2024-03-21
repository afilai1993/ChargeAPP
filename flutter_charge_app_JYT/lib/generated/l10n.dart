// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `abChargego`
  String get app_name {
    return Intl.message(
      'abChargego',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Charging Statistics`
  String get charging_statistics {
    return Intl.message(
      'Charging Statistics',
      name: 'charging_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Exit Account`
  String get exit_account {
    return Intl.message(
      'Exit Account',
      name: 'exit_account',
      desc: '',
      args: [],
    );
  }

  /// `Unregister Account`
  String get unregister_account {
    return Intl.message(
      'Unregister Account',
      name: 'unregister_account',
      desc: '',
      args: [],
    );
  }

  /// `All Orders`
  String get all_order {
    return Intl.message(
      'All Orders',
      name: 'all_order',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Charging`
  String get charging {
    return Intl.message(
      'Charging',
      name: 'charging',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get refunded {
    return Intl.message(
      'Refunded',
      name: 'refunded',
      desc: '',
      args: [],
    );
  }

  /// `Not Refunded`
  String get not_refunded {
    return Intl.message(
      'Not Refunded',
      name: 'not_refunded',
      desc: '',
      args: [],
    );
  }

  /// `Not Started`
  String get not_started {
    return Intl.message(
      'Not Started',
      name: 'not_started',
      desc: '',
      args: [],
    );
  }

  /// `Frequently Used Entrances`
  String get frequently_used_entrances {
    return Intl.message(
      'Frequently Used Entrances',
      name: 'frequently_used_entrances',
      desc: '',
      args: [],
    );
  }

  /// `Recharge Balance`
  String get recharge_balance {
    return Intl.message(
      'Recharge Balance',
      name: 'recharge_balance',
      desc: '',
      args: [],
    );
  }

  /// `Bonus Balance`
  String get bonus_balance {
    return Intl.message(
      'Bonus Balance',
      name: 'bonus_balance',
      desc: '',
      args: [],
    );
  }

  /// `Recharge`
  String get recharge {
    return Intl.message(
      'Recharge',
      name: 'recharge',
      desc: '',
      args: [],
    );
  }

  /// `Details and Refunds`
  String get details_refunds {
    return Intl.message(
      'Details and Refunds',
      name: 'details_refunds',
      desc: '',
      args: [],
    );
  }

  /// `Car Manager`
  String get car_manager {
    return Intl.message(
      'Car Manager',
      name: 'car_manager',
      desc: '',
      args: [],
    );
  }

  /// `Helper Center`
  String get helper_center {
    return Intl.message(
      'Helper Center',
      name: 'helper_center',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about_us {
    return Intl.message(
      'About Us',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get coupon_package {
    return Intl.message(
      'Coupon',
      name: 'coupon_package',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the abChargego`
  String get welcome {
    return Intl.message(
      'Welcome to the abChargego',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message(
      'Agree',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get user_agreement {
    return Intl.message(
      'User Agreement',
      name: 'user_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get forget_password {
    return Intl.message(
      'Forget Password',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get validate_input_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'validate_input_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get validate_input_password {
    return Intl.message(
      'Please enter a password',
      name: 'validate_input_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid username`
  String get validate_input_username {
    return Intl.message(
      'Please enter a valid username',
      name: 'validate_input_username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get validate_input_verification_code {
    return Intl.message(
      'Please enter the verification code',
      name: 'validate_input_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Please check the agreement`
  String get validate_check_agreement {
    return Intl.message(
      'Please check the agreement',
      name: 'validate_check_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get success_login {
    return Intl.message(
      'Login successful',
      name: 'success_login',
      desc: '',
      args: [],
    );
  }

  /// `Send successful`
  String get success_send {
    return Intl.message(
      'Send successful',
      name: 'success_send',
      desc: '',
      args: [],
    );
  }

  /// `Operation successful`
  String get success_operation {
    return Intl.message(
      'Operation successful',
      name: 'success_operation',
      desc: '',
      args: [],
    );
  }

  /// `Update successful`
  String get success_update {
    return Intl.message(
      'Update successful',
      name: 'success_update',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get user_name {
    return Intl.message(
      'Nickname',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verification_code {
    return Intl.message(
      'Verification Code',
      name: 'verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Retrieve`
  String get retrieve {
    return Intl.message(
      'Retrieve',
      name: 'retrieve',
      desc: '',
      args: [],
    );
  }

  /// `{second} seconds`
  String count_second(Object second) {
    return Intl.message(
      '$second seconds',
      name: 'count_second',
      desc: '',
      args: [second],
    );
  }

  /// `User Center`
  String get user_center {
    return Intl.message(
      'User Center',
      name: 'user_center',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get avatar {
    return Intl.message(
      'Avatar',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Edit Username`
  String get edit_nickname {
    return Intl.message(
      'Edit Username',
      name: 'edit_nickname',
      desc: '',
      args: [],
    );
  }

  /// `Pick in Gallery`
  String get pick_in_gallery {
    return Intl.message(
      'Pick in Gallery',
      name: 'pick_in_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get pick_in_camera {
    return Intl.message(
      'Take a Photo',
      name: 'pick_in_camera',
      desc: '',
      args: [],
    );
  }

  /// `Requesting`
  String get requesting {
    return Intl.message(
      'Requesting',
      name: 'requesting',
      desc: '',
      args: [],
    );
  }

  /// `User Center`
  String get mine_center {
    return Intl.message(
      'User Center',
      name: 'mine_center',
      desc: '',
      args: [],
    );
  }

  /// `Please login`
  String get please_login {
    return Intl.message(
      'Please login',
      name: 'please_login',
      desc: '',
      args: [],
    );
  }

  /// `Nearby`
  String get nearby {
    return Intl.message(
      'Nearby',
      name: 'nearby',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scan {
    return Intl.message(
      'Scan',
      name: 'scan',
      desc: '',
      args: [],
    );
  }

  /// `Numbering`
  String get numbering {
    return Intl.message(
      'Numbering',
      name: 'numbering',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get empty_data {
    return Intl.message(
      'No data available',
      name: 'empty_data',
      desc: '',
      args: [],
    );
  }

  /// `Request failed`
  String get request_fail {
    return Intl.message(
      'Request failed',
      name: 'request_fail',
      desc: '',
      args: [],
    );
  }

  /// `Distance Priority`
  String get distance_asc {
    return Intl.message(
      'Distance Priority',
      name: 'distance_asc',
      desc: '',
      args: [],
    );
  }

  /// `Price Priority`
  String get price_asc {
    return Intl.message(
      'Price Priority',
      name: 'price_asc',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh`
  String get pull_down_refresh {
    return Intl.message(
      'Pull down to refresh',
      name: 'pull_down_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get pull_down_release {
    return Intl.message(
      'Release to refresh',
      name: 'pull_down_release',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Refresh complete`
  String get loading_complete {
    return Intl.message(
      'Refresh complete',
      name: 'loading_complete',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get no_more {
    return Intl.message(
      'No more data',
      name: 'no_more',
      desc: '',
      args: [],
    );
  }

  /// `Refresh failed, click to retry`
  String get load_more_refresh_error {
    return Intl.message(
      'Refresh failed, click to retry',
      name: 'load_more_refresh_error',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Scan for Devices`
  String get scan_device {
    return Intl.message(
      'Scan for Devices',
      name: 'scan_device',
      desc: '',
      args: [],
    );
  }

  /// `To accurately scan nearby Bluetooth devices, permission to scan Bluetooth and location is required`
  String get request_scan_bluetooth_permission {
    return Intl.message(
      'To accurately scan nearby Bluetooth devices, permission to scan Bluetooth and location is required',
      name: 'request_scan_bluetooth_permission',
      desc: '',
      args: [],
    );
  }

  /// `To accurately scan nearby Bluetooth devices, permission to Bluetooth is required`
  String get request_scan_bluetooth_permission_by_ios {
    return Intl.message(
      'To accurately scan nearby Bluetooth devices, permission to Bluetooth is required',
      name: 'request_scan_bluetooth_permission_by_ios',
      desc: '',
      args: [],
    );
  }

  /// `Device search completed`
  String get search_device_complete {
    return Intl.message(
      'Device search completed',
      name: 'search_device_complete',
      desc: '',
      args: [],
    );
  }

  /// `Reset search`
  String get reset_search {
    return Intl.message(
      'Reset search',
      name: 'reset_search',
      desc: '',
      args: [],
    );
  }

  /// `Please keep the phone close to the device if possible`
  String get tip_searching_device {
    return Intl.message(
      'Please keep the phone close to the device if possible',
      name: 'tip_searching_device',
      desc: '',
      args: [],
    );
  }

  /// `Searching for devices...`
  String get searching_device {
    return Intl.message(
      'Searching for devices...',
      name: 'searching_device',
      desc: '',
      args: [],
    );
  }

  /// `Current device does not support Bluetooth`
  String get not_support_bluetooth {
    return Intl.message(
      'Current device does not support Bluetooth',
      name: 'not_support_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Bind Device`
  String get bind_device {
    return Intl.message(
      'Bind Device',
      name: 'bind_device',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the password`
  String get msg_error_input_device_key {
    return Intl.message(
      'Please fill in the password',
      name: 'msg_error_input_device_key',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get task {
    return Intl.message(
      'Task',
      name: 'task',
      desc: '',
      args: [],
    );
  }

  /// `Not Connected`
  String get connect_status_idle {
    return Intl.message(
      'Not Connected',
      name: 'connect_status_idle',
      desc: '',
      args: [],
    );
  }

  /// `Connecting`
  String get connect_status_connecting {
    return Intl.message(
      'Connecting',
      name: 'connect_status_connecting',
      desc: '',
      args: [],
    );
  }

  /// `Pairing`
  String get connect_status_ensure_key {
    return Intl.message(
      'Pairing',
      name: 'connect_status_ensure_key',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connect_status_connected {
    return Intl.message(
      'Connected',
      name: 'connect_status_connected',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get device {
    return Intl.message(
      'Device',
      name: 'device',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get record {
    return Intl.message(
      'Record',
      name: 'record',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message(
      'Reminder',
      name: 'reminder',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Data Overview`
  String get data_profile {
    return Intl.message(
      'Data Overview',
      name: 'data_profile',
      desc: '',
      args: [],
    );
  }

  /// `Total Power (kw·H)`
  String get profile_total_power {
    return Intl.message(
      'Total Power (kw·H)',
      name: 'profile_total_power',
      desc: '',
      args: [],
    );
  }

  /// `Current (A)`
  String get profile_current {
    return Intl.message(
      'Current (A)',
      name: 'profile_current',
      desc: '',
      args: [],
    );
  }

  /// `Voltage (V)`
  String get profile_voltage {
    return Intl.message(
      'Voltage (V)',
      name: 'profile_voltage',
      desc: '',
      args: [],
    );
  }

  /// `Power (kW)`
  String get profile_power {
    return Intl.message(
      'Power (kW)',
      name: 'profile_power',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get profile_total_time {
    return Intl.message(
      'Duration',
      name: 'profile_total_time',
      desc: '',
      args: [],
    );
  }

  /// `Idle`
  String get charge_status_idle {
    return Intl.message(
      'Idle',
      name: 'charge_status_idle',
      desc: '',
      args: [],
    );
  }

  /// `Reserved`
  String get charge_status_reserve {
    return Intl.message(
      'Reserved',
      name: 'charge_status_reserve',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get charge_status_wait {
    return Intl.message(
      'Ready',
      name: 'charge_status_wait',
      desc: '',
      args: [],
    );
  }

  /// `Charging`
  String get charge_status_charging {
    return Intl.message(
      'Charging',
      name: 'charge_status_charging',
      desc: '',
      args: [],
    );
  }

  /// `Charging Completed`
  String get charge_status_finish {
    return Intl.message(
      'Charging Completed',
      name: 'charge_status_finish',
      desc: '',
      args: [],
    );
  }

  /// `Leakage Protection`
  String get charge_status_safe_fault {
    return Intl.message(
      'Leakage Protection',
      name: 'charge_status_safe_fault',
      desc: '',
      args: [],
    );
  }

  /// `Charging Suspended`
  String get charge_status_suspend_N {
    return Intl.message(
      'Charging Suspended',
      name: 'charge_status_suspend_N',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get charge_status_other {
    return Intl.message(
      'Other',
      name: 'charge_status_other',
      desc: '',
      args: [],
    );
  }

  /// `Unknown: {status}`
  String charge_status_any(Object status) {
    return Intl.message(
      'Unknown: $status',
      name: 'charge_status_any',
      desc: '',
      args: [status],
    );
  }

  /// `Start Date`
  String get start_date {
    return Intl.message(
      'Start Date',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get end_date {
    return Intl.message(
      'End Date',
      name: 'end_date',
      desc: '',
      args: [],
    );
  }

  /// `Charging Mode`
  String get charge_mode {
    return Intl.message(
      'Charging Mode',
      name: 'charge_mode',
      desc: '',
      args: [],
    );
  }

  /// `Charging Duration`
  String get charge_time {
    return Intl.message(
      'Charging Duration',
      name: 'charge_time',
      desc: '',
      args: [],
    );
  }

  /// `Charging Power (kw·H)`
  String get charge_energy {
    return Intl.message(
      'Charging Power (kw·H)',
      name: 'charge_energy',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get charge_status_code_0 {
    return Intl.message(
      'Normal',
      name: 'charge_status_code_0',
      desc: '',
      args: [],
    );
  }

  /// `Ground Fault`
  String get charge_status_code_1 {
    return Intl.message(
      'Ground Fault',
      name: 'charge_status_code_1',
      desc: '',
      args: [],
    );
  }

  /// `Overtemperature Fault`
  String get charge_status_code_2 {
    return Intl.message(
      'Overtemperature Fault',
      name: 'charge_status_code_2',
      desc: '',
      args: [],
    );
  }

  /// `Overvoltage Fault`
  String get charge_status_code_3 {
    return Intl.message(
      'Overvoltage Fault',
      name: 'charge_status_code_3',
      desc: '',
      args: [],
    );
  }

  /// `Undervoltage Fault`
  String get charge_status_code_4 {
    return Intl.message(
      'Undervoltage Fault',
      name: 'charge_status_code_4',
      desc: '',
      args: [],
    );
  }

  /// `Overcurrent Fault`
  String get charge_status_code_5 {
    return Intl.message(
      'Overcurrent Fault',
      name: 'charge_status_code_5',
      desc: '',
      args: [],
    );
  }

  /// `Relay Fault`
  String get charge_status_code_6 {
    return Intl.message(
      'Relay Fault',
      name: 'charge_status_code_6',
      desc: '',
      args: [],
    );
  }

  /// `CP Fault`
  String get charge_status_code_7 {
    return Intl.message(
      'CP Fault',
      name: 'charge_status_code_7',
      desc: '',
      args: [],
    );
  }

  /// `Leakage Circuit Exception (Self-Test)`
  String get charge_status_code_8 {
    return Intl.message(
      'Leakage Circuit Exception (Self-Test)',
      name: 'charge_status_code_8',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Stop Fault`
  String get charge_status_code_9 {
    return Intl.message(
      'Emergency Stop Fault',
      name: 'charge_status_code_9',
      desc: '',
      args: [],
    );
  }

  /// `Electronic Lock Fault`
  String get charge_status_code_10 {
    return Intl.message(
      'Electronic Lock Fault',
      name: 'charge_status_code_10',
      desc: '',
      args: [],
    );
  }

  /// `Leakage Fault`
  String get charge_status_code_11 {
    return Intl.message(
      'Leakage Fault',
      name: 'charge_status_code_11',
      desc: '',
      args: [],
    );
  }

  /// `Electric Meter Fault`
  String get charge_status_code_12 {
    return Intl.message(
      'Electric Meter Fault',
      name: 'charge_status_code_12',
      desc: '',
      args: [],
    );
  }

  /// `Leakage Protection`
  String get charge_status_code_13 {
    return Intl.message(
      'Leakage Protection',
      name: 'charge_status_code_13',
      desc: '',
      args: [],
    );
  }

  /// `Electric Meter Fault 1`
  String get charge_status_code_14 {
    return Intl.message(
      'Electric Meter Fault 1',
      name: 'charge_status_code_14',
      desc: '',
      args: [],
    );
  }

  /// `Electric Meter Fault 2`
  String get charge_status_code_15 {
    return Intl.message(
      'Electric Meter Fault 2',
      name: 'charge_status_code_15',
      desc: '',
      args: [],
    );
  }

  /// `CP Grounding`
  String get charge_status_code_16 {
    return Intl.message(
      'CP Grounding',
      name: 'charge_status_code_16',
      desc: '',
      args: [],
    );
  }

  /// `Ground Fault`
  String get charge_status_code_17 {
    return Intl.message(
      'Ground Fault',
      name: 'charge_status_code_17',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Fault: {code}`
  String charge_status_code_any(Object code) {
    return Intl.message(
      'Unknown Fault: $code',
      name: 'charge_status_code_any',
      desc: '',
      args: [code],
    );
  }

  /// `Current Value`
  String get charge_current {
    return Intl.message(
      'Current Value',
      name: 'charge_current',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temperature {
    return Intl.message(
      'Temperature',
      name: 'temperature',
      desc: '',
      args: [],
    );
  }

  /// `Total Power`
  String get total_power {
    return Intl.message(
      'Total Power',
      name: 'total_power',
      desc: '',
      args: [],
    );
  }

  /// `Device Serial Number`
  String get device_sn {
    return Intl.message(
      'Device Serial Number',
      name: 'device_sn',
      desc: '',
      args: [],
    );
  }

  /// `Hardware Version`
  String get hardware_version {
    return Intl.message(
      'Hardware Version',
      name: 'hardware_version',
      desc: '',
      args: [],
    );
  }

  /// `Software Version`
  String get software_version {
    return Intl.message(
      'Software Version',
      name: 'software_version',
      desc: '',
      args: [],
    );
  }

  /// `Remote Diagnosis`
  String get remote_diagnosis {
    return Intl.message(
      'Remote Diagnosis',
      name: 'remote_diagnosis',
      desc: '',
      args: [],
    );
  }

  /// `Reboot`
  String get reboot {
    return Intl.message(
      'Reboot',
      name: 'reboot',
      desc: '',
      args: [],
    );
  }

  /// `Add Task`
  String get add_task {
    return Intl.message(
      'Add Task',
      name: 'add_task',
      desc: '',
      args: [],
    );
  }

  /// `Edit Task`
  String get update_task {
    return Intl.message(
      'Edit Task',
      name: 'update_task',
      desc: '',
      args: [],
    );
  }

  /// `Charging Pile`
  String get charging_pile {
    return Intl.message(
      'Charging Pile',
      name: 'charging_pile',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get start_time {
    return Intl.message(
      'Start Time',
      name: 'start_time',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get end_time {
    return Intl.message(
      'End Time',
      name: 'end_time',
      desc: '',
      args: [],
    );
  }

  /// `Recurring Date`
  String get loop_date {
    return Intl.message(
      'Recurring Date',
      name: 'loop_date',
      desc: '',
      args: [],
    );
  }

  /// `Task Name`
  String get task_name {
    return Intl.message(
      'Task Name',
      name: 'task_name',
      desc: '',
      args: [],
    );
  }

  /// `Next Day`
  String get next_day {
    return Intl.message(
      'Next Day',
      name: 'next_day',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Every Day`
  String get every_day {
    return Intl.message(
      'Every Day',
      name: 'every_day',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Please enter device password`
  String get hint_input_device_password {
    return Intl.message(
      'Please enter device password',
      name: 'hint_input_device_password',
      desc: '',
      args: [],
    );
  }

  /// `Add Device`
  String get add_device {
    return Intl.message(
      'Add Device',
      name: 'add_device',
      desc: '',
      args: [],
    );
  }

  /// `Add successful`
  String get msg_success_add {
    return Intl.message(
      'Add successful',
      name: 'msg_success_add',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get all_selected {
    return Intl.message(
      'Select All',
      name: 'all_selected',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Request successful`
  String get request_success {
    return Intl.message(
      'Request successful',
      name: 'request_success',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete {name}?`
  String tip_delete_time(Object name) {
    return Intl.message(
      'Are you sure you want to delete $name?',
      name: 'tip_delete_time',
      desc: '',
      args: [name],
    );
  }

  /// `Please select charging pile`
  String get msg_charge_device_not_selected {
    return Intl.message(
      'Please select charging pile',
      name: 'msg_charge_device_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in start date`
  String get msg_not_start_date {
    return Intl.message(
      'Please fill in start date',
      name: 'msg_not_start_date',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in end date`
  String get msg_not_end_date {
    return Intl.message(
      'Please fill in end date',
      name: 'msg_not_end_date',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in task name`
  String get msg_not_input_task_name {
    return Intl.message(
      'Please fill in task name',
      name: 'msg_not_input_task_name',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in start time`
  String get msg_start_time_not_selected {
    return Intl.message(
      'Please fill in start time',
      name: 'msg_start_time_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in end time`
  String get msg_end_time_not_selected {
    return Intl.message(
      'Please fill in end time',
      name: 'msg_end_time_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to log out?`
  String get msg_confirm_logout {
    return Intl.message(
      'Do you want to log out?',
      name: 'msg_confirm_logout',
      desc: '',
      args: [],
    );
  }

  /// `After unregistering, all data of the account will be lost. Do you want to continue?`
  String get msg_confirm_unregister {
    return Intl.message(
      'After unregistering, all data of the account will be lost. Do you want to continue?',
      name: 'msg_confirm_unregister',
      desc: '',
      args: [],
    );
  }

  /// `Unbind`
  String get unbind {
    return Intl.message(
      'Unbind',
      name: 'unbind',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to unbind the current device?`
  String get msg_confirm_unbind {
    return Intl.message(
      'Do you want to unbind the current device?',
      name: 'msg_confirm_unbind',
      desc: '',
      args: [],
    );
  }

  /// `Device not connected`
  String get msg_device_not_connected {
    return Intl.message(
      'Device not connected',
      name: 'msg_device_not_connected',
      desc: '',
      args: [],
    );
  }

  /// `Device encountered a problem`
  String get msg_device_error {
    return Intl.message(
      'Device encountered a problem',
      name: 'msg_device_error',
      desc: '',
      args: [],
    );
  }

  /// `Please insert charging gun`
  String get msg_insert_charging_gun {
    return Intl.message(
      'Please insert charging gun',
      name: 'msg_insert_charging_gun',
      desc: '',
      args: [],
    );
  }

  /// `Matching failed`
  String get msg_error_match {
    return Intl.message(
      'Matching failed',
      name: 'msg_error_match',
      desc: '',
      args: [],
    );
  }

  /// `Connection abnormality`
  String get msg_error_connect {
    return Intl.message(
      'Connection abnormality',
      name: 'msg_error_connect',
      desc: '',
      args: [],
    );
  }

  /// `Request timeout`
  String get msg_error_request_timeout {
    return Intl.message(
      'Request timeout',
      name: 'msg_error_request_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Device not connected`
  String get msg_error_unconnected {
    return Intl.message(
      'Device not connected',
      name: 'msg_error_unconnected',
      desc: '',
      args: [],
    );
  }

  /// `Please enter task name`
  String get hint_input_task_name {
    return Intl.message(
      'Please enter task name',
      name: 'hint_input_task_name',
      desc: '',
      args: [],
    );
  }

  /// `Reservation time cannot be earlier than current time`
  String get msg_error_time_task_time_low_now {
    return Intl.message(
      'Reservation time cannot be earlier than current time',
      name: 'msg_error_time_task_time_low_now',
      desc: '',
      args: [],
    );
  }

  /// `Task time already exists: {name}`
  String msg_error_time_task_time_exist(Object name) {
    return Intl.message(
      'Task time already exists: $name',
      name: 'msg_error_time_task_time_exist',
      desc: '',
      args: [name],
    );
  }

  /// `Device not found`
  String get msg_error_device_not_found {
    return Intl.message(
      'Device not found',
      name: 'msg_error_device_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Charging gun information not found`
  String get msg_error_gun_not_found {
    return Intl.message(
      'Charging gun information not found',
      name: 'msg_error_gun_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Request failed`
  String get msg_error_request_fail {
    return Intl.message(
      'Request failed',
      name: 'msg_error_request_fail',
      desc: '',
      args: [],
    );
  }

  /// `Total Power`
  String get total_charge {
    return Intl.message(
      'Total Power',
      name: 'total_charge',
      desc: '',
      args: [],
    );
  }

  /// `Total Duration`
  String get total_charge_time {
    return Intl.message(
      'Total Duration',
      name: 'total_charge_time',
      desc: '',
      args: [],
    );
  }

  /// `Charge Times`
  String get total_charge_times {
    return Intl.message(
      'Charge Times',
      name: 'total_charge_times',
      desc: '',
      args: [],
    );
  }

  /// `Times`
  String get times {
    return Intl.message(
      'Times',
      name: 'times',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get minute {
    return Intl.message(
      'Minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Modify Email`
  String get modify_email {
    return Intl.message(
      'Modify Email',
      name: 'modify_email',
      desc: '',
      args: [],
    );
  }

  /// `New Email`
  String get new_email {
    return Intl.message(
      'New Email',
      name: 'new_email',
      desc: '',
      args: [],
    );
  }

  /// `Upload success`
  String get msg_success_upload {
    return Intl.message(
      'Upload success',
      name: 'msg_success_upload',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Follow system`
  String get setting_theme_system {
    return Intl.message(
      'Follow system',
      name: 'setting_theme_system',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get setting_theme_light {
    return Intl.message(
      'Light',
      name: 'setting_theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get setting_theme_dark {
    return Intl.message(
      'Dark',
      name: 'setting_theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Follow system`
  String get setting_locale_system {
    return Intl.message(
      'Follow system',
      name: 'setting_locale_system',
      desc: '',
      args: [],
    );
  }

  /// `Simplified Chinese`
  String get setting_locale_zh_simple {
    return Intl.message(
      'Simplified Chinese',
      name: 'setting_locale_zh_simple',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get setting_locale_en {
    return Intl.message(
      'English',
      name: 'setting_locale_en',
      desc: '',
      args: [],
    );
  }

  /// `please open bluetooth`
  String get tip_open_bluetooth {
    return Intl.message(
      'please open bluetooth',
      name: 'tip_open_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location services for nearby Bluetooth searching.`
  String get tip_open_location_bluetooth {
    return Intl.message(
      'Please enable location services for nearby Bluetooth searching.',
      name: 'tip_open_location_bluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Total electric energy`
  String get total_electric_energy {
    return Intl.message(
      'Total electric energy',
      name: 'total_electric_energy',
      desc: '',
      args: [],
    );
  }

  /// `About {appName}`
  String about_app(Object appName) {
    return Intl.message(
      'About $appName',
      name: 'about_app',
      desc: '',
      args: [appName],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
