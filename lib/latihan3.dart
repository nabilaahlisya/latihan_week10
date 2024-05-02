import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class University {
  String name;
  String website;

  University({required this.name, required this.website});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'].isEmpty ? "Not available" : json['web_pages'][0],
    );
  }
}

class UniversitiesList {
  final List<University> universities;

  UniversitiesList({required this.universities});

  factory UniversitiesList.fromJson(List<dynamic> json) {
    List<University> universities = [];
    universities = json.map((university) => University.fromJson(university)).toList();
    return UniversitiesList(
      universities: universities,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<UniversitiesList> universities;

  @override
  void initState() {
    super.initState();
    universities = fetchUniversities();
  }

  Future<UniversitiesList> fetchUniversities() async {
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return UniversitiesList.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indonesian Universities'),
          backgroundColor: Colors.pink, // Warna latar belakang header
        ),
        body: FutureBuilder<UniversitiesList>(
          future: universities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.universities.length,
                itemBuilder: (context, index) {
                  University university = snapshot.data!.universities[index];
                  return ListTile(
                    title: Text(university.name),
                    subtitle: Text(university.website),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
