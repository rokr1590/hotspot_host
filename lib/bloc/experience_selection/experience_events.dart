import 'package:equatable/equatable.dart';

abstract class ExperienceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchExperienceEvent extends ExperienceEvent {
  @override
  String toString() => "FetchExperinceEvent : Event Invoked or Called";

  @override
  List<Object> get props => [int];
}
