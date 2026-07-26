import '../../models/scenario.dart';
import '../scenarios/failed_delivery.dart';
import '../scenarios/message_with_it.dart';
import '../scenarios/telegram_job.dart';

class ScenarioRepository {
  List<Scenario> getAll() => const [
    messageWithIt,
    failedDelivery,
    telegramJob,
  ];

  Scenario? getById(String id) {
    for (final s in getAll()) {
      if (s.id == id) return s;
    }
    return null;
  }
}
