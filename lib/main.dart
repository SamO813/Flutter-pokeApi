import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAPI App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _pokemonNames = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonNames();
  }

  Future<void> fetchPokemonNames() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _pokemonNames = List<String>.from(data['results'].map((item) => item['name']));
      });
    } else {
      throw Exception('Failed to load Pokémon names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokeAPI App'),
      ),
      body: _pokemonNames.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pokemonNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pokemonNames[index]),
                );
              },
            ),
    );
  }
}
