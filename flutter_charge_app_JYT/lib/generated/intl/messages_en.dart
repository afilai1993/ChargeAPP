// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(appName) => "About ${appName}";

  static String m1(status) => "Unknown: ${status}";

  static String m2(code) => "Unknown Fault: ${code}";

  static String m3(second) => "${second} seconds";

  static String m4(name) => "Task time already exists: ${name}";

  static String m5(name) => "Are you sure you want to delete ${name}?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_app": m0,
        "about_us": MessageLookupByLibrary.simpleMessage("About Us"),
        "add_device": MessageLookupByLibrary.simpleMessage("Add Device"),
        "add_task": MessageLookupByLibrary.simpleMessage("Add Task"),
        "agree": MessageLookupByLibrary.simpleMessage("Agree"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "all_order": MessageLookupByLibrary.simpleMessage("All Orders"),
        "all_selected": MessageLookupByLibrary.simpleMessage("Select All"),
        "and": MessageLookupByLibrary.simpleMessage("and"),
        "app_name": MessageLookupByLibrary.simpleMessage("abChargego"),
        "avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
        "bind_device": MessageLookupByLibrary.simpleMessage("Bind Device"),
        "bonus_balance": MessageLookupByLibrary.simpleMessage("Bonus Balance"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "car_manager": MessageLookupByLibrary.simpleMessage("Car Manager"),
        "charge_current": MessageLookupByLibrary.simpleMessage("Current Value"),
        "charge_energy":
            MessageLookupByLibrary.simpleMessage("Charging Power (kw·H)"),
        "charge_mode": MessageLookupByLibrary.simpleMessage("Charging Mode"),
        "charge_status_any": m1,
        "charge_status_charging":
            MessageLookupByLibrary.simpleMessage("Charging"),
        "charge_status_code_0": MessageLookupByLibrary.simpleMessage("Normal"),
        "charge_status_code_1":
            MessageLookupByLibrary.simpleMessage("Ground Fault"),
        "charge_status_code_10":
            MessageLookupByLibrary.simpleMessage("Electronic Lock Fault"),
        "charge_status_code_11":
            MessageLookupByLibrary.simpleMessage("Leakage Fault"),
        "charge_status_code_12":
            MessageLookupByLibrary.simpleMessage("Electric Meter Fault"),
        "charge_status_code_13":
            MessageLookupByLibrary.simpleMessage("Leakage Protection"),
        "charge_status_code_14":
            MessageLookupByLibrary.simpleMessage("Electric Meter Fault 1"),
        "charge_status_code_15":
            MessageLookupByLibrary.simpleMessage("Electric Meter Fault 2"),
        "charge_status_code_16":
            MessageLookupByLibrary.simpleMessage("CP Grounding"),
        "charge_status_code_17":
            MessageLookupByLibrary.simpleMessage("Ground Fault"),
        "charge_status_code_2":
            MessageLookupByLibrary.simpleMessage("Overtemperature Fault"),
        "charge_status_code_3":
            MessageLookupByLibrary.simpleMessage("Overvoltage Fault"),
        "charge_status_code_4":
            MessageLookupByLibrary.simpleMessage("Undervoltage Fault"),
        "charge_status_code_5":
            MessageLookupByLibrary.simpleMessage("Overcurrent Fault"),
        "charge_status_code_6":
            MessageLookupByLibrary.simpleMessage("Relay Fault"),
        "charge_status_code_7":
            MessageLookupByLibrary.simpleMessage("CP Fault"),
        "charge_status_code_8": MessageLookupByLibrary.simpleMessage(
            "Leakage Circuit Exception (Self-Test)"),
        "charge_status_code_9":
            MessageLookupByLibrary.simpleMessage("Emergency Stop Fault"),
        "charge_status_code_any": m2,
        "charge_status_finish":
            MessageLookupByLibrary.simpleMessage("Charging Completed"),
        "charge_status_idle": MessageLookupByLibrary.simpleMessage("Idle"),
        "charge_status_other": MessageLookupByLibrary.simpleMessage("Other"),
        "charge_status_reserve":
            MessageLookupByLibrary.simpleMessage("Reserved"),
        "charge_status_safe_fault":
            MessageLookupByLibrary.simpleMessage("Leakage Protection"),
        "charge_status_suspend_N":
            MessageLookupByLibrary.simpleMessage("Charging Suspended"),
        "charge_status_wait": MessageLookupByLibrary.simpleMessage("Ready"),
        "charge_time":
            MessageLookupByLibrary.simpleMessage("Charging Duration"),
        "charging": MessageLookupByLibrary.simpleMessage("Charging"),
        "charging_pile": MessageLookupByLibrary.simpleMessage("Charging Pile"),
        "charging_statistics":
            MessageLookupByLibrary.simpleMessage("Charging Statistics"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "connect": MessageLookupByLibrary.simpleMessage("Connect"),
        "connect_status_connected":
            MessageLookupByLibrary.simpleMessage("Connected"),
        "connect_status_connecting":
            MessageLookupByLibrary.simpleMessage("Connecting"),
        "connect_status_ensure_key":
            MessageLookupByLibrary.simpleMessage("Pairing"),
        "connect_status_idle":
            MessageLookupByLibrary.simpleMessage("Not Connected"),
        "count_second": m3,
        "coupon_package": MessageLookupByLibrary.simpleMessage("Coupon"),
        "data_profile": MessageLookupByLibrary.simpleMessage("Data Overview"),
        "day": MessageLookupByLibrary.simpleMessage("Day"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "details_refunds":
            MessageLookupByLibrary.simpleMessage("Details and Refunds"),
        "device": MessageLookupByLibrary.simpleMessage("Device"),
        "device_sn":
            MessageLookupByLibrary.simpleMessage("Device Serial Number"),
        "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
        "distance_asc":
            MessageLookupByLibrary.simpleMessage("Distance Priority"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "edit_nickname": MessageLookupByLibrary.simpleMessage("Edit Username"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "empty_data": MessageLookupByLibrary.simpleMessage("No data available"),
        "end_date": MessageLookupByLibrary.simpleMessage("End Date"),
        "end_time": MessageLookupByLibrary.simpleMessage("End Time"),
        "every_day": MessageLookupByLibrary.simpleMessage("Every Day"),
        "exit_account": MessageLookupByLibrary.simpleMessage("Exit Account"),
        "forget_password":
            MessageLookupByLibrary.simpleMessage("Forget Password"),
        "frequently_used_entrances":
            MessageLookupByLibrary.simpleMessage("Frequently Used Entrances"),
        "friday": MessageLookupByLibrary.simpleMessage("Friday"),
        "hardware_version":
            MessageLookupByLibrary.simpleMessage("Hardware Version"),
        "hello": MessageLookupByLibrary.simpleMessage("Hello"),
        "helper_center": MessageLookupByLibrary.simpleMessage("Helper Center"),
        "hint_input_device_password": MessageLookupByLibrary.simpleMessage(
            "Please enter device password"),
        "hint_input_task_name":
            MessageLookupByLibrary.simpleMessage("Please enter task name"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "load_more_refresh_error": MessageLookupByLibrary.simpleMessage(
            "Refresh failed, click to retry"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading"),
        "loading_complete":
            MessageLookupByLibrary.simpleMessage("Refresh complete"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loop_date": MessageLookupByLibrary.simpleMessage("Recurring Date"),
        "mine": MessageLookupByLibrary.simpleMessage("Mine"),
        "mine_center": MessageLookupByLibrary.simpleMessage("User Center"),
        "minute": MessageLookupByLibrary.simpleMessage("Minute"),
        "modify_email": MessageLookupByLibrary.simpleMessage("Modify Email"),
        "monday": MessageLookupByLibrary.simpleMessage("Monday"),
        "month": MessageLookupByLibrary.simpleMessage("Month"),
        "msg_charge_device_not_selected":
            MessageLookupByLibrary.simpleMessage("Please select charging pile"),
        "msg_confirm_logout":
            MessageLookupByLibrary.simpleMessage("Do you want to log out?"),
        "msg_confirm_unbind": MessageLookupByLibrary.simpleMessage(
            "Do you want to unbind the current device?"),
        "msg_confirm_unregister": MessageLookupByLibrary.simpleMessage(
            "After unregistering, all data of the account will be lost. Do you want to continue?"),
        "msg_device_error": MessageLookupByLibrary.simpleMessage(
            "Device encountered a problem"),
        "msg_device_not_connected":
            MessageLookupByLibrary.simpleMessage("Device not connected"),
        "msg_end_time_not_selected":
            MessageLookupByLibrary.simpleMessage("Please fill in end time"),
        "msg_error_connect":
            MessageLookupByLibrary.simpleMessage("Connection abnormality"),
        "msg_error_device_not_found":
            MessageLookupByLibrary.simpleMessage("Device not found"),
        "msg_error_gun_not_found": MessageLookupByLibrary.simpleMessage(
            "Charging gun information not found"),
        "msg_error_input_device_key":
            MessageLookupByLibrary.simpleMessage("Please fill in the password"),
        "msg_error_match":
            MessageLookupByLibrary.simpleMessage("Matching failed"),
        "msg_error_request_fail":
            MessageLookupByLibrary.simpleMessage("Request failed"),
        "msg_error_request_timeout":
            MessageLookupByLibrary.simpleMessage("Request timeout"),
        "msg_error_time_task_time_exist": m4,
        "msg_error_time_task_time_low_now":
            MessageLookupByLibrary.simpleMessage(
                "Reservation time cannot be earlier than current time"),
        "msg_error_unconnected":
            MessageLookupByLibrary.simpleMessage("Device not connected"),
        "msg_insert_charging_gun":
            MessageLookupByLibrary.simpleMessage("Please insert charging gun"),
        "msg_not_end_date":
            MessageLookupByLibrary.simpleMessage("Please fill in end date"),
        "msg_not_input_task_name":
            MessageLookupByLibrary.simpleMessage("Please fill in task name"),
        "msg_not_start_date":
            MessageLookupByLibrary.simpleMessage("Please fill in start date"),
        "msg_start_time_not_selected":
            MessageLookupByLibrary.simpleMessage("Please fill in start time"),
        "msg_success_add":
            MessageLookupByLibrary.simpleMessage("Add successful"),
        "msg_success_upload":
            MessageLookupByLibrary.simpleMessage("Upload success"),
        "nearby": MessageLookupByLibrary.simpleMessage("Nearby"),
        "new_email": MessageLookupByLibrary.simpleMessage("New Email"),
        "new_password": MessageLookupByLibrary.simpleMessage("New Password"),
        "next_day": MessageLookupByLibrary.simpleMessage("Next Day"),
        "no_more": MessageLookupByLibrary.simpleMessage("No more data"),
        "not_refunded": MessageLookupByLibrary.simpleMessage("Not Refunded"),
        "not_started": MessageLookupByLibrary.simpleMessage("Not Started"),
        "not_support_bluetooth": MessageLookupByLibrary.simpleMessage(
            "Current device does not support Bluetooth"),
        "numbering": MessageLookupByLibrary.simpleMessage("Numbering"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "pick_in_camera": MessageLookupByLibrary.simpleMessage("Take a Photo"),
        "pick_in_gallery":
            MessageLookupByLibrary.simpleMessage("Pick in Gallery"),
        "please_login": MessageLookupByLibrary.simpleMessage("Please login"),
        "price_asc": MessageLookupByLibrary.simpleMessage("Price Priority"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "profile_current": MessageLookupByLibrary.simpleMessage("Current (A)"),
        "profile_power": MessageLookupByLibrary.simpleMessage("Power (kW)"),
        "profile_total_power":
            MessageLookupByLibrary.simpleMessage("Total Power (kw·H)"),
        "profile_total_time": MessageLookupByLibrary.simpleMessage("Duration"),
        "profile_voltage": MessageLookupByLibrary.simpleMessage("Voltage (V)"),
        "pull_down_refresh":
            MessageLookupByLibrary.simpleMessage("Pull down to refresh"),
        "pull_down_release":
            MessageLookupByLibrary.simpleMessage("Release to refresh"),
        "reboot": MessageLookupByLibrary.simpleMessage("Reboot"),
        "recharge": MessageLookupByLibrary.simpleMessage("Recharge"),
        "recharge_balance":
            MessageLookupByLibrary.simpleMessage("Recharge Balance"),
        "record": MessageLookupByLibrary.simpleMessage("Record"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "refunded": MessageLookupByLibrary.simpleMessage("Refunded"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
        "remote_diagnosis":
            MessageLookupByLibrary.simpleMessage("Remote Diagnosis"),
        "request_fail": MessageLookupByLibrary.simpleMessage("Request failed"),
        "request_scan_bluetooth_permission": MessageLookupByLibrary.simpleMessage(
            "To accurately scan nearby Bluetooth devices, permission to scan Bluetooth and location is required"),
        "request_scan_bluetooth_permission_by_ios":
            MessageLookupByLibrary.simpleMessage(
                "To accurately scan nearby Bluetooth devices, permission to Bluetooth is required"),
        "request_success":
            MessageLookupByLibrary.simpleMessage("Request successful"),
        "requesting": MessageLookupByLibrary.simpleMessage("Requesting"),
        "reset_password":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "reset_search": MessageLookupByLibrary.simpleMessage("Reset search"),
        "retrieve": MessageLookupByLibrary.simpleMessage("Retrieve"),
        "saturday": MessageLookupByLibrary.simpleMessage("Saturday"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "scan": MessageLookupByLibrary.simpleMessage("Scan"),
        "scan_device": MessageLookupByLibrary.simpleMessage("Scan for Devices"),
        "search_device_complete":
            MessageLookupByLibrary.simpleMessage("Device search completed"),
        "searching_device":
            MessageLookupByLibrary.simpleMessage("Searching for devices..."),
        "setting_locale_en": MessageLookupByLibrary.simpleMessage("English"),
        "setting_locale_system":
            MessageLookupByLibrary.simpleMessage("Follow system"),
        "setting_locale_zh_simple":
            MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
        "setting_theme_dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "setting_theme_light": MessageLookupByLibrary.simpleMessage("Light"),
        "setting_theme_system":
            MessageLookupByLibrary.simpleMessage("Follow system"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "software_version":
            MessageLookupByLibrary.simpleMessage("Software Version"),
        "start_date": MessageLookupByLibrary.simpleMessage("Start Date"),
        "start_time": MessageLookupByLibrary.simpleMessage("Start Time"),
        "success_login":
            MessageLookupByLibrary.simpleMessage("Login successful"),
        "success_operation":
            MessageLookupByLibrary.simpleMessage("Operation successful"),
        "success_send": MessageLookupByLibrary.simpleMessage("Send successful"),
        "success_update":
            MessageLookupByLibrary.simpleMessage("Update successful"),
        "sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "task": MessageLookupByLibrary.simpleMessage("Task"),
        "task_name": MessageLookupByLibrary.simpleMessage("Task Name"),
        "temperature": MessageLookupByLibrary.simpleMessage("Temperature"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "thursday": MessageLookupByLibrary.simpleMessage("Thursday"),
        "time": MessageLookupByLibrary.simpleMessage("Time"),
        "times": MessageLookupByLibrary.simpleMessage("Times"),
        "tip_delete_time": m5,
        "tip_open_bluetooth":
            MessageLookupByLibrary.simpleMessage("please open bluetooth"),
        "tip_open_location_bluetooth": MessageLookupByLibrary.simpleMessage(
            "Please enable location services for nearby Bluetooth searching."),
        "tip_searching_device": MessageLookupByLibrary.simpleMessage(
            "Please keep the phone close to the device if possible"),
        "total_charge": MessageLookupByLibrary.simpleMessage("Total Power"),
        "total_charge_time":
            MessageLookupByLibrary.simpleMessage("Total Duration"),
        "total_charge_times":
            MessageLookupByLibrary.simpleMessage("Charge Times"),
        "total_electric_energy":
            MessageLookupByLibrary.simpleMessage("Total electric energy"),
        "total_power": MessageLookupByLibrary.simpleMessage("Total Power"),
        "tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "unbind": MessageLookupByLibrary.simpleMessage("Unbind"),
        "unregister_account":
            MessageLookupByLibrary.simpleMessage("Unregister Account"),
        "update_task": MessageLookupByLibrary.simpleMessage("Edit Task"),
        "user_agreement":
            MessageLookupByLibrary.simpleMessage("User Agreement"),
        "user_center": MessageLookupByLibrary.simpleMessage("User Center"),
        "user_name": MessageLookupByLibrary.simpleMessage("Nickname"),
        "validate_check_agreement":
            MessageLookupByLibrary.simpleMessage("Please check the agreement"),
        "validate_input_email":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "validate_input_password":
            MessageLookupByLibrary.simpleMessage("Please enter a password"),
        "validate_input_username": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid username"),
        "validate_input_verification_code":
            MessageLookupByLibrary.simpleMessage(
                "Please enter the verification code"),
        "verification": MessageLookupByLibrary.simpleMessage("Verification"),
        "verification_code":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "wednesday": MessageLookupByLibrary.simpleMessage("Wednesday"),
        "week": MessageLookupByLibrary.simpleMessage("Week"),
        "welcome":
            MessageLookupByLibrary.simpleMessage("Welcome to the abChargego")
      };
}
