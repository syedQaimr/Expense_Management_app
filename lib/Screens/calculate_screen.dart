import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  // variable that stores reference to shared preference
  SharedPreferences? _prefs;

  num _money = 0, _save = 0, _rm = 0;

  List<String> _RMhistory = <String>[];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs = value;
        _RMhistory = _prefs!.getStringList("rm_history") ?? [];
        _save = _prefs!.getDouble("last_input_save")?.toDouble() ?? 0;
        _money = _prefs!.getDouble("last_input_money")?.toDouble() ?? 0;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          "Calculate",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        centerTitle: true,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_prefs == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.05,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffCFCFFC).withOpacity(0.1),
              ),
              color: const Color(0xff4E4E61).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                "${_RMhistory.lastOrNull ?? 0.00} Remaining money",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _moneyInput(),
              _saveInput(),
            ],
          ),
          _calculateRMButton(),
          Text(
            "Calculation history",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
          _rmhistoryList(),
        ],
      ),
    );
  }

  Widget _moneyInput() {
    return Column(
      children: [
        Text(
          "Money",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[400],
          ),
        ),
        InputQty(
          maxVal: double.infinity,
          initVal: _money,
          minVal: 0,
          steps: 1,
          onQtyChanged: (value) {
            setState(() {
              _money = value;
              _prefs!.setDouble(
                "last_input_money",
                _money.toDouble(),
              );
            });
          },
          decoration: QtyDecorationProps(
            btnColor: Color(0xFFEE4135),
            fillColor: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _saveInput() {
    return Column(
      children: [
        Text(
          "Save",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[400],
          ),
        ),
        InputQty(
          maxVal: double.infinity,
          initVal: _save,
          minVal: 0,
          steps: 1,
          onQtyChanged: (value) {
            setState(() {
              _save = value;
              _prefs!.setDouble(
                "last_input_save",
                _save.toDouble(),
              );
            });
          },
          decoration: QtyDecorationProps(
            btnColor: Color(0xFFEE4135),
            fillColor: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _calculateRMButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: MaterialButton(
        onPressed: () {
          double calculatedRM = _money.toDouble() - _save.toDouble();
          setState(() {
            _RMhistory.add(
              calculatedRM.toStringAsFixed(
                2,
              ),
            );
            _prefs!.setStringList("rm_history", _RMhistory);
          });
        },
        color: Color(0xFFEE4135),
        child: Text(
          "Calculate",
          style: TextStyle(
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }

  Widget _rmhistoryList() {
    return Container(
      child: Expanded(
        child: ListView.builder(
          itemCount: _RMhistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(
                index.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                ),
              ),
              title: Text(
                _RMhistory[index],
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              onLongPress: () {
                setState(() {
                  _RMhistory.removeAt(index);
                  _prefs!.setStringList("rm_history", _RMhistory);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
