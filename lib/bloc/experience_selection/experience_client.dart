import 'package:dio/dio.dart';
import 'package:hotspot_hosts/bloc/experience_selection/experience_events.dart';
import 'package:hotspot_hosts/models/experience_model.dart';
import 'package:retrofit/dio.dart';

import '../../service/api_client.dart';

class ExperienceClient {
  Future<ExperienceModel> fetchExperiences(FetchExperienceEvent event) async {
    HttpResponse response;
    var query = "";
    try {
      //query = "&lon=${event.longitude}&lat=${event.latitude}&exclude=current,hourly,minutely,alerts&units=metric";
      response = await getApi().fetchExperiences(query);
      if (response.response.statusCode == 200) {
        print("Fetched Experience Request Succesfully");
        ExperienceModel experienceModel = ExperienceModel();
        try {
          experienceModel = ExperienceModel.fromJson(response.response.data);
        } catch (e) {
          print("Error in parsing json of Experience Response ${e}");
          return ExperienceModel(error: "Error in parsing json");
        }
        return experienceModel;
      } else {
        return ExperienceModel(
            error: "Request Unsuccessful for fetching Experience Data");
      }
    } catch (error) {
      if (error is DioError) {
        if (error.response != null) {
          if (error.response!.statusCode == 401) {
            return ExperienceModel(error: "401 Error in Response DioError");
          }
          return ExperienceModel(error: "Something Went wrong DioError");
        }
      }
      return ExperienceModel();
    }
  }
}
