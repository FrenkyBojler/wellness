import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wellness_fe/vistitors/day_visitors_widget.dart';
import 'package:wellness_fe/vistitors/visitors_repository.dart';

class VisitorsWidget extends StatelessWidget {
  VisitorsWidget({super.key});

  final _repository = GetIt.instance.get<VisitorsRepository>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.7,
        child: DayVisitorsWidget());
  }
}
