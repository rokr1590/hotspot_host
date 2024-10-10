class ExperienceModel {
  String? message;
  ExperienceData? data;
  String? error;

  ExperienceModel({this.message, this.data, this.error});

  ExperienceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data =
        json['data'] != null ? new ExperienceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ExperienceData {
  List<Experiences>? experiences;

  ExperienceData({this.experiences});

  ExperienceData.fromJson(Map<String, dynamic> json) {
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(new Experiences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.experiences != null) {
      data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Experiences {
  int? id;
  String? name;
  String? tagline;
  String? description;
  String? imageUrl;
  String? iconUrl;

  Experiences(
      {this.id,
      this.name,
      this.tagline,
      this.description,
      this.imageUrl,
      this.iconUrl});

  Experiences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tagline = json['tagline'];
    description = json['description'];
    imageUrl = json['image_url'];
    iconUrl = json['icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tagline'] = this.tagline;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['icon_url'] = this.iconUrl;
    return data;
  }
}
