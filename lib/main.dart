import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/note_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box hiveBox;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hiveBox = Hive.box('notes');
  }

  @override
  void dispose() async {
    await hiveBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes App"),
        toolbarHeight: height * 0.07,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hive Notes',
                    style: GoogleFonts.raleway(
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        width: 270,
                        child: TextField(
                          controller: _textController,
                          cursorColor: Colors.black,
                          cursorHeight: 25,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8.0),
                            filled: true,
                            fillColor: Color.fromARGB(255, 100, 69, 58)
                                .withOpacity(.2),
                            hintText: "Enter your note here",
                            hintStyle: GoogleFonts.raleway(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await hiveBox.add(_textController.text);
                          _textController.clear();
                        },
                        child: Text(
                          'Add',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: height * 0.73,
              // value listenable to listen to the changes on the box
              // An inbuilt value listenable is provided by hive and
              // is invoked using the listenable() function
              child: ValueListenableBuilder(
                valueListenable: hiveBox.listenable(),
                builder: (BuildContext ctx, Box box, _) {
                  List<Widget> notesList = [];
                  box.toMap().forEach((key, value) {
                    notesList.add(NoteWidget(value, key, box));
                  });

                  return notesList.length == 0
                      ? Text(
                          'No Notes Added Yet!',
                          style: GoogleFonts.raleway(fontSize: 18),
                        )
                      : ListView(children: notesList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
