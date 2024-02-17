import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double valueForSlider = 23;
  bool _numbers = false;
  bool _simple = false;
  bool _capital = true;
  bool _special = true;
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                iconselect: Icon(Icons.numbers),
                valueSelected: _numbers),
            buildCheckboxListTile(
                title: 'Simple Letters',
                iconselect: Icon(Icons.abc_sharp),
                subtitle: 'Add simple letters to password',
                valueSelected: _simple),
            buildCheckboxListTile(
                title: 'Capital Letters',
                iconselect: Icon(Icons.abc_sharp),
                subtitle: 'Add capital letters to password',
                valueSelected: _capital),
            buildCheckboxListTile(
                title: 'Special Characters',
                iconselect: Icon(Icons.hdr_auto_sharp),
                subtitle: 'Add special characters to password',
                valueSelected: _special),
            Text(
              'You have $_numbers pushed the $_capital button this many times:',
            ),
            Slider.adaptive(
                min: 5,
                max: 55,
                divisions: 50,
                label: valueForSlider.round().toString(),
                value: valueForSlider,
                onChanged: ((double newValueOfSlider) {
                  setState(() {
                    valueForSlider = newValueOfSlider.round().toDouble();
                  });
                })),
            Text(
              '${valueForSlider.toInt()}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
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
            } else if (title == 'Simple Letters') {
              _simple = newValue!;
            } else if (title == 'Capital Letters') {
              _capital = newValue!;
            } else if (title == 'Special Characters') {
              _special = newValue!;
            }
          },
        );
      },
    );
  }
}
