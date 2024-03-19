import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/screen/household/household_home_screen.dart';

import 'business/business_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HouseholdHomeScreen();
     //return BusinessHomeScreen();
  }
}
