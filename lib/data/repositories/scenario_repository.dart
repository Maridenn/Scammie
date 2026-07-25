import '../../models/scenario.dart';
import '../local/default_scenarios.dart';

class ScenarioRepository {
  List<Scenario> getAll() => defaultScenarios;

  Scenario? getById(String id) {
    for (final s in defaultScenarios) {
      if (s.id == id) return s;
    }
    return null;
  }
}
