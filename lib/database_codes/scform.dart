import 'package:flutter/material.dart';

class LectureScheduleForm extends StatefulWidget {
  @override
  _LectureScheduleFormState createState() => _LectureScheduleFormState();
}

class _LectureScheduleFormState extends State<LectureScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers or variables for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _reminderMinutesController =
      TextEditingController();
  String _repeat = 'None';
  int _color = 0;
  final TextEditingController _scheduleCodeController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _batchOrDivisionController =
      TextEditingController();
  bool _isCompleted = false;

  final List<String> _repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly'];

  Color getColorFromNumber(int number) {
    // Just example colors, map numbers to Colors here
    switch (number) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      _dateController.text = pickedDate.toIso8601String().split('T').first;
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      controller.text = formattedTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _reminderMinutesController.dispose();
    _scheduleCodeController.dispose();
    _staffIdController.dispose();
    _subjectController.dispose();
    _batchOrDivisionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lecture Schedule Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter title'
                            : null,
              ),
              SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Note'),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Date picker
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (yyyy-mm-dd) *',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                readOnly: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please select date'
                            : null,
              ),
              SizedBox(height: 16),

              // Start Time picker
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: 'Start Time *',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _pickTime(_startTimeController),
                  ),
                ),
                readOnly: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please select start time'
                            : null,
              ),
              SizedBox(height: 16),

              // End Time picker
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: 'End Time *',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _pickTime(_endTimeController),
                  ),
                ),
                readOnly: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please select end time'
                            : null,
              ),
              SizedBox(height: 16),

              // Reminder Minutes
              TextFormField(
                controller: _reminderMinutesController,
                decoration: InputDecoration(labelText: 'Reminder Minutes *'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter reminder minutes';
                  if (int.tryParse(value) == null) return 'Enter valid number';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Repeat dropdown
              DropdownButtonFormField<String>(
                value: _repeat,
                decoration: InputDecoration(labelText: 'Repeat'),
                items:
                    _repeatOptions
                        .map(
                          (repeat) => DropdownMenuItem(
                            value: repeat,
                            child: Text(repeat),
                          ),
                        )
                        .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _repeat = val;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Color picker (simple dropdown for demo)
              DropdownButtonFormField<int>(
                value: _color,
                decoration: InputDecoration(labelText: 'Color'),
                items: [
                  DropdownMenuItem(value: 0, child: Text('Grey')),
                  DropdownMenuItem(value: 1, child: Text('Red')),
                  DropdownMenuItem(value: 2, child: Text('Green')),
                  DropdownMenuItem(value: 3, child: Text('Blue')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _color = val;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Schedule Code
              TextFormField(
                controller: _scheduleCodeController,
                decoration: InputDecoration(labelText: 'Schedule Code *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter schedule code'
                            : null,
              ),
              SizedBox(height: 16),

              // Staff ID
              TextFormField(
                controller: _staffIdController,
                decoration: InputDecoration(labelText: 'Staff ID *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter staff ID'
                            : null,
              ),
              SizedBox(height: 16),

              // Subject
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter subject'
                            : null,
              ),
              SizedBox(height: 16),

              // Batch or Division (optional)
              TextFormField(
                controller: _batchOrDivisionController,
                decoration: InputDecoration(
                  labelText: 'Batch or Division (Optional)',
                ),
              ),
              SizedBox(height: 16),

              // Is Completed
              SwitchListTile(
                title: Text('Is Completed'),
                value: _isCompleted,
                onChanged: (val) {
                  setState(() {
                    _isCompleted = val;
                  });
                },
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Capture or process form data here
                    // Since UI-only, just print for now
                    print('Title: ${_titleController.text}');
                    print('Note: ${_noteController.text}');
                    print('Date: ${_dateController.text}');
                    print('StartTime: ${_startTimeController.text}');
                    print('EndTime: ${_endTimeController.text}');
                    print(
                      'ReminderMinutes: ${_reminderMinutesController.text}',
                    );
                    print('Repeat: $_repeat');
                    print('Color: $_color');
                    print('ScheduleCode: ${_scheduleCodeController.text}');
                    print('StaffId: ${_staffIdController.text}');
                    print('Subject: ${_subjectController.text}');
                    print(
                      'BatchOrDivision: ${_batchOrDivisionController.text}',
                    );
                    print('IsCompleted: $_isCompleted');

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Form is valid!')));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
