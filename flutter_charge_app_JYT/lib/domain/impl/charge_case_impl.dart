part of '../charge_case.dart';

class _ChargeCaseImpl implements ChargeCase {
  @override
  Future<PageableDTO<ChargeStationItemDTO>> getChargeStationList({
    String? name,
    String? type,
    double? lng,
    double? lat,
    required int pageNum,
    int pageSize = 1,
  }) async {
    return httpClient
        .post("/charge/station/near",
            queries: {
              "name": name,
              "type": type,
              "lon": lng,
              "lat": lat,
              "pageNum": pageNum,
              "pageSize": pageSize
            }.removeNullValue())
        .then((value) =>
            PageableDTO.fromJson(value, ChargeStationItemDTO.fromJson));
  }
}
