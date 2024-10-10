import 'package:equatable/equatable.dart';
import 'package:hotspot_hosts/models/experience_model.dart';

abstract class ExperienceState extends Equatable {
  const ExperienceState();

  @override
  List<Object> get props => [];
}

class FetchExperienceSuccess extends ExperienceState {
  final ExperienceModel response;
  const FetchExperienceSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class LoadingExperienceState extends ExperienceState {}

class ExperienceFailureState extends ExperienceState {}
