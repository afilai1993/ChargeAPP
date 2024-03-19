class ChargeStatisticsVO {
  final int chargeTimes;
  final int cumulativeTime;
  final double totalPower;

  const ChargeStatisticsVO({
    required this.chargeTimes,
    required this.cumulativeTime,
    required this.totalPower,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeStatisticsVO &&
          runtimeType == other.runtimeType &&
          chargeTimes == other.chargeTimes &&
          cumulativeTime == other.cumulativeTime &&
          totalPower == other.totalPower;

  @override
  int get hashCode =>
      chargeTimes.hashCode ^ cumulativeTime.hashCode ^ totalPower.hashCode;
}

class ChargeStatisticsByDay {
  final String date;
  final double totalPower;

  ChargeStatisticsByDay(this.date, this.totalPower);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeStatisticsByDay &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalPower == other.totalPower;

  @override
  int get hashCode => date.hashCode ^ totalPower.hashCode;
}
