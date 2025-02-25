package com.example.oyo
import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // This method is called when the activity is resumed
    override fun onResume() {
        super.onResume()
        // Create an intent to restart this activity
        val intent = Intent(context, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        // Create a pending intent to be used by the NFC adapter
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)
        // Enable NFC foreground dispatch to handle NFC tags when the app is in the foreground
        NfcAdapter.getDefaultAdapter(context)?.enableForegroundDispatch(this, pendingIntent, null, null)
    }

    // This method is called when the activity is paused
    override fun onPause() {
        super.onPause()
        // Disable NFC foreground dispatch when the app is not in the foreground
        NfcAdapter.getDefaultAdapter(context)?.disableForegroundDispatch(this)
    }
}