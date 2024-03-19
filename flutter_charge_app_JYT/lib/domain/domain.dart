import 'household_device_case.dart';
import 'login_case.dart';
import 'email_case.dart';
import 'security_case.dart';
import 'user_case.dart';
import 'charge_case.dart';
export 'login_case.dart';
export 'email_case.dart';
export 'security_case.dart';
export 'user_case.dart';
export 'charge_case.dart';
export 'data/charge_station_dto.dart';
export 'data/pageable_dto.dart';
export 'household_device_case.dart';
export 'data/vo.dart';
typedef _CaseCreator = dynamic Function();

final Map<Type, _CaseCreator> creatorMap = {
  LoginCase: () => LoginCase(),
  EmailCase: () => EmailCase(),
  SecurityCase: () => SecurityCase(),
  UserCase: () => UserCase(),
  ChargeCase: () => ChargeCase(),
  HouseholdDeviceCase: () => HouseholdDeviceCase(),
};

final Map<Type, dynamic> _cache = {};

T findCase<T>() {
  final cache = _cache[T];
  if (cache != null) {
    return cache;
  }
  final created = creatorMap[T]!();
  _cache[T] = created;
  return created;
}
