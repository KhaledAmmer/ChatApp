import 'dart:io';
import 'package:khaledchat/Api/googleMap/GoMap.dart';
import 'package:khaledchat/provider/MyProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khaledchat/Api/Fireabase/FireBaseTask.dart';
import 'package:khaledchat/component/toastMsg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';

const theSource = AudioSource.microphone;

class Services {
  static final Services service = Services();
  static FlutterSoundRecorder? mRecorder =
      FlutterSoundRecorder(logLevel: Level.debug);
  bool _mRecorderIsInited = false;
  String _voicePath = "";

  pickImage(ImageSource, context, reciver, {isVideo = false,userImage=false}) async {
    var picker = ImagePicker();
    if (!isVideo) {
      var pickedFile = await picker.pickImage(source: ImageSource);
      var imageFile = File(pickedFile!.path);
      toastMsg("Please wait a few seconds for upload the image", context);
      if(!userImage)
      FirebaseTask.firebaseTask.uploadFileToFirebase("2", imageFile, reciver);
    } else {
      var pickedFile = await picker.pickVideo(source: ImageSource);
      var VideoFile = File(pickedFile!.path);
      toastMsg("Please wait a few seconds for upload the video", context);
      FirebaseTask.firebaseTask.uploadFileToFirebase("3", VideoFile, reciver);
    }
  }

  pickAudioFile(context, reciver) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    PlatformFile file = result!.files.first;
    String path = file.path.toString();
    toastMsg("Please wait a few seconds for upload the audio", context);
    FirebaseTask.firebaseTask.uploadFileToFirebase("4", File(path), reciver);
  }

  openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await mRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  record(reciver) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    var voicePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';
    mRecorder!.startRecorder(
      toFile: voicePath,
      audioSource: theSource,
    );
    this._voicePath = voicePath;
  }

  stopRecorder(reciver, context) async {

    await mRecorder!.stopRecorder();
    FirebaseTask.firebaseTask
        .uploadFileToFirebase("5", File(this._voicePath), reciver);

  }

  ShearMyLocation(reciver)async{
    var pos= await GoMap().GetCurrentPositions();
    String msg= "${pos[0]}+${pos[1]}";

   FirebaseTask.firebaseTask.Sendmage(type: "6",text: msg,reciver: reciver);

  }


}
