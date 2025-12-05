import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  final String id;
  final String name;
  final String nameRu;
  final String nameKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String logoUrl;
  final String coverImageUrl;
  final String location;
  final String city;
  final String website;
  final String email;
  final String phone;
  final double rating;
  final int studentCount;
  final DateTime foundedDate;
  final List<String> images;
  final Mission mission;
  final History history;
  final Leadership leadership;
  final List<Achievement> achievements;
  final List<AcademicProgram> academicPrograms;
  final InternationalCooperation internationalCooperation;
  final Admission admission;
  final String? tour3dUrl;
  final String universityType;
  final double? latitude;
  final double? longitude;
  final String? googleMapsPlaceId;

  University({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.location,
    required this.city,
    required this.website,
    required this.email,
    required this.phone,
    required this.rating,
    required this.studentCount,
    required this.foundedDate,
    required this.images,
    required this.mission,
    required this.history,
    required this.leadership,
    required this.achievements,
    required this.academicPrograms,
    required this.internationalCooperation,
    required this.admission,
    this.tour3dUrl,
    String? universityType,
    this.latitude,
    this.longitude,
    this.googleMapsPlaceId,
  }) : universityType = universityType ?? 'comprehensive';

  factory University.fromMap(String id, Map<String, dynamic> map) {
    return University(
      id: id,
      name: map['name'] ?? '',
      nameRu: map['nameRu'] ?? '',
      nameKz: map['nameKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      coverImageUrl: map['coverImageUrl'] ?? '',
      location: map['location'] ?? '',
      city: map['city'] ?? '',
      website: map['website'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      studentCount: map['studentCount'] ?? 0,
      foundedDate: map['foundedDate'] != null
          ? (map['foundedDate'] as Timestamp).toDate()
          : DateTime.now(),
      images: List<String>.from(map['images'] ?? []),
      mission: Mission.fromMap(map['mission'] ?? {}),
      history: History.fromMap(map['history'] ?? {}),
      leadership: Leadership.fromMap(map['leadership'] ?? {}),
      achievements: (map['achievements'] as List<dynamic>?)
              ?.map((e) => Achievement.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      academicPrograms: (map['academicPrograms'] as List<dynamic>?)
              ?.map((e) => AcademicProgram.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      internationalCooperation:
          InternationalCooperation.fromMap(map['internationalCooperation'] ?? {}),
      admission: Admission.fromMap(map['admission'] ?? {}),
      tour3dUrl: map['tour3dUrl'],
      universityType: map['universityType'],
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      googleMapsPlaceId: map['googleMapsPlaceId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameRu': nameRu,
      'nameKz': nameKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'logoUrl': logoUrl,
      'coverImageUrl': coverImageUrl,
      'location': location,
      'city': city,
      'website': website,
      'email': email,
      'phone': phone,
      'rating': rating,
      'studentCount': studentCount,
      'foundedDate': Timestamp.fromDate(foundedDate),
      'images': images,
      'mission': mission.toMap(),
      'history': history.toMap(),
      'leadership': leadership.toMap(),
      'achievements': achievements.map((e) => e.toMap()).toList(),
      'academicPrograms': academicPrograms.map((e) => e.toMap()).toList(),
      'internationalCooperation': internationalCooperation.toMap(),
      'admission': admission.toMap(),
      'tour3dUrl': tour3dUrl,
      'universityType': universityType,
      'latitude': latitude,
      'longitude': longitude,
      'googleMapsPlaceId': googleMapsPlaceId,
    };
  }
}

class Mission {
  final String text;
  final String textRu;
  final String textKz;
  final String vision;
  final String visionRu;
  final String visionKz;
  final List<String> values;
  final List<String> valuesRu;
  final List<String> valuesKz;

  Mission({
    required this.text,
    required this.textRu,
    required this.textKz,
    required this.vision,
    required this.visionRu,
    required this.visionKz,
    required this.values,
    required this.valuesRu,
    required this.valuesKz,
  });

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      text: map['text'] ?? '',
      textRu: map['textRu'] ?? '',
      textKz: map['textKz'] ?? '',
      vision: map['vision'] ?? '',
      visionRu: map['visionRu'] ?? '',
      visionKz: map['visionKz'] ?? '',
      values: List<String>.from(map['values'] ?? []),
      valuesRu: List<String>.from(map['valuesRu'] ?? []),
      valuesKz: List<String>.from(map['valuesKz'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'textRu': textRu,
      'textKz': textKz,
      'vision': vision,
      'visionRu': visionRu,
      'visionKz': visionKz,
      'values': values,
      'valuesRu': valuesRu,
      'valuesKz': valuesKz,
    };
  }
}

class History {
  final String text;
  final String textRu;
  final String textKz;
  final List<HistoryEvent> events;

  History({
    required this.text,
    required this.textRu,
    required this.textKz,
    required this.events,
  });

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      text: map['text'] ?? '',
      textRu: map['textRu'] ?? '',
      textKz: map['textKz'] ?? '',
      events: (map['events'] as List<dynamic>?)
              ?.map((e) => HistoryEvent.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'textRu': textRu,
      'textKz': textKz,
      'events': events.map((e) => e.toMap()).toList(),
    };
  }
}

class HistoryEvent {
  final int year;
  final String description;
  final String descriptionRu;
  final String descriptionKz;

  HistoryEvent({
    required this.year,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
  });

  factory HistoryEvent.fromMap(Map<String, dynamic> map) {
    return HistoryEvent(
      year: map['year'] ?? 0,
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
    };
  }
}

class Leadership {
  final String rectorName;
  final String rectorNameRu;
  final String rectorNameKz;
  final String rectorBio;
  final String rectorBioRu;
  final String rectorBioKz;
  final String rectorPhotoUrl;
  final List<Leader> leaders;

  Leadership({
    required this.rectorName,
    required this.rectorNameRu,
    required this.rectorNameKz,
    required this.rectorBio,
    required this.rectorBioRu,
    required this.rectorBioKz,
    required this.rectorPhotoUrl,
    required this.leaders,
  });

  factory Leadership.fromMap(Map<String, dynamic> map) {
    return Leadership(
      rectorName: map['rectorName'] ?? '',
      rectorNameRu: map['rectorNameRu'] ?? '',
      rectorNameKz: map['rectorNameKz'] ?? '',
      rectorBio: map['rectorBio'] ?? '',
      rectorBioRu: map['rectorBioRu'] ?? '',
      rectorBioKz: map['rectorBioKz'] ?? '',
      rectorPhotoUrl: map['rectorPhotoUrl'] ?? '',
      leaders: (map['leaders'] as List<dynamic>?)
              ?.map((e) => Leader.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rectorName': rectorName,
      'rectorNameRu': rectorNameRu,
      'rectorNameKz': rectorNameKz,
      'rectorBio': rectorBio,
      'rectorBioRu': rectorBioRu,
      'rectorBioKz': rectorBioKz,
      'rectorPhotoUrl': rectorPhotoUrl,
      'leaders': leaders.map((e) => e.toMap()).toList(),
    };
  }
}

class Leader {
  final String name;
  final String nameRu;
  final String nameKz;
  final String position;
  final String positionRu;
  final String positionKz;
  final String bio;
  final String bioRu;
  final String bioKz;
  final String photoUrl;

  Leader({
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.position,
    required this.positionRu,
    required this.positionKz,
    required this.bio,
    required this.bioRu,
    required this.bioKz,
    required this.photoUrl,
  });

  factory Leader.fromMap(Map<String, dynamic> map) {
    return Leader(
      name: map['name'] ?? '',
      nameRu: map['nameRu'] ?? '',
      nameKz: map['nameKz'] ?? '',
      position: map['position'] ?? '',
      positionRu: map['positionRu'] ?? '',
      positionKz: map['positionKz'] ?? '',
      bio: map['bio'] ?? '',
      bioRu: map['bioRu'] ?? '',
      bioKz: map['bioKz'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameRu': nameRu,
      'nameKz': nameKz,
      'position': position,
      'positionRu': positionRu,
      'positionKz': positionKz,
      'bio': bio,
      'bioRu': bioRu,
      'bioKz': bioKz,
      'photoUrl': photoUrl,
    };
  }
}

class Achievement {
  final String id;
  final String title;
  final String titleRu;
  final String titleKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String imageUrl;
  final DateTime date;

  Achievement({
    required this.id,
    required this.title,
    required this.titleRu,
    required this.titleKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.imageUrl,
    required this.date,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      titleRu: map['titleRu'] ?? '',
      titleKz: map['titleKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleRu': titleRu,
      'titleKz': titleKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
    };
  }
}

class AcademicProgram {
  final String id;
  final String name;
  final String nameRu;
  final String nameKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String degree;
  final String degreeRu;
  final String degreeKz;
  final String faculty;
  final String facultyRu;
  final String facultyKz;
  final int duration;
  final String language;
  final String languageRu;
  final String languageKz;
  final double tuitionFee;
  final String currency;
  final List<String> requirements;
  final List<String> requirementsRu;
  final List<String> requirementsKz;
  final List<String> careerOpportunities;
  final List<String> careerOpportunitiesRu;
  final List<String> careerOpportunitiesKz;
  final String imageUrl;
  final String programCategory;

  AcademicProgram({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.degree,
    required this.degreeRu,
    required this.degreeKz,
    required this.faculty,
    required this.facultyRu,
    required this.facultyKz,
    required this.duration,
    required this.language,
    required this.languageRu,
    required this.languageKz,
    required this.tuitionFee,
    required this.currency,
    required this.requirements,
    required this.requirementsRu,
    required this.requirementsKz,
    required this.careerOpportunities,
    required this.careerOpportunitiesRu,
    required this.careerOpportunitiesKz,
    required this.imageUrl,
    String? programCategory,
  }) : programCategory = programCategory ?? 'general';

  factory AcademicProgram.fromMap(Map<String, dynamic> map) {
    return AcademicProgram(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameRu: map['nameRu'] ?? '',
      nameKz: map['nameKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      degree: map['degree'] ?? '',
      degreeRu: map['degreeRu'] ?? '',
      degreeKz: map['degreeKz'] ?? '',
      faculty: map['faculty'] ?? '',
      facultyRu: map['facultyRu'] ?? '',
      facultyKz: map['facultyKz'] ?? '',
      duration: map['duration'] ?? 0,
      language: map['language'] ?? '',
      languageRu: map['languageRu'] ?? '',
      languageKz: map['languageKz'] ?? '',
      tuitionFee: (map['tuitionFee'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'KZT',
      requirements: List<String>.from(map['requirements'] ?? []),
      requirementsRu: List<String>.from(map['requirementsRu'] ?? []),
      requirementsKz: List<String>.from(map['requirementsKz'] ?? []),
      careerOpportunities: List<String>.from(map['careerOpportunities'] ?? []),
      careerOpportunitiesRu:
          List<String>.from(map['careerOpportunitiesRu'] ?? []),
      careerOpportunitiesKz:
          List<String>.from(map['careerOpportunitiesKz'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
      programCategory: map['programCategory'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameRu': nameRu,
      'nameKz': nameKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'degree': degree,
      'degreeRu': degreeRu,
      'degreeKz': degreeKz,
      'faculty': faculty,
      'facultyRu': facultyRu,
      'facultyKz': facultyKz,
      'duration': duration,
      'language': language,
      'languageRu': languageRu,
      'languageKz': languageKz,
      'tuitionFee': tuitionFee,
      'currency': currency,
      'requirements': requirements,
      'requirementsRu': requirementsRu,
      'requirementsKz': requirementsKz,
      'careerOpportunities': careerOpportunities,
      'careerOpportunitiesRu': careerOpportunitiesRu,
      'careerOpportunitiesKz': careerOpportunitiesKz,
      'imageUrl': imageUrl,
      'programCategory': programCategory,
    };
  }
}

class InternationalCooperation {
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final List<ExchangeProgram> exchangePrograms;
  final List<PartnerUniversity> partnerUniversities;
  final List<Opportunity> opportunities;

  InternationalCooperation({
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.exchangePrograms,
    required this.partnerUniversities,
    required this.opportunities,
  });

  factory InternationalCooperation.fromMap(Map<String, dynamic> map) {
    return InternationalCooperation(
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      exchangePrograms: (map['exchangePrograms'] as List<dynamic>?)
              ?.map((e) =>
                  ExchangeProgram.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      partnerUniversities: (map['partnerUniversities'] as List<dynamic>?)
              ?.map((e) =>
                  PartnerUniversity.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      opportunities: (map['opportunities'] as List<dynamic>?)
              ?.map((e) => Opportunity.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'exchangePrograms':
          exchangePrograms.map((e) => e.toMap()).toList(),
      'partnerUniversities':
          partnerUniversities.map((e) => e.toMap()).toList(),
      'opportunities': opportunities.map((e) => e.toMap()).toList(),
    };
  }
}

class ExchangeProgram {
  final String id;
  final String name;
  final String nameRu;
  final String nameKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String country;
  final String duration;
  final String requirements;
  final String requirementsRu;
  final String requirementsKz;

  ExchangeProgram({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.country,
    required this.duration,
    required this.requirements,
    required this.requirementsRu,
    required this.requirementsKz,
  });

  factory ExchangeProgram.fromMap(Map<String, dynamic> map) {
    return ExchangeProgram(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameRu: map['nameRu'] ?? '',
      nameKz: map['nameKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      country: map['country'] ?? '',
      duration: map['duration'] ?? '',
      requirements: map['requirements'] ?? '',
      requirementsRu: map['requirementsRu'] ?? '',
      requirementsKz: map['requirementsKz'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameRu': nameRu,
      'nameKz': nameKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'country': country,
      'duration': duration,
      'requirements': requirements,
      'requirementsRu': requirementsRu,
      'requirementsKz': requirementsKz,
    };
  }
}

class PartnerUniversity {
  final String id;
  final String name;
  final String country;
  final String logoUrl;
  final String website;
  final String description;
  final String descriptionRu;
  final String descriptionKz;

  PartnerUniversity({
    required this.id,
    required this.name,
    required this.country,
    required this.logoUrl,
    required this.website,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
  });

  factory PartnerUniversity.fromMap(Map<String, dynamic> map) {
    return PartnerUniversity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      website: map['website'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'logoUrl': logoUrl,
      'website': website,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
    };
  }
}

class Opportunity {
  final String id;
  final String title;
  final String titleRu;
  final String titleKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String type;

  Opportunity({
    required this.id,
    required this.title,
    required this.titleRu,
    required this.titleKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.type,
  });

  factory Opportunity.fromMap(Map<String, dynamic> map) {
    return Opportunity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      titleRu: map['titleRu'] ?? '',
      titleKz: map['titleKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleRu': titleRu,
      'titleKz': titleKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'type': type,
    };
  }
}

class Admission {
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final List<Requirement> requirements;
  final List<ApplicationProcedure> procedures;
  final List<Deadline> deadlines;
  final List<Scholarship> scholarships;
  final FinancialAid financialAid;

  Admission({
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.requirements,
    required this.procedures,
    required this.deadlines,
    required this.scholarships,
    required this.financialAid,
  });

  factory Admission.fromMap(Map<String, dynamic> map) {
    return Admission(
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      requirements: (map['requirements'] as List<dynamic>?)
              ?.map((e) => Requirement.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      procedures: (map['procedures'] as List<dynamic>?)
              ?.map((e) =>
                  ApplicationProcedure.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      deadlines: (map['deadlines'] as List<dynamic>?)
              ?.map((e) => Deadline.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      scholarships: (map['scholarships'] as List<dynamic>?)
              ?.map((e) => Scholarship.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      financialAid: FinancialAid.fromMap(map['financialAid'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'requirements': requirements.map((e) => e.toMap()).toList(),
      'procedures': procedures.map((e) => e.toMap()).toList(),
      'deadlines': deadlines.map((e) => e.toMap()).toList(),
      'scholarships': scholarships.map((e) => e.toMap()).toList(),
      'financialAid': financialAid.toMap(),
    };
  }
}

class Requirement {
  final String id;
  final String title;
  final String titleRu;
  final String titleKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final String type;

  Requirement({
    required this.id,
    required this.title,
    required this.titleRu,
    required this.titleKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.type,
  });

  factory Requirement.fromMap(Map<String, dynamic> map) {
    return Requirement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      titleRu: map['titleRu'] ?? '',
      titleKz: map['titleKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'titleRu': titleRu,
      'titleKz': titleKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'type': type,
    };
  }
}

class ApplicationProcedure {
  final int step;
  final String title;
  final String titleRu;
  final String titleKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;

  ApplicationProcedure({
    required this.step,
    required this.title,
    required this.titleRu,
    required this.titleKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
  });

  factory ApplicationProcedure.fromMap(Map<String, dynamic> map) {
    return ApplicationProcedure(
      step: map['step'] ?? 0,
      title: map['title'] ?? '',
      titleRu: map['titleRu'] ?? '',
      titleKz: map['titleKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'step': step,
      'title': title,
      'titleRu': titleRu,
      'titleKz': titleKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
    };
  }
}

class Deadline {
  final String id;
  final String program;
  final String programRu;
  final String programKz;
  final DateTime deadline;
  final String type;

  Deadline({
    required this.id,
    required this.program,
    required this.programRu,
    required this.programKz,
    required this.deadline,
    required this.type,
  });

  factory Deadline.fromMap(Map<String, dynamic> map) {
    return Deadline(
      id: map['id'] ?? '',
      program: map['program'] ?? '',
      programRu: map['programRu'] ?? '',
      programKz: map['programKz'] ?? '',
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : DateTime.now(),
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'program': program,
      'programRu': programRu,
      'programKz': programKz,
      'deadline': Timestamp.fromDate(deadline),
      'type': type,
    };
  }
}

class Scholarship {
  final String id;
  final String name;
  final String nameRu;
  final String nameKz;
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final double amount;
  final String currency;
  final String coverage;
  final String coverageRu;
  final String coverageKz;
  final List<String> requirements;
  final List<String> requirementsRu;
  final List<String> requirementsKz;

  Scholarship({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameKz,
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.amount,
    required this.currency,
    required this.coverage,
    required this.coverageRu,
    required this.coverageKz,
    required this.requirements,
    required this.requirementsRu,
    required this.requirementsKz,
  });

  factory Scholarship.fromMap(Map<String, dynamic> map) {
    return Scholarship(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameRu: map['nameRu'] ?? '',
      nameKz: map['nameKz'] ?? '',
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'KZT',
      coverage: map['coverage'] ?? '',
      coverageRu: map['coverageRu'] ?? '',
      coverageKz: map['coverageKz'] ?? '',
      requirements: List<String>.from(map['requirements'] ?? []),
      requirementsRu: List<String>.from(map['requirementsRu'] ?? []),
      requirementsKz: List<String>.from(map['requirementsKz'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameRu': nameRu,
      'nameKz': nameKz,
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'amount': amount,
      'currency': currency,
      'coverage': coverage,
      'coverageRu': coverageRu,
      'coverageKz': coverageKz,
      'requirements': requirements,
      'requirementsRu': requirementsRu,
      'requirementsKz': requirementsKz,
    };
  }
}

class FinancialAid {
  final String description;
  final String descriptionRu;
  final String descriptionKz;
  final List<String> options;
  final List<String> optionsRu;
  final List<String> optionsKz;

  FinancialAid({
    required this.description,
    required this.descriptionRu,
    required this.descriptionKz,
    required this.options,
    required this.optionsRu,
    required this.optionsKz,
  });

  factory FinancialAid.fromMap(Map<String, dynamic> map) {
    return FinancialAid(
      description: map['description'] ?? '',
      descriptionRu: map['descriptionRu'] ?? '',
      descriptionKz: map['descriptionKz'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      optionsRu: List<String>.from(map['optionsRu'] ?? []),
      optionsKz: List<String>.from(map['optionsKz'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'descriptionRu': descriptionRu,
      'descriptionKz': descriptionKz,
      'options': options,
      'optionsRu': optionsRu,
      'optionsKz': optionsKz,
    };
  }
}

