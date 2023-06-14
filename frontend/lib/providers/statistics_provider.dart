import 'package:flutter/material.dart';

import '../utils/api/models/statistics.dart';
import '../utils/helpers.dart';
import 'auth_provider.dart';

class StatisticsProvider extends ChangeNotifier {
  final Auth? auth;

  StatisticsProvider(this.auth);

  Statistics? todayStatistics;
  Statistics? monthStatistics;
  Statistics? yearStatistics;

  Statistics? lastFetchedStatistics;

  double? getTotalCost(String option) {
    late Statistics? stats;
    switch (option) {
      case 'TODAY':
        stats = todayStatistics;
        break;
      case 'MONTH':
        stats = monthStatistics;
        break;
      case 'YEAR':
        stats = yearStatistics;
        break;
      default:
        stats = lastFetchedStatistics;
        break;
    }

    if (stats == null) return null;

    return stats.pieChartDetails.fold(0, (sum, item) => sum! + item.value);
  }

  bool get isLoading => lastFetchedStatistics == null;

  /// Obtains the user's statistics from backend API.
  Future<void> getStatistics(DateTimeRange dateTimeRange) async {
    handleIfNotLoggedIn(auth);
    lastFetchedStatistics = null;
    final range = _processDateTimeRange(dateTimeRange);
    try {
      lastFetchedStatistics = await auth!.apiService.getStatistics(
        auth!.token!,
        dateTimeRange: range,
      );
    } catch (_) {
      throw Exception('Failed to load the statistics.');
    }
    notifyListeners();
  }

  Future<void> getTodayStatistics({bool force = false}) async {
    handleIfNotLoggedIn(auth);
    if (!force && todayStatistics != null) {
      lastFetchedStatistics = todayStatistics;
      return;
    }

    lastFetchedStatistics = null;
    final range = _processDateTimeRange(
      DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
    );

    try {
      todayStatistics = await auth!.apiService.getStatistics(
        auth!.token!,
        dateTimeRange: range,
      );
    } catch (_) {
      throw Exception('Failed to load the statistics.');
    }
    lastFetchedStatistics = todayStatistics;
    notifyListeners();
  }

  Future<void> getMonthStatistics({bool force = false}) async {
    handleIfNotLoggedIn(auth);
    if (!force && monthStatistics != null) {
      lastFetchedStatistics = monthStatistics;
      return;
    }

    lastFetchedStatistics = null;
    final range = _processDateTimeRange(
      DateTimeRange(
        start: DateTime.now().subtract(
          const Duration(days: 30),
        ),
        end: DateTime.now(),
      ),
    );

    try {
      monthStatistics = await auth!.apiService.getStatistics(
        auth!.token!,
        dateTimeRange: range,
      );
    } catch (_) {
      throw Exception('Failed to load the statistics.');
    }
    lastFetchedStatistics = monthStatistics;
    notifyListeners();
  }

  Future<void> getYearStatistics({bool force = false}) async {
    handleIfNotLoggedIn(auth);
    if (!force && yearStatistics != null) {
      lastFetchedStatistics = yearStatistics;
      return;
    }

    lastFetchedStatistics = null;
    final range = _processDateTimeRange(
      DateTimeRange(
        start: DateTime.now().subtract(
          const Duration(days: 365),
        ),
        end: DateTime.now(),
      ),
    );

    try {
      yearStatistics = await auth!.apiService.getStatistics(
        auth!.token!,
        dateTimeRange: range,
      );
    } catch (_) {
      throw Exception('Failed to load the statistics.');
    }
    lastFetchedStatistics = yearStatistics;
    notifyListeners();
  }

  void _clear() {
    todayStatistics = null;
    monthStatistics = null;
    yearStatistics = null;
    lastFetchedStatistics = null;
    notifyListeners();
  }

  Future<void> reloadStats({String option = 'LAST'}) async {
    _clear();
    switch (option) {
      case 'MONTH':
        await getMonthStatistics();
        break;
      case 'YEAR':
        await getYearStatistics();
        break;
      default:
        await getTodayStatistics();
        break;
    }
    notifyListeners();
  }

  Future<String> getReportUrl(DateTimeRange dateTimeRange) async {
    handleIfNotLoggedIn(auth);
    final range = _processDateTimeRange(dateTimeRange);
    try {
      return await auth!.apiService.getReportUrl(
        auth!.token!,
        dateTimeRange: range,
      );
    } catch (_) {
      throw Exception('Failed to load the report.');
    }
  }

  DateTimeRange _processDateTimeRange(DateTimeRange range) {
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
      0,
      0,
      0,
      0,
      0,
    );

    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
      0,
      0,
    );

    return DateTimeRange(
      start: start,
      end: end,
    );
  }
}
