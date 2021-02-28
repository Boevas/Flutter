import 'package:flutter/material.dart';

//Pages
import 'Pages/Page1.dart';
import 'Pages/Page2.dart';
import 'Pages/Page3.dart';
import 'Pages/Page4.dart';
import 'Pages/Page5.dart';
import 'Pages/Page6.dart';
import 'Pages/Page7.dart';
import 'Pages/Page8.dart';
import 'Pages/Page9.dart';
import 'Pages/Page10.dart';
import 'Pages/Page11.dart';
import 'Pages/Page12.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Start',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        //leading: Image.asset("lib/images/SNAP.png"),
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Image.asset("lib/icons/Page1.png"),
              title: Text('Page1'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Page1(ChartDemoData1().getdata())));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page2.png"),
              title: Text('Page2'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page2()));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page3.png"),
              title: Text('Page3'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page3()));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page4.png"),
              title: Text('Page4'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Page4(ChartDemoData2().getdata())));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page5.png"),
              title: Text('Page5'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Page5(ChartDemoData3().getdata())));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page6.png"),
              title: Text('Page6'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Page6(ChartDemoData4().getdata())));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page7.png"),
              title: Text('Page7'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page7()));
              },
            ),
            /*
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page8.png"),
              title: Text('Page8'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page8()));
              },
            ),
            */
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page9.png"),
              title: Text('Page9'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page9()));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page10.png"),
              title: Text('Статус'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page10()));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page11.png"),
              title: Text('Заказ'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page11()));
              },
            ),
            Divider(
              color: Colors.black,
              height: 5.0,
            ),
            ListTile(
              leading: Image.asset("lib/icons/Page12.png"),
              title: Text('Big DataTable'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Page12()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
