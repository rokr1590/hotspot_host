import 'package:hotspot_hosts/bloc/experience_selection/experience_events.dart';

import '../../models/experience_model.dart';
import 'experience_client.dart';

class ExperienceRepository {
  final ExperienceClient client = ExperienceClient();

  Future<ExperienceModel> fetchExperiences(FetchExperienceEvent event) async {
    return await client.fetchExperiences(event);
  }
}
