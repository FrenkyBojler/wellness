import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VisitorsRepository {
  static const tableName = 'visitors';
  final supabase = Supabase.instance.client;

  VisitorsRepository() {
    // get all items from the table with created_at matching today (no matter the time)
    _selectedDate.listen((date) async {
      if (date == null) {
        return;
      }

      // List of dates starting from selectedDate to the same day for 3 weeks ago
      const numberOfWeeks = 3;

      var dates = [];

      dates.addAll(List<DateTime>.generate(
        numberOfWeeks,
        (index) => date.subtract(Duration(days: 7 * index)),
      ));

      for (var currentDate in dates) {
        final selectedDateFrom =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        final selectedDateTo = DateTime(
            currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

        final response = await supabase
            .from(tableName)
            .select()
            .gte('created_at', selectedDateFrom.toIso8601String())
            .lte('created_at', selectedDateTo.toIso8601String());

        final visitorsPerHour = Map<DateTime, int>.from({});

        for (final visitor in response) {
          final date = DateTime.parse(visitor['created_at']);
          visitorsPerHour[date] = visitor['visitors_count'];
        }

        visitorsPerHourAtSelectedDate.add([
          ...visitorsPerHourAtSelectedDate.value,
          visitorsPerHour,
        ]);
      }
    });
  }

  final BehaviorSubject<DateTime?> _selectedDate = BehaviorSubject.seeded(null);
  Stream<DateTime?> get selectedDate => _selectedDate.stream;

  final BehaviorSubject<List<Map<DateTime, int>>>
      visitorsPerHourAtSelectedDate =
      BehaviorSubject.seeded(List<Map<DateTime, int>>.from([]));

  Stream<int> getVisitorsCount() {
    return supabase
        .from(tableName)
        .select()
        .count(CountOption.exact)
        .asStream()
        .map((response) => response.count);
  }

  void fetchVisitorsForDate(DateTime date) {
    _selectedDate.add(date);
  }
}
