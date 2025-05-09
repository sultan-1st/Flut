import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: RoutePlannerPageState(),
    );
  }
}
class RoutePlannerPageState extends StatefulWidget {
  const RoutePlannerPageState({super.key});

  @override
  _RoutePlannerPageState createState() => _RoutePlannerPageState();
}

class _RoutePlannerPageState extends State<RoutePlannerPageState> {
  String? startLine;
  String? endLine;
  String? startStation;
  String? endStation;

  Map<String, List<String>> lines = {
    'BLUE': [
      'SABB',
      'Dr Sulaiman Al Habib',
      'KAFD',
      'Al Murooj',
      'King Fahad District',
      'King Fahad District 2',
      'Al Wurud 2',
      'Al Urubah',
      'Alinma Bank',
      'Bank Albilad',
      'King Fahad Library',
      'Ministry of Interior',
      'Al Murabba',
      'Passport Department',
      'National Museum',
      'Al Batha',
      'Al Owd',
      'Skirinah',
      'Manfouhah',
      'Al Iman Hospital',
      'Transportation Center',
      'Al Aziziah',
      'Ad Dar Al Baida'
    ],
    'RED': [
      'King Saud University',
      'King Salman Oasis',
      'KACST',
      'At Takhassusi',
      'STC',
      'Al-Wurud',
      'King Abdulaziz Road',
      'Ministry of Education',
      'An Nuzhah',
      'Riyadh Exhibition Center',
      'Khalid Bin Alwaleed Road',
      'Al-Hamra',
      'Al-Khaleej',
      'City Centre Ishbiliyah',
      'King Fahd Sports City'
    ],
    'ORANGE': [
      'Jeddah Road',
      'Tuwaiq',
      'Ad Douh',
      'Western Station',
      'Aishah bint Abi Bakr Street',
      'Dhahrat Al Badiah',
      'Sultanah',
      'Al Jarradiyah',
      'Courts Complex',
      'Qasr Al Hokm',
      'Al Hilla',
      'Al Margab',
      'As Salhiyah',
      'First Industrial City',
      'Railway',
      'Al Malaz',
      'Jarir District',
      'Al Rajhi Grand Mosque',
      'Harun Ar Rashid Road',
      'An Naseem',
      'Hassan Bin Thabit Street',
      'Khashm Al An'
    ],
    'YELLOW': [
      'PNU',
      'Governmental Complex',
      'Airport T5',
      'Airport T3–4',
      'Airport T1–2'
    ],
    'GREEN': [
      'Ministry of Education',
      'Salahaddin',
      'As Sulimaniyah',
      'Ad Dhabab',
      'Abu Dhabi Square',
      'Officers Club',
      'GOSI',
      'Al Wizarat',
      'Ministry of Defense',
      'MEW&A',
      'Ministry of Finance',
      'National Museum'
    ],
    'PURPLE': [
      'KAFD',
      'Ar Rabi',
      'Uthman Bin Affan Road',
      'SABIC',
      'Al Yarmuk',
      'Al Hamra',
      'Al Andalus',
      'Khurais Road',
      'As Salam',
      'An Naseem'
    ]
  };

  Map<String, Map<String, int>> buildGraph() {
    Map<String, Map<String, int>> graph = {};
    lines.forEach((line, stations) {
      for (int i = 0; i < stations.length; i++) {
        if (!graph.containsKey(stations[i])) {
          graph[stations[i]] = {};
        }
        if (i > 0) {
          graph[stations[i]]![stations[i - 1]] = 1;
          graph[stations[i - 1]]![stations[i]] = 1;
        }
      }
    });
    graph['Qasr Al Hokm']!['National Museum'] = 5;
    graph['National Museum']!['Qasr Al Hokm'] = 5;
    graph['STC']!['Al-Wurud'] = 5;
    graph['Al-Wurud']!['STC'] = 5;
    graph['KAFD']!['Ar Rabi'] = 5;
    graph['Ar Rabi']!['KAFD'] = 5;
    return graph;
  }

  Map<String, dynamic> findShortestPath(String start, String end) {
    Map<String, Map<String, int>> graph = buildGraph();
    Map<String, int> distances = {};
    Map<String, String> previous = {};
    List<String> nodes = [];
    for (String station in graph.keys) {
      distances[station] = station == start ? 0 : 999999;
      nodes.add(station);
    }
    while (nodes.isNotEmpty) {
      nodes.sort((a, b) => distances[a]!.compareTo(distances[b]!));
      String smallest = nodes.removeAt(0);
      if (smallest == end) {
        List<String> path = [];
        while (previous.containsKey(smallest)) {
          path.add(smallest);
          smallest = previous[smallest]!;
        }
        path.add(start);
        return {'distance': distances[end]!, 'path': path.reversed.toList()};
      }
      for (String neighbor in graph[smallest]!.keys) {
        int alt = distances[smallest]! + graph[smallest]![neighbor]!;
        if (alt < distances[neighbor]!) {
          distances[neighbor] = alt;
          previous[neighbor] = smallest;
        }
      }
    }
    return {'distance': -1, 'path': []};
  }

  List<String> formatRoute(List<String> route) {
    List<String> formattedRoute = [];
    for (int i = 0; i < route.length; i++) {
      formattedRoute.add(route[i]);
      if (i < route.length - 1) {
        String currentStation = route[i];
        String nextStation = route[i + 1];
        String currentLine = getLineForStation(currentStation);
        String nextLine = getLineForStation(nextStation);
        if (currentLine != nextLine) {
          formattedRoute.add('Switch to $nextLine at $currentStation');
        }
      }
    }
    return formattedRoute;
  }

  String getLineForStation(String station) {
    for (String line in lines.keys) {
      if (lines[line]!.contains(station)) {
        return line;
      }
    }
    return '';
  }

  double calculateTravelTime(int stationCount) {
    return stationCount * 2.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 251), // Set the background color
      appBar: AppBar(
        title: Text(
          'Route Planner',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4.0,
        backgroundColor: Color.fromARGB(255, 56, 141, 35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Route',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 56, 141, 35)),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: startLine,
              items: lines.keys
                  .map((line) => DropdownMenuItem(
                        value: line,
                        child: Text(line, style: TextStyle(color: Color.fromARGB(255, 56, 141, 35))),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  startLine = value;
                  startStation = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Choose Start Line',
                filled: true,
                fillColor: Color.fromARGB(255, 252, 252, 252),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color.fromARGB(255, 56, 141, 35)),
                ),
              ),
            ),
            if (startLine != null)
              DropdownButtonFormField<String>(
                value: startStation,
                items: lines[startLine]!
                    .map((station) => DropdownMenuItem(
                          value: station,
                          child: Text(station, style: TextStyle(color: Color.fromARGB(255, 56, 141, 35))),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    startStation = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Choose Start Station',
                  filled: true,
                  fillColor: Color.fromARGB(255, 252, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color.fromARGB(255, 56, 141, 35)),
                  ),
                ),
              ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: endLine,
              items: lines.keys
                  .map((line) => DropdownMenuItem(
                        value: line,
                        child: Text(line, style: TextStyle(color: Color.fromARGB(255, 56, 141, 35))),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  endLine = value;
                  endStation = null;
                });
              },
              decoration: InputDecoration(
                labelText: 'Choose End Line',
                filled: true,
                fillColor: Color.fromARGB(255, 252, 252, 252),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color.fromARGB(255, 56, 141, 35)),
                ),
              ),
            ),
            if (endLine != null)
              DropdownButtonFormField<String>(
                value: endStation,
                items: lines[endLine]!
                    .map((station) => DropdownMenuItem(
                          value: station,
                          child: Text(station, style: TextStyle(color: Color.fromARGB(255, 56, 141, 35))),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    endStation = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Choose End Station',
                  filled: true,
                  fillColor: Color.fromARGB(255, 252, 252, 252),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color.fromARGB(255, 56, 141, 35)),
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (startLine != null &&
                endLine != null &&
                startStation != null &&
                endStation != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Builder(
                    builder: (context) {
                      Map<String, dynamic> result = findShortestPath(startStation!, endStation!);
                      List<String> route = result['path'];
                      List<String> formattedRoute = formatRoute(route);
                      double travelTime = calculateTravelTime(route.length - 1);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Route:',
                            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 56, 141, 35)),
                          ),
                          SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: formattedRoute.map((step) {
                              return Text(
                                step,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estimated Travel Time: ${travelTime.toStringAsFixed(2)} minutes',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
