// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: NfcScreen(), // Set the home screen to BitCoinTracker
    );
  }
}

// Main class for the NFC screen
class NfcScreen extends StatefulWidget {
  @override
  _NfcScreenState createState() => _NfcScreenState();
}

// State class for the NFC screen
class _NfcScreenState extends State<NfcScreen> {
  bool isLoading=false;
  String _nfcData = 'No data'; // Variable to store NFC data
  final TextEditingController _textController =
      TextEditingController(); // Controller for text input
  @override
  void initState() {
    super.initState();
    // Check if NFC is available
    NfcManager.instance.isAvailable().then((isAvailable) {
      if (isAvailable) {
        // Start NFC session if available
      } else {
        setState(() {
          _nfcData =
              'NFC is not available'; // Update UI if NFC is not available
        });
      }
    });
  }

  // Function to start NFC session
  void _writeNfcTag() {
     setState(() {
        isLoading=true;
      });
    // Start NFC session
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
     
      // Example of writing data to the tag
      Ndef? ndef = Ndef.from(tag);
      if (ndef != null && ndef.isWritable) {
        // Create NDEF message with input text
        NdefMessage message = NdefMessage([
          NdefRecord.createText(_textController.text),
        ]);
        try {
          // Write message to tag
          await ndef.write(message);
          setState(() {
            _nfcData = 'Write successful!'; // Update UI on success
            isLoading=false;
          });
        } catch (e) {
          setState(() {
            _nfcData = 'Write failed: $e'; // Update UI on failure
            isLoading=false;
          });
        }
      }
      // Stop NFC session
      NfcManager.instance.stopSession();
    });
  }

  // Function to read NFC tag
  void _readNfcTag() {
      setState(() {
        isLoading=true;
      });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    
      Ndef? ndef = Ndef.from(tag);
      if (ndef != null) {
        // Read message from tag
        NdefMessage? message = await ndef.read();
        setState(() {
          var rawData =
              message.records.first.payload; // Store payload in temp variable
          String textData =
              String.fromCharCodes(rawData); // Convert payload to string
          _nfcData = textData.substring(3); // Update UI with read data
          isLoading=false;
        });
      }
      // Stop NFC session
      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('NFC Screen'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter data to write', // Input field label
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _writeNfcTag,
              child: Text('Write to NFC',
              style: TextStyle(color: Colors.white),
              ), // Button to write to NFC
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _readNfcTag,
              child: Text('Read from NFC',
              style: TextStyle(color: Colors.white),
              ), // Button to read from NFC
            ),
            SizedBox(height: 20),
            isLoading?
        Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ):Text(_nfcData), // Display NFC data
          ],
        ),
      ),
    );
  }
}
