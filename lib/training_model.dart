class Training {
  String title;
  String date;
  String time;
  String location;
  String status;
  String trainer;
  String trainerDesignation;
  String imageUrl;

  Training(
      {required this.title,
      required this.date,
      required this.time,
      required this.location,
      required this.status,
      required this.trainer,
      required this.trainerDesignation,
      required this.imageUrl});

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      title: json['title'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      status: json['status'],
      trainer: json['trainer'],
      trainerDesignation: json['trainer_designation'],
      imageUrl: json['imageUrl']
    );
  }
}
