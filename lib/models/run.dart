class Run {
  final int? id;
  final String runDate;
  final int runDistance;
  final int runDuration;

  Run({
    this.id,
    required this.runDate,
    required this.runDistance,
    required this.runDuration,
  });

  factory Run.fromMap(Map<String, dynamic> map) {
    return Run(
      id: map['id'],
      runDate: map['runDate'],
      runDistance: map['runDistance'],
      runDuration: map['runDuration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'runDate': runDate,
      'runDistance': runDistance,
      'runDuration': runDuration,
    };
  }

  // Berguna saat update — buat salinan dengan field yang diubah
  Run copyWith({
    int? id,
    String? runDate,
    int? runDistance,
    int? runDuration,
  }) {
    return Run(
      id: id ?? this.id,
      runDate: runDate ?? this.runDate,
      runDistance: runDistance ?? this.runDistance,
      runDuration: runDuration ?? this.runDuration,
    );
  }
}