import 'package:flutter/material.dart';

void main() {
  runApp(SeatFinderApp());
}

class SeatFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        fontFamily: 'Roboto',
      ),
      home: SeatFinderScreen(),
    );
  }
}

class SeatFinderScreen extends StatefulWidget {
  @override
  _SeatFinderScreenState createState() => _SeatFinderScreenState();
}

class _SeatFinderScreenState extends State<SeatFinderScreen> {
  final TextEditingController _seatNumberController = TextEditingController();
  String? _berthType;
  String? _berthLocation;

  void _findSeat() {
    String seatNumber = _seatNumberController.text.trim().toUpperCase();
    if (seatNumber.isEmpty) {
      _showErrorDialog('Please enter a seat number.');
      return;
    }

    Map<String, String>? berthDetails = findBerth(seatNumber);
    if (berthDetails == null) {
      _showErrorDialog('Invalid seat number. Please enter a valid seat number.');
      return;
    }

    setState(() {
      _berthType = berthDetails['type'];
      _berthLocation = berthDetails['location'];
    });
    _showResultDialog();
  }

  Map<String, String>? findBerth(String seatNumber) {
    // Assuming seat numbers are in the format of {berth_type}{berth_number}
    // Example: L1, SU12, ML23, UL34, etc.
    String berthType = seatNumber.substring(0, 1);
    String berthNumber = seatNumber.substring(1);

    if (berthType == 'L') {
      return {'type': 'Lower Berth', 'location': 'Side Lower'};
    } else if (berthType == 'M') {
      return {'type': 'Middle Berth', 'location': 'Middle'};
    } else if (berthType == 'U') {
      return {'type': 'Upper Berth', 'location': 'Side Upper'};
    } else if (berthType == 'S') {
      int? parsedNumber = int.tryParse(berthNumber);
      if (parsedNumber != null && parsedNumber % 2 == 0) {
        return {'type': 'Side Lower Berth', 'location': 'Side Lower'};
      } else {
        return {'type': 'Side Upper Berth', 'location': 'Side Upper'};
      }
    }

    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Seat Finder Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seat Number: ${_seatNumberController.text}'),
            SizedBox(height: 10),
            Text('Berth Type: $_berthType'),
            SizedBox(height: 10),
            Text('Berth Location: $_berthLocation'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seat Finder',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _seatNumberController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: 'Enter Seat Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _findSeat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Find Berth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_berthType != null && _berthLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seat Number: ${_seatNumberController.text}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Berth Type: $_berthType',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Berth Location: $_berthLocation',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
