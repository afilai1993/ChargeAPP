import 'package:chargestation/domain/data/charge_station_dto.dart';
import 'package:chargestation/repository/http_client.dart';
import 'package:chargestation/infrastructure/utils/maps.dart';

import 'data/pageable_dto.dart';

part 'impl/charge_case_impl.dart';

abstract class ChargeCase {
  factory ChargeCase() => _ChargeCaseImpl();

  Future<PageableDTO<ChargeStationItemDTO>> getChargeStationList({
    String? name,
    String? type,
    double? lng,
    double? lat,
    required int pageNum,
    int pageSize = 10,
  });
}
