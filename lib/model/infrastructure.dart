import 'dart:convert';

Infrastructure infrastructureFromMap(String str) => Infrastructure.fromMap(json.decode(str));

String infrastructureToMap(Infrastructure data) => json.encode(data.toMap());

class Infrastructure {
    InfrastructureDetails? infrastructureDetails;
    double? distance;

    Infrastructure({
        this.infrastructureDetails,
        this.distance,
    });

    factory Infrastructure.fromMap(Map<String, dynamic> json) => Infrastructure(
        infrastructureDetails: json["infrastructureDetails"] == null ? null : InfrastructureDetails.fromMap(json["infrastructureDetails"]),
        distance: json["distance"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "infrastructureDetails": infrastructureDetails?.toMap(),
        "distance": distance,
    };
}

class InfrastructureDetails {
    int? id;
    String? placeId;
    String? name;
    String? address;
    String? type; // Hospital, School, Road, Utility etc.
    List<String>? operatingHours; // Renamed from periods
    String? status; // Open, Closed, Under Construction etc.
    String? additionalInfo; // Any additional info related to infrastructure
    double? latitude;
    double? longitude;
    List<String>? categories; // Infrastructure categories e.g., health, education
    bool? isFavorite;
    dynamic infrastructureState; // Custom state info if needed

    InfrastructureDetails({
        this.id,
        this.placeId,
        this.name,
        this.address,
        this.type,
        this.operatingHours,
        this.status,
        this.additionalInfo,
        this.latitude,
        this.longitude,
        this.categories,
        this.isFavorite,
        this.infrastructureState,
    });

    factory InfrastructureDetails.fromMap(Map<String, dynamic> json) => InfrastructureDetails(
        id: json["id"],
        placeId: json["placeId"],
        name: json["name"],
        address: json["address"],
        type: json["type"],
        operatingHours: json["operatingHours"] == null ? [] : List<String>.from(json["operatingHours"]!.map((x) => x)),
        status: json["status"],
        additionalInfo: json["additionalInfo"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        categories: json["categories"] == null ? [] : List<String>.from(json["categories"]!.map((x) => x)),
        isFavorite: json["isFavorite"],
        infrastructureState: json["infrastructureState"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "placeId": placeId,
        "name": name,
        "address": address,
        "type": type,
        "operatingHours": operatingHours == null ? [] : List<dynamic>.from(operatingHours!.map((x) => x)),
        "status": status,
        "additionalInfo": additionalInfo,
        "latitude": latitude,
        "longitude": longitude,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
        "isFavorite": isFavorite,
        "infrastructureState": infrastructureState,
    };
}
