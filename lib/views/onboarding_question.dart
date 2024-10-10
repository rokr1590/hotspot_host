import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_hosts/utils/widgets/background_widget.dart';
import 'package:hotspot_hosts/utils/widgets/experience_selec_button.dart';
import 'package:hotspot_hosts/view_models/onboarding_question_vm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as img; // Add this for image processing

import '../utils/colors.dart';
import '../utils/widgets/progress_widget.dart';
import 'package:video_thumbnail/video_thumbnail.dart'
    as vd; // Import video_thumbnail package
import 'package:path_provider/path_provider.dart';

class OnboardingQuestion extends StatefulWidget {
  const OnboardingQuestion({super.key});

  @override
  State<OnboardingQuestion> createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  late OnboardingQuestionViewModel onboardingQuestionViewModel;
  late Size screenSize;
  final TextEditingController intentTextController = TextEditingController();
  double _progress = 100.0;

  // Audio Recorder
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool _isAudioRecorded = false;
  bool _isRecording = false;
  bool _isRecorded = false;

  // Video Recorder
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isVideoRecording = false;
  String? _videoPath;
  VideoPlayerController? _videoPlayerController;
  File? _thumbnail;

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
    await _initializeControllerFuture;
  }

  Future<void> record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
    setState(() {
      _isAudioRecorded = false;
      _isRecording = true;
      _isRecorded = false;
    });
  }

  Future<void> stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recorded audio $audioFile');
    setState(() {
      _isAudioRecorded = true;
      _isRecording = false;
      _isRecorded = true;
    });
  }

  Future<void> startVideoRecording() async {
    await _initializeControllerFuture;
    setState(() {
      _isVideoRecording = true;
    });
    _videoPath = '${Directory.systemTemp.path}/${DateTime.now()}.mp4';
    await _cameraController.startVideoRecording();
  }

  Future<void> stopVideoRecording() async {
    await _cameraController.stopVideoRecording();
    setState(() {
      _isVideoRecording = false;
    });

    // Generate thumbnail
    _generateThumbnail(_videoPath!);
    _videoPlayerController = VideoPlayerController.file(File(_videoPath!));
    await _videoPlayerController!.initialize();
    setState(() {});
  }

  Future<void> _generateThumbnail(String videoPath) async {
    final thumbnailPath = await vd.VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory())
          .path, // Save thumbnail to temporary directory
      imageFormat: vd.ImageFormat.JPEG,
      maxWidth: 128, // Specify the width of the thumbnail
      quality: 75,
    );

    if (thumbnailPath != null) {
      setState(() {
        _thumbnail = File(
            thumbnailPath); // Update thumbnail state with the generated thumbnail file
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onboardingQuestionViewModel =
        Provider.of<OnboardingQuestionViewModel>(context, listen: false);
    initRecorder();
    initCamera();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    _cameraController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //Functionality yet to be added
          },
        ),
        title: WaveProgressBar(
          progress: _progress,
          waveColor: CustomColor.progressComp,
          backgroundColor: CustomColor.progressBg,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
      body: HotspotBackground(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "02",
                          style: GoogleFonts.spaceGrotesk(
                            color: CustomColor.progressBg,
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 4, 39, 0),
                          child: Text(
                            "Why do you want to host with us?",
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                    child: Text(
                      "Tell us about your intent and what motivates you to create experiences.",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: screenSize.height * 0.018,
                        color: CustomColor.progressBg,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
                    child: TextField(
                      controller: intentTextController,
                      maxLines: 8,
                      minLines: 8,
                      cursorColor: CustomColor.progressComp,
                      decoration: InputDecoration(
                        hintText: "/Start typing here",
                        hintStyle: GoogleFonts.spaceGrotesk(
                          color: CustomColor.progressBg,
                          fontSize: 20,
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: CustomColor.progressComp,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Consumer<OnboardingQuestionViewModel>(
                    builder: (context, viewModel, child) {
                      return viewModel.isRecording
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: CustomColor.progressBg),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Recording audio...",
                                          style: GoogleFonts.spaceGrotesk(
                                              color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon:
                                            Icon(Icons.stop, color: Colors.red),
                                        onPressed: () async {
                                          await stop();
                                          viewModel.stopRecording();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : _isAudioRecorded
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: CustomColor.progressBg),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Audio recorded successfully!",
                                              style: GoogleFonts.spaceGrotesk(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.play_arrow,
                                                color: Colors.green),
                                            onPressed: () {
                                              // Implement audio playback
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    await record();
                                    viewModel.startRecording();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColor.progressComp,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                  child: Text(
                                    "Record Audio",
                                    style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white),
                                  ),
                                );
                    },
                  ),
                  SizedBox(height: 20),
                  // Video Recording Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _isVideoRecording ? null : startVideoRecording,
                        child: Text(_isVideoRecording
                            ? "Recording..."
                            : "Start Video Recording"),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed:
                            _isVideoRecording ? stopVideoRecording : null,
                        child: Text("Stop Video Recording"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Display Video Player if video is recorded
                  if (_videoPlayerController != null &&
                      _videoPlayerController!.value.isInitialized)
                    Container(
                      height: 200,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  SizedBox(height: 10),
                  // Display Thumbnail if available
                  if (_thumbnail != null)
                    Image.file(_thumbnail!, height: 100, width: 100),
                  SizedBox(height: 20),
                  ExperienceSelectionButton(
                    isEnabled: true,
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
