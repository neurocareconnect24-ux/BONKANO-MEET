class AvailableDaysResModel {
  List<String>? available;
  List<String>? full;
  List<int>? disabledWeekdays;

  AvailableDaysResModel({
    this.available,
    this.full,
    this.disabledWeekdays,
  });

  factory AvailableDaysResModel.fromJson(Map<String, dynamic> json) => AvailableDaysResModel(
        available: json["available"] == null ? [] : List<String>.from(json["available"]!.map((x) => x)),
        full: json["full"] == null ? [] : List<String>.from(json["full"]!.map((x) => x)),
        disabledWeekdays: json["disabled_weekdays"] == null ? [] : List<int>.from(json["disabled_weekdays"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "available": available == null ? [] : List<dynamic>.from(available!.map((x) => x)),
        "full": full == null ? [] : List<dynamic>.from(full!.map((x) => x)),
        "disabled_weekdays": disabledWeekdays == null ? [] : List<dynamic>.from(disabledWeekdays!.map((x) => x)),
      };
}
