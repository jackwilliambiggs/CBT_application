import 'package:flutter/material.dart';
import 'package:cbt_application/models/thought_entry.dart';

// this acts as a temporary in-memory store for thought entries
// in a real app, this would be replaced with persistent storage  like a database or file system  

List<ThoughtEntry> entries = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mind J ournal')),
      body: Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ThoughtEntryPage()),
                  );
                },
                child: const Text('Add New Thought'),
              ),
            ),
          ),
          Expanded(
            child: SizedBox.expand(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
                child: const Text('View Past Entries'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past Entries')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Thought')),
            DataColumn(label: Text('Distortions')),
            DataColumn(label: Text('Response')),
          ],
          rows: entries.map((entry) {
            return DataRow(cells: [
              DataCell(Text(entry.timestamp.toLocal().toString())),
              DataCell(Text(entry.thought)),
              DataCell(Text(entry.distortions.join(', '))),
              DataCell(Text(entry.response)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}



class ThoughtEntryPage extends StatefulWidget {
  const ThoughtEntryPage({super.key});

  @override
  State<ThoughtEntryPage> createState() => _ThoughtEntryPageState();
}

class _ThoughtEntryPageState extends State<ThoughtEntryPage> {
  final thoughtController = TextEditingController();
  final responseController = TextEditingController();

  final distortions = [
    'All-or-Nothing thinking',
    'Overgeneralisation',
    'Mental Filter',
    'Disqualifying the Positive',
    'Jumping to Conclusions',
    'Magnification/Minimization',
    'Emotional Reasoning',
    'Should Statements',
    'Labeling and Mislabeling', 
    'Personalization',
  ];

  final selectedDistortions = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Thought Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter your thought:'),
              TextField(
                controller: thoughtController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text('Select cognitive distortions:'),
              Wrap(
                spacing: 8,
                children: distortions.map((distortion) {
                  final isSelected = selectedDistortions.contains(distortion);
                  return FilterChip(
                    label: Text(distortion),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedDistortions.add(distortion);
                        } else {
                          selectedDistortions.remove(distortion);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Write a rational response:'),
              TextField(
                controller: responseController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final thought = thoughtController.text;
                  final response = responseController.text;
                  final tags = selectedDistortions.toList();
                  final timestamp = DateTime.now();

                  entries.add(ThoughtEntry(
                    thought: thought,
                    distortions: tags,
                    response: response,
                    timestamp: timestamp,
                  ));
                  print('Thought: $thought');
                  print('Distortions: $tags');
                  print('Response: $response');
                  print('timestamp: $timestamp');  

                  thoughtController.clear();
                  responseController.clear();
                  setState(() => selectedDistortions.clear());
                },
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

