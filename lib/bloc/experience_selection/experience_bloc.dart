import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotspot_hosts/bloc/experience_selection/experience_events.dart';
import 'package:hotspot_hosts/bloc/experience_selection/experience_repository.dart';
import 'package:hotspot_hosts/bloc/experience_selection/experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  final ExperienceRepository repository = ExperienceRepository();
  ExperienceBloc(ExperienceState initialState) : super(initialState);

  @override
  Stream<ExperienceState> mapEventToState(ExperienceEvent event) async* {
    if (event is FetchExperienceEvent) yield* _fetchExperiences(event);
  }

  Stream<ExperienceState> _fetchExperiences(FetchExperienceEvent event) async* {
    try {
      yield FetchExperienceSuccess(await repository.fetchExperiences(event));
    } catch (e) {
      print("ERROR IN BLOC FETCH EXPERIENCES");
      yield ExperienceFailureState();
    }
  }
}
