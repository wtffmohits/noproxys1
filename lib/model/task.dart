class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String date;
  String startTime;
  String endTime;
  int reminderMinutes;
  String repeat;
  int color;
  String scheduleCode;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminderMinutes,
    required this.repeat,
    required this.color,
    required this.scheduleCode,
  });

  // Renamed from formJson to fromJson for consistency.
  Task.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      note = json['note'],
      isCompleted = json['isCompleted'],
      date = json['date'],
      startTime = json['startTime'],
      endTime = json['endTime'],
      reminderMinutes = json['reminderMinutes'],
      repeat = json['repeat'],
      color = json['color'],
      scheduleCode = json['scheduleCode'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['reminderMinutes'] = reminderMinutes;
    data['repeat'] = repeat;
    data['color'] = color;
    data['scheduleCode'] = scheduleCode;
    return data;
  }
}
