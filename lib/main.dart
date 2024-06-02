import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  )); // MaterialApp
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime today = DateTime.now();
  Map<DateTime, List<String>> events = {};

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _addEvent() {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event'),
        content: TextField(
          controller: eventController,
          decoration: InputDecoration(hintText: 'Enter event or note'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                setState(() {
                  if (events[today] == null) {
                    events[today] = [];
                  }
                  events[today]!.add(eventController.text);
                });
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeEvent(String event) {
    setState(() {
      events[today]?.remove(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 91, 91, 197), // Blue background color for the AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            title: Center(
              child: Text(
                "ON-TIME CALENDAR",
                style: TextStyle(
                  color: Colors.white, // Change the font color to white
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4.0, // Add spacing between letters
                ),
              ),
            ),
            backgroundColor: Colors.transparent, // Make the background transparent to show the container's color
            elevation: 0, // Remove AppBar's shadow
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 91, 91, 197), // Blue background color for the text container
                borderRadius: BorderRadius.circular(12.0), // Smooth edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(8.0), // Padding inside the container
              child: Text(
                today.toString().split(" ")[0],
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255), // Font color
                  fontSize: 20, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
            ),
            SizedBox(height: 20), // Space between the text and the calendar
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: _onDaySelected,
                eventLoader: (day) {
                  return events[day] ?? [];
                },
              ),
            ),
            SizedBox(height: 20), // Space between the calendar and the events
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: events[today]?.map((event) => GestureDetector(
                    onTap: () => _removeEvent(event),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 91, 91, 197), // Blue background for the event
                        borderRadius: BorderRadius.circular(12.0), // Smooth edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        event,
                        style: TextStyle(
                          color: Colors.white, // White font color
                        ),
                      ),
                    ),
                  )).toList() ?? [],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        backgroundColor: Color.fromARGB(255, 91, 91, 197), // Blue background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Circular shape
        ),
        child: Icon(
          Icons.add,
          color: Colors.white, // White plus sign
        ),
      ),
    );
  }
}
