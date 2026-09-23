class SduiResponse {
  final SduiHeader? header;
  final List<SduiSection> sections;

  SduiResponse({this.header, required this.sections});

  factory SduiResponse.fromJson(Map<String, dynamic> json) {
    return SduiResponse(
      header: json['header'] != null ? SduiHeader.fromJson(json['header']) : null,
      sections: json['sections'] != null
          ? (json['sections'] as List).map((i) => SduiSection.fromJson(i)).toList()
          : [],
    );
  }
}

class SduiHeader {
  final String title;
  final String? subtitle;
  final String? icon;

  SduiHeader({required this.title, this.subtitle, this.icon});

  factory SduiHeader.fromJson(Map<String, dynamic> json) {
    return SduiHeader(
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      icon: json['icon'],
    );
  }
}

class SduiSection {
  final String id;
  final String title;
  final String? subtitle;
  final String type;
  final String? icon;
  final String? color;
  final SduiAction? action;

  SduiSection({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.icon,
    this.color,
    this.action,
  });

  factory SduiSection.fromJson(Map<String, dynamic> json) {
    return SduiSection(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      type: json['type'] ?? 'list_card',
      icon: json['icon'],
      color: json['color'],
      action: json['action'] != null ? SduiAction.fromJson(json['action']) : null,
    );
  }
}

class SduiAction {
  final String type;
  final String? route;
  final String? apiEndpoint;

  SduiAction({required this.type, this.route, this.apiEndpoint});

  factory SduiAction.fromJson(Map<String, dynamic> json) {
    return SduiAction(
      type: json['type'] ?? 'navigate',
      route: json['route'],
      apiEndpoint: json['api_endpoint'],
    );
  }
}
