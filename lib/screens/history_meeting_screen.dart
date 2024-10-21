import 'package:flutter/material.dart';
import 'package:video_confrence_app/resources/firestore_methods.dart';
import 'package:intl/intl.dart';

class HistoryMeetingScreen extends StatefulWidget {
  const HistoryMeetingScreen({Key? key}) : super(key: key);

  @override
  State<HistoryMeetingScreen> createState() => _HistoryMeetingScreenState();
}

class _HistoryMeetingScreenState extends State<HistoryMeetingScreen> {
  String _searchQuery = '';
  String?
      _selectedMeetingDetails; // To store the details of the selected meeting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and action buttons container (filter, delete)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meeting History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Trigger filtering or sorting logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () {
                        // Clear history logic
                        _clearHistory();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar for filtering by meeting name
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search meetings by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),

            // History meetings list
            Expanded(
              child: StreamBuilder(
                stream: FirestoreMethods().meetingsHistory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var docs = (snapshot.data! as dynamic).docs;
                  var filteredDocs = docs.where((doc) {
                    String meetingName =
                        doc['meetingName'].toString().toLowerCase();
                    return meetingName.contains(_searchQuery);
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No meetings found!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var meeting = filteredDocs[index];
                      var meetingData = meeting.data()
                          as Map<String, dynamic>; // Extract data correctly
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black87,
                            child: Icon(Icons.videocam, color: Colors.white),
                          ),
                          title: Text(
                            meetingData['meetingName'], // Use meetingData
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Joined on ${DateFormat.yMMMd().format(meetingData['createdAt'].toDate())}', // Use meetingData
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  // Pass meeting data to show details
                                  _showMeetingDetails(
                                      meetingData); // Use meetingData
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Logic to delete the specific meeting
                                  _deleteMeeting(
                                      meeting.id); // Assuming meeting has an id
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearHistory() {
    // Implement logic to clear all meeting history from Firestore
    FirestoreMethods().clearAllMeetings(context).then((_) {
      setState(() {
        _searchQuery = ''; // Reset search query
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting history cleared!')),
      );
    });
  }

  void _deleteMeeting(String meetingId) {
    // Implement logic to delete a specific meeting from Firestore
    FirestoreMethods().deleteMeeting(context, meetingId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting deleted!')),
      );
    });
  }

  void _showMeetingDetails(Map<String, dynamic> meeting) {
    // Display meeting details in a sliding panel
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                meeting['meetingName'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Call Type: ${meeting['callType']}'), // Add call type field
              Text(
                  'Time: ${DateFormat.jm().format(meeting['createdAt'].toDate())}'), // Format time
              Text(
                  'Date: ${DateFormat.yMMMd().format(meeting['createdAt'].toDate())}'), // Format date
              Text(
                  'Name: ${meeting['hostName'] ?? 'N/A'}'), // Add host name field
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}
