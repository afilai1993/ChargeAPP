import 'dart:io';

import 'package:chargestation/domain/eventbus/eventbus.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/file_extension.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

part 'impl/user_case_impl.dart';

abstract class UserCase {
  factory UserCase() => _UserCaseImpl();

  Future updateNickname(String nickname);

  ///上传头像
  Future updateAvatar(File file);

  Future logout();

  Future unregister();
}
