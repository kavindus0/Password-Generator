import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = 'VaOfbU4pAfH2uBpLCFDPiRhyevg6W3Ou6nShl2yh';
String password = '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Password Generator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Api endPoint
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double valueForSlider = 10;
  bool _numbers = true;
  bool _special = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildCheckboxListTile(
                title: 'Numbers',
                subtitle: 'Add numbers to password',
                iconselect: const Icon(Icons.numbers),
                valueSelected: _numbers),
            SizedBox.fromSize(
              size: const Size(0, 30),
            ),
            buildCheckboxListTile(
                title: 'Special Characters',
                iconselect: const Icon(Icons.hdr_auto_sharp),
                subtitle: 'Add special characters to password',
                valueSelected: _special),
            SizedBox.fromSize(
              size: const Size(0, 30),
            ),
            Text(
              'Lenght of Password is ${valueForSlider.toInt()} digits',
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox.fromSize(
              size: const Size(0, 30),
            ),
            Slider.adaptive(
              min: 5,
              max: 55,
              divisions: 50,
              label: valueForSlider.toString(),
              value: valueForSlider,
              onChanged: ((double newValueOfSlider) {
                setState(() {
                  valueForSlider = newValueOfSlider.round().toDouble();
                  fetchPassword();
                });
              }),
            ),
            SizedBox.fromSize(
              size: const Size(0, 30),
            ),
            Text(
              password,
              style: const TextStyle(fontSize: 18),
              // style: const TextStyle(fontSize: 20.5),
            ),
            SizedBox.fromSize(
              size: const Size(0, 10),
            ),
            Center(
              child: TextButton(
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Copy to Clipboard   '),
                        Icon(Icons.copy_sharp)
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> fetchPassword() async {
    http.Response response = await http.get(
      Uri.parse(
          'https://api.api-ninjas.com/v1/passwordgenerator?length=${valueForSlider.toInt()}&exclude_numbers=${!_numbers}&exclude_special_chars=${!_special}'),
      headers: {'X-Api-Key': apiKey},
    );
    if (response.statusCode == 200) {
      setState(() {
        password = jsonDecode(response.body)['random_password'];
      });
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode} ${response.body}');
      }
    }
    return response.body;
  }

  CheckboxListTile buildCheckboxListTile({
    required String title,
    required String subtitle,
    required Icon iconselect,
    required bool valueSelected,
  }) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: valueSelected,
      secondary: iconselect,
      onChanged: (bool? newValue) {
        setState(
          () {
            fetchPassword();
            if (title == 'Numbers') {
              _numbers = newValue!;
            } else if (title == 'Special Characters') {
              _special = newValue!;
            }
          },
        );
      },
    );
  }
}
