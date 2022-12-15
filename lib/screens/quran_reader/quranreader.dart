import 'package:flutter/material.dart';

import 'package:csv/csv.dart';

class QuranReaderScreen extends StatelessWidget {
  const QuranReaderScreen({Key? key}) : super(key: key);

  // void _importFromExcel() async {
  //   //List<Object> fileBits = [];

  //   ByteData data = await rootBundle.load("assets/Dataset-Verse-by-Verse.csv");
  //   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   var excel = Excel.decodeBytes(bytes);

  //   for (var table in excel.tables.keys) {
  //     debugPrint(table); //sheet Name
  //     debugPrint(excel.tables[table]!.maxCols.toString());
  //     debugPrint(excel.tables[table]!.maxRows.toString());
  //     for (var row in excel.tables[table]!.rows) {
  //       debugPrint("$row");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //_importFromExcel();

    Future<List<List<dynamic>>> processCsv() async {
      var result = await DefaultAssetBundle.of(context).loadString(
        "assets/Dataset-Verse-by-Verse.csv",
      );
      return const CsvToListConverter().convert(result, eol: "\n");
    }

    //processCsv().then((value) => print(value));

    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blue,
          child: const Text('Quran'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: processCsv(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return const CircularProgressIndicator();
                      // Container(
                      //   height: 200,
                      //   width: 200,
                      //   padding: const EdgeInsets.all(20),
                      //   child: ListTile(
                      //     title: Text(
                      //       snapshot.data.toString(),
                      //       style: TextStyle(fontSize: 1),
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
