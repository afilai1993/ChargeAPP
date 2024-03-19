import 'package:flutter/foundation.dart';

export 'store/user_store.dart';
export 'db/database.dart';
export 'data/po.dart';

class RepositoryConfig {
  RepositoryConfig._();

  static const httpHost =
      //kReleaseMode ? "http://121.43.34.218:8799" : "http://192.168.60.57:8799";
     // kReleaseMode ? "https://echarge.gpelec.cn:9443" : "http://192.168.60.57:8799";
     // "https://echarge.gpelec.cn:9443";
 "http://121.43.34.218:8799";
//"http://192.168.11.31:8799" ;
}
