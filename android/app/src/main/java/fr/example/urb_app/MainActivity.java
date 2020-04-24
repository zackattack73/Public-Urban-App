package fr.example.urb_app;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.StrictMode;

import java.io.File;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "team.native.io/dataToMail";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    //StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
    //StrictMode.setVmPolicy(builder.build());
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("dataToMail")) {
                  String fileUri =call.argument("filePath").toString();
                  String content =call.argument("content").toString();
                  sendMail(Uri.fromFile(new File(fileUri)),content);
                  result.success("Done");
                }else {
                  result.notImplemented();
                }

              }
            });
  }
  private void sendMail(Uri filePath, String content){
    Intent intent = new Intent(Intent.ACTION_SEND);
    intent.setType("text/plain");
    intent.putExtra(Intent.EXTRA_EMAIL, new String[] {"EMAIL@EMAIL.FR"});
    intent.putExtra(Intent.EXTRA_SUBJECT, "Data from App");
    intent.putExtra(Intent.EXTRA_TEXT, content);
    intent.putExtra(Intent.EXTRA_STREAM, filePath);
    startActivity(Intent.createChooser(intent, "Send email..."));
  }
}
