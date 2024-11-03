import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:wellness_fe/resources/app_colours.dart';
import 'package:wellness_fe/resources/styles.dart';
import 'package:wellness_fe/utils/utils.dart';
import 'package:wellness_fe/vistitors/visitors_repository.dart';
import 'package:fl_chart/fl_chart.dart';

class DayVisitorsWidget extends StatelessWidget {
  DayVisitorsWidget({super.key}) {
    _repository.fetchVisitorsForDate(DateTime.now());
  }

  final _repository = GetIt.instance.get<VisitorsRepository>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: _repository.selectedDate,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                DateFormat('dd. MM. yyyy').format(snapshot.data!),
                style: Styles.headerStyle().withColor(Colors.white),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        StreamBuilder(
            stream: _repository.visitorsPerHourAtSelectedDate,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final visitorsPerHour = snapshot.data;

                if (visitorsPerHour == null || visitorsPerHour.isEmpty) {
                  return const Text('No data');
                }

                return SizedBox(
                  width: 1000,
                  height: 400,
                  child: LineChart(
                    getChartData(visitorsPerHour),
                  ),
                );
              }
              return const CircularProgressIndicator();
            }),
      ],
    );
  }
}

Widget bottomTitleWidgets(double index, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.mainTextColor3,
  );
  const startHour = 6;
  const startMinute = 0;

  int currentMinute = startMinute + (index.toInt() * 5);

  final currentHour = startHour + (currentMinute / 60).floor();

  if (currentMinute % 60 == 0) {
    currentMinute = 0;
  }

  Widget text = currentMinute == 0
      ? Text(
          '$currentHour:00',
          style: style,
          textAlign: TextAlign.center,
        )
      : const SizedBox();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: AppColors.mainTextColor3,
  );

  final text = value % 10 == 0 ? value.toString() : '';
  return Text(text, style: style, textAlign: TextAlign.left);
}

LineChartData getChartData(List<Map<DateTime, int>> data) {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        );
      },
    ),
    titlesData: const FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 42,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: const Color(0xff37434d)),
    ),
    minX: 0,
    maxX: 180,
    minY: 0,
    maxY: 250,
    lineBarsData: data.reversed.mapIndexed((index, dateData) {
      return LineChartBarData(
        spots: dateData.entries
            .mapIndexed((i, e) => FlSpot(i.toDouble(), e.value.toDouble()))
            .toList(),
        isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors[index],
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: gradientColors[index]
                .map((color) => color.withOpacity(index != 0 ? 0.3 : 0.7))
                .toList(),
          ),
        ),
      );
    }).toList(),
  );
}

List<List<Color>> gradientColors = [
  [
    AppColors.contentColorYellow,
    AppColors.contentColorOrange,
  ],
  [
    AppColors.contentColorPink,
    AppColors.contentColorRed,
  ],
  [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ],
];
