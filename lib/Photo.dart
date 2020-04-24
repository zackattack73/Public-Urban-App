import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'PhotoPreview.dart';
import 'package:geolocator/geolocator.dart';
import 'global.dart' as global;
import 'package:intl/intl.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';


class CameraExample extends StatefulWidget {

  @override
  _CameraExampleState createState() {
    return _CameraExampleState();
  }
}

class _CameraExampleState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  Position pos;
  int dir = 0;

  final GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //_permissionExternalStorage();
    // Get the list of available cameras.

    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Page Photo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
                _thumbnailWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display 'Loading' text when the camera is still loading.

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Chargement',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the thumbnail of the captured image

  Widget _thumbnailWidget() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhotoPreviewPage(path: imagePath)),
          );
        },
        child: Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: imagePath == null
                ? SizedBox( width: 64.0,
              height: 64.0,)
                : SizedBox(
                    child: Image.file(File(imagePath)),
                    width: 64.0,
                    height: 64.0,
                  ),
          ),
        ));
  }

  /// Display the control bar with buttons to take pictures

  Widget _captureControlRowWidget() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              color: Colors.blue,
              onPressed: controller != null && controller.value.isInitialized
                  ? _onCapturePressed
                  : null,
            )
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;

      case CameraLensDirection.front:
        return Icons.camera_front;

      case CameraLensDirection.external:
        return Icons.camera;

      default:
        return Icons.device_unknown;
    }
  }

  Future _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;

    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  Future _takePicture() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    // Do nothing if a capture is on progress

    if (controller.value.isTakingPicture) {
      return null;
    }

    var dir2 = await getExternalStorageDirectory();
    var fileDir =
    await new Directory('${dir2.path}/Pictures').create(recursive: true);
    String dir = (await getExternalStorageDirectory()).absolute.path+"/Pictures/";
    String file = "$dir";
    print("___________________________________________ FILE " + file);
    String date = new DateFormat("dd-MM-yyyy kk-mm-ss").format(DateTime.now());
    String filename = "Urban "+date+".png";
    File f = new File(file+filename);
    final String filePath = file+filename;

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);

      return null;
    }

    return filePath;
  }

  void _onCapturePressed() {
    _takePicture().then((filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });

       /* if (filePath != null) {
          Fluttertoast.showToast(
              msg: 'Picture saved to $filePath',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
        }*/
      }
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position){
        pos = position;
        global.long = position.longitude.toString();
        global.lat = position.latitude.toString();
        Fluttertoast.showToast(
            msg: ("Position : "+ position.toString()),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });
      FlutterCompass.events.listen((double orientation) {
        if (mounted){
          setState(() {
            global.orientation = orientation.toString();
            // Le listener de l'orientation continue pendant les questions pour des raisons obscures...
          });
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPreviewPage(path: imagePath)),
      );
    });
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';

    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void _permissionExternalStorage() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }
}
