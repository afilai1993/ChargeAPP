// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(appName) => "关于${appName}";

  static String m1(status) => "未知:${status}";

  static String m2(code) => "未知故障:${code}";

  static String m3(second) => "${second}秒";

  static String m4(name) => "任务时间已存在:${name}";

  static String m5(name) => "确定要删除${name}吗?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_app": m0,
        "about_us": MessageLookupByLibrary.simpleMessage("关于我们"),
        "add_device": MessageLookupByLibrary.simpleMessage("添加设备"),
        "add_task": MessageLookupByLibrary.simpleMessage("新增任务"),
        "agree": MessageLookupByLibrary.simpleMessage("同意"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "all_order": MessageLookupByLibrary.simpleMessage("全部订单"),
        "all_selected": MessageLookupByLibrary.simpleMessage("全选"),
        "and": MessageLookupByLibrary.simpleMessage("和"),
        "app_name": MessageLookupByLibrary.simpleMessage("abChargego"),
        "avatar": MessageLookupByLibrary.simpleMessage("头像"),
        "bind_device": MessageLookupByLibrary.simpleMessage("绑定设备"),
        "bonus_balance": MessageLookupByLibrary.simpleMessage("赠送余额"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "car_manager": MessageLookupByLibrary.simpleMessage("车辆管理"),
        "charge_current": MessageLookupByLibrary.simpleMessage("电流值"),
        "charge_energy": MessageLookupByLibrary.simpleMessage("充电功率(kw/h)"),
        "charge_mode": MessageLookupByLibrary.simpleMessage("充电模式"),
        "charge_status_any": m1,
        "charge_status_charging": MessageLookupByLibrary.simpleMessage("充电中"),
        "charge_status_code_0": MessageLookupByLibrary.simpleMessage("正常"),
        "charge_status_code_1": MessageLookupByLibrary.simpleMessage("接地故障"),
        "charge_status_code_10": MessageLookupByLibrary.simpleMessage("电子锁故障"),
        "charge_status_code_11": MessageLookupByLibrary.simpleMessage("漏电故障"),
        "charge_status_code_12": MessageLookupByLibrary.simpleMessage("电表故障"),
        "charge_status_code_13": MessageLookupByLibrary.simpleMessage("漏电保护"),
        "charge_status_code_14": MessageLookupByLibrary.simpleMessage("电表故障1"),
        "charge_status_code_15": MessageLookupByLibrary.simpleMessage("电表故障2"),
        "charge_status_code_16": MessageLookupByLibrary.simpleMessage("CP接地"),
        "charge_status_code_17": MessageLookupByLibrary.simpleMessage("接地故障"),
        "charge_status_code_2": MessageLookupByLibrary.simpleMessage("过温故障"),
        "charge_status_code_3": MessageLookupByLibrary.simpleMessage("过压故障"),
        "charge_status_code_4": MessageLookupByLibrary.simpleMessage("欠压故障"),
        "charge_status_code_5": MessageLookupByLibrary.simpleMessage("过流故障"),
        "charge_status_code_6": MessageLookupByLibrary.simpleMessage("继电器故障"),
        "charge_status_code_7": MessageLookupByLibrary.simpleMessage("cp 故障"),
        "charge_status_code_8":
            MessageLookupByLibrary.simpleMessage("漏电回路异常(自检)"),
        "charge_status_code_9": MessageLookupByLibrary.simpleMessage("急停故障"),
        "charge_status_code_any": m2,
        "charge_status_finish": MessageLookupByLibrary.simpleMessage("充电结束"),
        "charge_status_idle": MessageLookupByLibrary.simpleMessage("空闲"),
        "charge_status_other": MessageLookupByLibrary.simpleMessage("其他"),
        "charge_status_reserve": MessageLookupByLibrary.simpleMessage("预约"),
        "charge_status_safe_fault":
            MessageLookupByLibrary.simpleMessage("漏电保护"),
        "charge_status_suspend_N": MessageLookupByLibrary.simpleMessage("暂停充电"),
        "charge_status_wait": MessageLookupByLibrary.simpleMessage("就绪"),
        "charge_time": MessageLookupByLibrary.simpleMessage("充电时长"),
        "charging": MessageLookupByLibrary.simpleMessage("充电中"),
        "charging_pile": MessageLookupByLibrary.simpleMessage("充电桩"),
        "charging_statistics": MessageLookupByLibrary.simpleMessage("充电统计"),
        "confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "connect": MessageLookupByLibrary.simpleMessage("连接"),
        "connect_status_connected": MessageLookupByLibrary.simpleMessage("已连接"),
        "connect_status_connecting":
            MessageLookupByLibrary.simpleMessage("连接中"),
        "connect_status_ensure_key":
            MessageLookupByLibrary.simpleMessage("配对中"),
        "connect_status_idle": MessageLookupByLibrary.simpleMessage("未连接"),
        "count_second": m3,
        "coupon_package": MessageLookupByLibrary.simpleMessage("优惠券包"),
        "data_profile": MessageLookupByLibrary.simpleMessage("数据总览"),
        "day": MessageLookupByLibrary.simpleMessage("天"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "details_refunds": MessageLookupByLibrary.simpleMessage("明细与退款"),
        "device": MessageLookupByLibrary.simpleMessage("设备"),
        "device_sn": MessageLookupByLibrary.simpleMessage("设备编号"),
        "disconnect": MessageLookupByLibrary.simpleMessage("断开"),
        "distance_asc": MessageLookupByLibrary.simpleMessage("距离优先"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "edit_nickname": MessageLookupByLibrary.simpleMessage("编辑用户名"),
        "email": MessageLookupByLibrary.simpleMessage("邮箱"),
        "empty_data": MessageLookupByLibrary.simpleMessage("暂无数据"),
        "end_date": MessageLookupByLibrary.simpleMessage("结束日期"),
        "end_time": MessageLookupByLibrary.simpleMessage("结束时间"),
        "every_day": MessageLookupByLibrary.simpleMessage("每天"),
        "exit_account": MessageLookupByLibrary.simpleMessage("退出账户"),
        "forget_password": MessageLookupByLibrary.simpleMessage("忘记密码"),
        "frequently_used_entrances":
            MessageLookupByLibrary.simpleMessage("常用入口"),
        "friday": MessageLookupByLibrary.simpleMessage("周五"),
        "hardware_version": MessageLookupByLibrary.simpleMessage("硬件版本"),
        "hello": MessageLookupByLibrary.simpleMessage("你好"),
        "helper_center": MessageLookupByLibrary.simpleMessage("帮助中心"),
        "hint_input_device_password":
            MessageLookupByLibrary.simpleMessage("请输入设备密码"),
        "hint_input_task_name": MessageLookupByLibrary.simpleMessage("请输入任务名称"),
        "home": MessageLookupByLibrary.simpleMessage("首页"),
        "language": MessageLookupByLibrary.simpleMessage("语言"),
        "load_more_refresh_error":
            MessageLookupByLibrary.simpleMessage("刷新失败，点击重试"),
        "loading": MessageLookupByLibrary.simpleMessage("加载中"),
        "loading_complete": MessageLookupByLibrary.simpleMessage("刷新完成"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loop_date": MessageLookupByLibrary.simpleMessage("循环日期"),
        "mine": MessageLookupByLibrary.simpleMessage("我的"),
        "mine_center": MessageLookupByLibrary.simpleMessage("个人中心"),
        "minute": MessageLookupByLibrary.simpleMessage("分"),
        "modify_email": MessageLookupByLibrary.simpleMessage("修改邮箱"),
        "monday": MessageLookupByLibrary.simpleMessage("周一"),
        "month": MessageLookupByLibrary.simpleMessage("月"),
        "msg_charge_device_not_selected":
            MessageLookupByLibrary.simpleMessage("请选择充电桩"),
        "msg_confirm_logout": MessageLookupByLibrary.simpleMessage("是否要退出登录?"),
        "msg_confirm_unbind": MessageLookupByLibrary.simpleMessage("是否解绑当前设备"),
        "msg_confirm_unregister":
            MessageLookupByLibrary.simpleMessage("注销用户后，账号的所有数据都会丢失，是否继续?"),
        "msg_device_error": MessageLookupByLibrary.simpleMessage("设备出现了问题"),
        "msg_device_not_connected":
            MessageLookupByLibrary.simpleMessage("设备未连接"),
        "msg_end_time_not_selected":
            MessageLookupByLibrary.simpleMessage("请填写结束时间"),
        "msg_error_connect": MessageLookupByLibrary.simpleMessage("连接异常"),
        "msg_error_device_not_found":
            MessageLookupByLibrary.simpleMessage("找不到该设备"),
        "msg_error_gun_not_found":
            MessageLookupByLibrary.simpleMessage("找不到充电枪的信息"),
        "msg_error_input_device_key":
            MessageLookupByLibrary.simpleMessage("请填写密码"),
        "msg_error_match": MessageLookupByLibrary.simpleMessage("匹配失败"),
        "msg_error_request_fail": MessageLookupByLibrary.simpleMessage("请求失败"),
        "msg_error_request_timeout":
            MessageLookupByLibrary.simpleMessage("请求超时"),
        "msg_error_time_task_time_exist": m4,
        "msg_error_time_task_time_low_now":
            MessageLookupByLibrary.simpleMessage("预约时间不能早于现在时间"),
        "msg_error_unconnected": MessageLookupByLibrary.simpleMessage("设备未连接"),
        "msg_insert_charging_gun":
            MessageLookupByLibrary.simpleMessage("请插入充电枪"),
        "msg_not_end_date": MessageLookupByLibrary.simpleMessage("请填写结束日期"),
        "msg_not_input_task_name":
            MessageLookupByLibrary.simpleMessage("请填写任务名称"),
        "msg_not_start_date": MessageLookupByLibrary.simpleMessage("请填写开始日期"),
        "msg_start_time_not_selected":
            MessageLookupByLibrary.simpleMessage("请填写开始时间"),
        "msg_success_add": MessageLookupByLibrary.simpleMessage("添加成功"),
        "msg_success_upload": MessageLookupByLibrary.simpleMessage("上传成功"),
        "nearby": MessageLookupByLibrary.simpleMessage("附近"),
        "new_email": MessageLookupByLibrary.simpleMessage("新邮箱"),
        "new_password": MessageLookupByLibrary.simpleMessage("新密码"),
        "next_day": MessageLookupByLibrary.simpleMessage("次日"),
        "no_more": MessageLookupByLibrary.simpleMessage("没有更多了"),
        "not_refunded": MessageLookupByLibrary.simpleMessage("未退款"),
        "not_started": MessageLookupByLibrary.simpleMessage("未启动"),
        "not_support_bluetooth":
            MessageLookupByLibrary.simpleMessage("当前设备不支持蓝牙"),
        "numbering": MessageLookupByLibrary.simpleMessage("编号"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "pick_in_camera": MessageLookupByLibrary.simpleMessage("拍照"),
        "pick_in_gallery": MessageLookupByLibrary.simpleMessage("选择相册"),
        "please_login": MessageLookupByLibrary.simpleMessage("请登录"),
        "Please reinsert and unplug the charging gun": MessageLookupByLibrary.simpleMessage("请重新插拔充电枪"),
        "price_asc": MessageLookupByLibrary.simpleMessage("价格优先"),
        "privacy_policy": MessageLookupByLibrary.simpleMessage("隐私协议"),
        "profile_current": MessageLookupByLibrary.simpleMessage("电流(A)"),
        "profile_power": MessageLookupByLibrary.simpleMessage("功率(kw)"),
        "profile_total_power":
            MessageLookupByLibrary.simpleMessage("总功率(kw·H)"),
        "profile_total_time": MessageLookupByLibrary.simpleMessage("时长"),
        "profile_voltage": MessageLookupByLibrary.simpleMessage("电压(V)"),
        "pull_down_refresh": MessageLookupByLibrary.simpleMessage("下拉刷新"),
        "pull_down_release": MessageLookupByLibrary.simpleMessage("释放刷新"),
        "reboot": MessageLookupByLibrary.simpleMessage("重启"),
        "recharge": MessageLookupByLibrary.simpleMessage("充值"),
        "recharge_balance": MessageLookupByLibrary.simpleMessage("充值余额"),
        "record": MessageLookupByLibrary.simpleMessage("记录"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "refunded": MessageLookupByLibrary.simpleMessage("已退款"),
        "register": MessageLookupByLibrary.simpleMessage("注册"),
        "reminder": MessageLookupByLibrary.simpleMessage("提醒"),
        "remote_diagnosis": MessageLookupByLibrary.simpleMessage("远程诊断"),
        "request_fail": MessageLookupByLibrary.simpleMessage("请求失败"),
        "request_scan_bluetooth_permission":
            MessageLookupByLibrary.simpleMessage("为了扫描精确附近的蓝牙设备，需要获取扫描蓝牙和定位权限"),
        "request_scan_bluetooth_permission_by_ios":
            MessageLookupByLibrary.simpleMessage("为了扫描精确附近的蓝牙设备，需要获取蓝牙权限"),
        "request_success": MessageLookupByLibrary.simpleMessage("请求成功"),
        "requesting": MessageLookupByLibrary.simpleMessage("请求中"),
        "reset_password": MessageLookupByLibrary.simpleMessage("重置密码"),
        "reset_search": MessageLookupByLibrary.simpleMessage("重新搜索"),
        "retrieve": MessageLookupByLibrary.simpleMessage("获取"),
        "saturday": MessageLookupByLibrary.simpleMessage("周六"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "scan": MessageLookupByLibrary.simpleMessage("扫码"),
        "scan_device": MessageLookupByLibrary.simpleMessage("搜索设备"),
        "search_device_complete":
            MessageLookupByLibrary.simpleMessage("已完成设备搜索"),
        "searching_device": MessageLookupByLibrary.simpleMessage("正在搜索设备…"),
        "setting_locale_en": MessageLookupByLibrary.simpleMessage("英文"),
        "setting_locale_system": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "setting_locale_zh_simple":
            MessageLookupByLibrary.simpleMessage("简体中文"),
        "setting_theme_dark": MessageLookupByLibrary.simpleMessage("暗色"),
        "setting_theme_light": MessageLookupByLibrary.simpleMessage("亮色"),
        "setting_theme_system": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "software_version": MessageLookupByLibrary.simpleMessage("软件版本"),
        "start_date": MessageLookupByLibrary.simpleMessage("开始日期"),
        "start_time": MessageLookupByLibrary.simpleMessage("开始时间"),
        "success_login": MessageLookupByLibrary.simpleMessage("登录成功"),
        "success_operation": MessageLookupByLibrary.simpleMessage("操作成功"),
        "success_send": MessageLookupByLibrary.simpleMessage("发送成功"),
        "success_update": MessageLookupByLibrary.simpleMessage("更新成功"),
        "sunday": MessageLookupByLibrary.simpleMessage("周日"),
        "task": MessageLookupByLibrary.simpleMessage("任务"),
        "task_name": MessageLookupByLibrary.simpleMessage("任务名称"),
        "temperature": MessageLookupByLibrary.simpleMessage("温度"),
        "theme": MessageLookupByLibrary.simpleMessage("主题"),
        "thursday": MessageLookupByLibrary.simpleMessage("周四"),
        "time": MessageLookupByLibrary.simpleMessage("时间"),
        "times": MessageLookupByLibrary.simpleMessage("次"),
        "tip_delete_time": m5,
        "tip_open_bluetooth": MessageLookupByLibrary.simpleMessage("请打开蓝牙"),
        "tip_open_location_bluetooth":
            MessageLookupByLibrary.simpleMessage("请开启定位，以便搜索到附近的蓝牙"),
        "tip_searching_device":
            MessageLookupByLibrary.simpleMessage("请尽可能将手机贴近设备"),
        "total_charge": MessageLookupByLibrary.simpleMessage("总功率"),
        "total_charge_time": MessageLookupByLibrary.simpleMessage("总时长"),
        "total_charge_times": MessageLookupByLibrary.simpleMessage("充电次数"),
        "total_electric_energy": MessageLookupByLibrary.simpleMessage("总电量"),
        "total_power": MessageLookupByLibrary.simpleMessage("总功率"),
        "tuesday": MessageLookupByLibrary.simpleMessage("周二"),
        "unbind": MessageLookupByLibrary.simpleMessage("解绑"),
        "unregister_account": MessageLookupByLibrary.simpleMessage("注销账户"),
        "update_task": MessageLookupByLibrary.simpleMessage("编辑任务"),
        "user_agreement": MessageLookupByLibrary.simpleMessage("用户协议"),
        "user_center": MessageLookupByLibrary.simpleMessage("个人中心"),
        "user_name": MessageLookupByLibrary.simpleMessage("昵称"),
        "validate_check_agreement":
            MessageLookupByLibrary.simpleMessage("请勾选协议"),
        "validate_input_email":
            MessageLookupByLibrary.simpleMessage("请输入正确的邮箱"),
        "validate_input_password":
            MessageLookupByLibrary.simpleMessage("请输入密码"),
        "validate_input_username":
            MessageLookupByLibrary.simpleMessage("请输入正确的用户名"),
        "validate_input_verification_code":
            MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "verification": MessageLookupByLibrary.simpleMessage("验证"),
        "verification_code": MessageLookupByLibrary.simpleMessage("验证码"),
        "version": MessageLookupByLibrary.simpleMessage("版本号"),
        "wednesday": MessageLookupByLibrary.simpleMessage("周三"),
        "week": MessageLookupByLibrary.simpleMessage("周"),
        "welcome": MessageLookupByLibrary.simpleMessage("欢迎来到abChargego")
      };
}
