import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'TestEthWallet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late http.Client httpClient;
  late Web3Client ethClient;
  final myAddress = "0xa9b8f5426b3dF8022d4489C0d3dc00ce2E25584A";
  bool value = true;
  double _value = 1.0;
  var mydata;
  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client("https://ropsten.infura.io/v3/999c249de92c4374a354fed756fe8e8b", httpClient);
    getBalance(myAddress);
  }
  Future<DeployedContract> loadContract() async{
    String abi=await rootBundle.loadString("assets/abi.json");
    String contractAddress="0x41EF315575e55860d3a42AfCc00149C95a82D1c8";
    final contract=DeployedContract(ContractAbi.fromJson(abi, "ethwalltrial"),EthereumAddress.fromHex(contractAddress));
    return contract;
  }
  Future<List<dynamic>> query(String function,List<dynamic>args)async{
    final contract =await loadContract();
    final ethFunction=contract.function(function);
    final result=await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetAdress) async {
    EthereumAddress address = EthereumAddress.fromHex(targetAdress);
    List<dynamic> result=await query("getBalance", []);
    mydata= result[0];

    value=true;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[300],
            body: Column(
              children: [
                Container(
                  color: Colors.teal,
                  width: double.maxFinite,
                  height: 250,
                  child: Center(
                      child: Text(
                    "ETH Wallet Trial",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Balance",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      value
                          ? Text("$mydata")
                          : CircularProgressIndicator(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SfSlider(
                    activeColor: Colors.teal,
                    inactiveColor: Color(0xffFFFDD0),
                    min: 0,
                    max: 1,
                    value: _value,
                    showLabels: true,
                    enableTooltip: true,
                    onChanged: (dynamic change) {
                      print(change);
                      setState(() {
                        _value = change;
                      });
                    }),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {getBalance(myAddress);},
                        child: Row(
                          children: [
                            Icon(Icons.refresh_rounded),
                            Text(" Refresh")
                          ],
                        )),
                    ElevatedButton(
                      onPressed: () {print(mydata);},
                      child: Row(
                        children: [
                          Icon(Icons.call_made_rounded),
                          Text(" Deposit")
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(Icons.call_received_rounded),
                          Text(" Withdraw")
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
// Container(
// height: 200,width: 350,
// decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.white),
// child: Padding(
// padding:  EdgeInsets.only(top: 30),
// child: Text("Balance",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
// ),
// ),
