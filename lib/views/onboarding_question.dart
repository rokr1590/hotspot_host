import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_hosts/utils/widgets/background_widget.dart';
import 'package:hotspot_hosts/utils/widgets/experience_selec_button.dart';
import 'package:hotspot_hosts/view_models/onboarding_question_vm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/widgets/progress_widget.dart';

class OnboardingQuestion extends StatefulWidget {
  const OnboardingQuestion({super.key});

  @override
  State<OnboardingQuestion> createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  late OnboardingQuestionViewModel onboardingQuestionViewModel;
  late Size screenSize;
  final TextEditingController intentTextController = TextEditingController();
  double _progress = 0.0;
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool _isAudioRecorded = false;
  bool _isRecording = false;
  bool _isRecorded = false;

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;

    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio');
    setState(() {
      _isAudioRecorded = false;
      _isRecording = true;
      _isRecorded = false; // Reset when starting a new recording
    });
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recorded audio $audioFile');
    setState(() {
      _isAudioRecorded = true;
      _isRecording = false;
      _isRecorded = true; // Set to true after stopping the recording
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onboardingQuestionViewModel =
        Provider.of<OnboardingQuestionViewModel>(context, listen: false);
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    // TODO: implement dispose
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
            //Functionaity yet to be added
          },
        ),
        title: WaveProgressBar(
          progress: _progress, // Use animated progress value
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
                                color: CustomColor.progressBg, fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 4, 39, 0),
                            child: Text(
                              "Why do you want to host with us?",
                              style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                    child: Text(
                      "Tell us about your intent and what motivates you to create experiences.",
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: screenSize.height * 0.018,
                          color: CustomColor.progressBg),
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
                            color: CustomColor.progressBg, fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color:
                                CustomColor.progressComp, // Color when focused
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
                                  horizontal: 16, vertical: 8),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: screenSize.height * 0.15,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12),
                                      child: Text(
                                          _isRecorded
                                              ? "Audio Recorded"
                                              : "Recording Audio...",
                                          style: GoogleFonts.spaceGrotesk(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: _isRecorded
                                                      ? Color.fromRGBO(
                                                          89, 97, 255, 1)
                                                      : Color.fromRGBO(
                                                          145, 150, 255, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: GestureDetector(
                                                child: Icon(
                                                    _isRecorded
                                                        ? Icons.check
                                                        : recorder.isRecording
                                                            ? Icons.stop
                                                            : Icons
                                                                .mic_none_outlined,
                                                    color: Colors.white),
                                                onTap: () async {
                                                  if (recorder.isRecording) {
                                                    await stop();
                                                  } else {
                                                    await record();
                                                  }

                                                  setState(() {});
                                                },
                                              )),
                                          // if (_isAudioRecorded)
                                          //   Expanded(
                                          //       child: Text(
                                          //     "WaveForm",
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //   )),
                                          StreamBuilder<RecordingDisposition>(
                                            stream: recorder.onProgress,
                                            builder: (context, snapshot) {
                                              final duration = snapshot.hasData
                                                  ? snapshot.data!.duration
                                                  : Duration.zero;
                                              String twoDigits(int n) =>
                                                  n.toString().padLeft(2, "0");
                                              final twoDigitMinutes = twoDigits(
                                                  duration.inMinutes
                                                      .remainder(60));
                                              final twoDigitSeconds = twoDigits(
                                                  duration.inSeconds
                                                      .remainder(60));

                                              return Text(
                                                '$twoDigitMinutes:$twoDigitSeconds',
                                                style: const TextStyle(
                                                    color: CustomColor
                                                        .progressComp,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Consumer<OnboardingQuestionViewModel>(
                            builder: (context, viewModel, child) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color:
                                        Color.fromRGBO(255, 255, 255, 0.09))),
                            width: screenSize.width * 0.3,
                            //height: screenSize.height * 0.05,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: screenSize.height * 0.07,
                                    // color: Colors.grey,
                                    child: IconButton(
                                      icon: const Icon(Icons.mic_none_outlined,
                                          color: Colors.white),
                                      onPressed: () {
                                        viewModel.startRecording();
                                        //print("Pressed");
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 0.2, // Width of the divider
                                  height: 30, // Full height
                                  color: Colors.white, // Color of the divider
                                ),
                                Expanded(
                                  child: Container(
                                    height: screenSize.height * 0.07,
                                    //color: Colors.red,
                                    child: IconButton(
                                      icon: const Icon(Icons.videocam_outlined,
                                          color: Colors.white),
                                      onPressed: () {
                                        //print("Pressed");
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ExperienceSelectionButton(
                              isEnabled: true, onPressed: () {}),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))),
      ),
    );
  }
}
