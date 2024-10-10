import 'package:flutter/cupertino.dart';
import 'package:hotspot_hosts/bloc/experience_selection/experience_events.dart';
import 'package:hotspot_hosts/models/experience_model.dart';
import 'package:hotspot_hosts/utils/globals.dart';

class ExperienceSelectionViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Experiences>? _experienceList;
  ExperienceData? _experienceData;
  bool isEnabled = false;

  // List to manage the selection state of experiences
  List<bool> _selectedItems = [];

  ExperienceData? get experienceData => _experienceData;
  List<Experiences>? get experienceList => _experienceList;

  List<bool> get selectedItems => _selectedItems;

  void toggleLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void getExperiences() {
    toggleLoading();
    experienceBloc.add(FetchExperienceEvent());
    notifyListeners();
  }

  void setExperiences({required ExperienceData expData}) {
    _experienceData = expData;
    _selectedItems = List<bool>.filled(expData.experiences!.length, false);
    //toggleLoading();
    notifyListeners();
  }

  void setExperiencesList({required List<Experiences> expList}) {
    _experienceList = expList;
    toggleLoading();
    notifyListeners();
  }

  // Toggle the selection state of an item
  void toggleSelection(int index) {
    _selectedItems[index] = !_selectedItems[index];
    hasSelectedExperiences();
    print("toggleSelection function ${_selectedItems}");
    notifyListeners();
  }

  void hasSelectedExperiences() {
    if (_experienceList != null &&
        _selectedItems.isNotEmpty &&
        _selectedItems.any((value) => value == true)) {
      isEnabled = true;
    } else {
      isEnabled = false;
    }
  }
}
