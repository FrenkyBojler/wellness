import 'package:get_it/get_it.dart';
import 'package:wellness_fe/vistitors/visitors_repository.dart';

final di = GetIt.instance;

void initDI() {
  di.registerSingleton(VisitorsRepository());
}
