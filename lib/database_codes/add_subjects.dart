import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController(
    text: "Physics",
  );
  final TextEditingController _dateController = TextEditingController(
    text: "Monday, 12 Apr 2021",
  );
  final TextEditingController _startTimeController = TextEditingController(
    text: "10:00 AM",
  );
  final TextEditingController _endTimeController = TextEditingController(
    text: "12:00 PM",
  );
  final TextEditingController _descController = TextEditingController();

  // For category selection
  List<String> categories = [
    "Math",
    "Lecture",
    "OS",
    "Data Structure",
    "Machine Learning",
  ];
  int selectedCategory = 1; // "Lecture" selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // margin: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF5046E4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          SizedBox(width: 18),
                          Text(
                            "Create New Task",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 32),
                      Text(
                        "Title",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      TextField(
                        controller: _titleController,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Divider(color: Colors.white54),
                      SizedBox(height: 10),
                      Text(
                        "Date",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      TextField(
                        controller: _dateController,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Divider(color: Colors.white54),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Start Time
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Start time",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _startTimeController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "AM",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            // End Time
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "End time",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _endTimeController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "PM",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          "Description",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextField(
                          controller: _descController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText:
                                "Some text here for the description. More Project for the description.",
                            border: InputBorder.none,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          "Category",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          children: List<Widget>.generate(
                            categories.length,
                            (index) => ChoiceChip(
                              label: Text(categories[index]),
                              selected: selectedCategory == index,
                              backgroundColor: Color(0xFFEDF2FD),
                              selectedColor: Color(0xFF5046E4),
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = index;
                                });
                              },
                              labelStyle: TextStyle(
                                color:
                                    selectedCategory == index
                                        ? Colors.white
                                        : Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Color(0xFF5046E4),
                              padding: EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () {
                              // Form Submission Logic Here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Task Created!')),
                              );
                            },
                            child: Text(
                              "Create Task",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
