import 'dart:convert';
import 'dart:math';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
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
  TextEditingController search = TextEditingController();
  bool loading = false;
  List dataName = [];

  Future<Null> searchName() async {
    dataName = [];
    print(search.text);
    // var url1 = Uri.https('ppv-4z7y7b4hya-as.a.run.app','/name/${search.text}');
    var url2 = Uri.parse('https://ppv-4z7y7b4hya-as.a.run.app/name/${search.text}');
    var response = await http.get(url2);
    print('response: ${response.statusCode}');
    if(response.statusCode == 200){
      setState(() {
        dataName = [];
        loading = true;
      });
      var res = jsonDecode(response.body);
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          loading = false;
          dataName = res;
        });
      });
      print('dataName: ${dataName}');
    }else{
      setState(() {
        dataName = [];
        loading = false;
      });
    }
    
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text('Test RobinHood'),
            centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.search),
                          hintText: 'input',
                          labelText: 'Search Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blue), //<-- SEE HERE
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.blue), //<-- SEE HERE
                          ),
                        ),
                        controller: search,
                      ),
                    ),
                    SizedBox(width: 50),
                    Expanded(
                        child: Container(
                          child: ElevatedButton(
                              onPressed: (){
                                searchName();
                              },
                              child: Text('Search'),
                            style: ButtonStyle(

                                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(15, 10, 15, 10)),
                                alignment: Alignment.center,
                              fixedSize: MaterialStateProperty.all(Size(10, 50)),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 20),
                dataName.isNotEmpty && loading == false ?
                ListView.builder(
                    itemCount: dataName.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: (
                                Text(dataName[i]['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)
                            ),
                          ),
                        ),
                      );
                    })

                :dataName.isEmpty && loading == true ?
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: const CupertinoActivityIndicator(
                      radius: 30.0, color: CupertinoColors.activeBlue
                  ),
                ):Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    children: [
                      Image.network('https://img.freepik.com/free-vector/no-data-concept-illustration_114360-536.jpg?w=2000'),
                      SizedBox(height: 20),
                      Text('No Data',style: TextStyle(fontSize: 20),),
                    ],
                  ),)
                ,

              ],
            ),
          ),
        )
    );
  }
}
