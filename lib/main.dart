import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

const String apiKey = 'VaOfbU4pAfH2uBpLCFDPiRhyevg6W3Ou6nShl2yh';
late String responseDate;
String passwordFinal = '';

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
  double valueForSlider = 23;
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
                iconselect: const Icon(Icons.onetwothree),
                valueSelected: _numbers),
            buildCheckboxListTile(
                title: 'Special Characters',
                iconselect: const Icon(Icons.alternate_email),
                subtitle: 'Add special characters to password',
                valueSelected: _special),
            Text('Select Length of password: ${valueForSlider.toInt()}'),
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

                  // Map<String, dynamic> jsonOBJ =
                  //     json.decode((fetchPassword()));
                  // passwordFinal = jsonOBJ['random_password'];
                  // print(passwordFinal);
                });
              }),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('This is a demo alert dialog.'),
                        Text('Would you like to approve of this message?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Approve'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                    text: responseDate.substring(21, responseDate.length - 2)));
                // copied successfully
              },
              child: Text(
                responseDate.substring(21, responseDate.length - 2),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
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
      if (kDebugMode) {
        responseDate = response.body;
        print(responseDate);
      }
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
