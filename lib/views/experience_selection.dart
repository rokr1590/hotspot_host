import 'dart:math'; // To generate random tilts
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_hosts/utils/colors.dart';
import 'package:hotspot_hosts/utils/globals.dart';
import 'package:hotspot_hosts/utils/toast.dart';
import 'package:hotspot_hosts/utils/widgets/background_widget.dart';
import 'package:hotspot_hosts/utils/widgets/progress_widget.dart';
import 'package:hotspot_hosts/view_models/experience_selection_vm.dart';
import 'package:hotspot_hosts/views/onboarding_question.dart';
import 'package:provider/provider.dart';

import '../bloc/experience_selection/experience_bloc.dart';
import '../bloc/experience_selection/experience_state.dart';
import '../utils/widgets/experience_selec_button.dart';

class ExperienceSelection extends StatefulWidget {
  const ExperienceSelection({super.key});

  @override
  State<ExperienceSelection> createState() => _ExperienceSelectionState();
}

class _ExperienceSelectionState extends State<ExperienceSelection> {
  late ExperienceSelectionViewModel experienceSelectionViewModel;
  late Size screenSize;
  final TextEditingController describeController = TextEditingController();
  double _progress = 50.0;

  final List<double> _tiltAngles = [];

  final FocusNode _describeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    experienceSelectionViewModel =
        Provider.of<ExperienceSelectionViewModel>(context, listen: false);
    experienceSelectionViewModel.getExperiences();
  }

  @override
  void dispose() {
    _describeFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //bool isNextEnabled = experienceSelectionViewModel.hasSelectedExperiences();
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
              child: BlocListener<ExperienceBloc, ExperienceState>(
                bloc: experienceBloc,
                listener: (context, state) {
                  if (state is FetchExperienceSuccess) {
                    if (state.response.data != null) {
                      experienceSelectionViewModel.setExperiences(
                          expData: state.response.data!);
                      if (state.response.data!.experiences != null &&
                          state.response.data!.experiences!.isNotEmpty) {
                        experienceSelectionViewModel.setExperiencesList(
                            expList: state.response.data!.experiences!);
                        if (_tiltAngles.isEmpty) {
                          for (int i = 0;
                              i <
                                  experienceSelectionViewModel
                                      .experienceList!.length;
                              i++) {
                            _tiltAngles.add(Random().nextDouble() * 0.1 - 0.05);
                          }
                        }
                        showToast("Experience Categories Fetched!",
                            ToastType.success, screenSize, context);
                      } else {
                        showToast("Oops ! No Data Found", ToastType.warning,
                            screenSize, context);
                      }
                    } else {
                      showToast("Something went wrong!!", ToastType.error,
                          screenSize, context);
                    }
                  }
                  if (state is LoadingExperienceState) {
                    experienceSelectionViewModel.isLoading = true;
                  }
                },
                child: Consumer<ExperienceSelectionViewModel>(
                  builder: (context, value, child) {
                    return Padding(
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
                                  "01",
                                  style: GoogleFonts.spaceGrotesk(
                                      color: CustomColor.progressBg,
                                      fontSize: 18),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 4, 39, 0),
                                  child: Text(
                                    "What kind of hotspots do you want to host?",
                                    style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                          value.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: CustomColor.progressComp,
                                  ),
                                )
                              : SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: experienceSelectionViewModel
                                        .experienceList!.length,
                                    itemBuilder: (context, index) {
                                      var experience =
                                          experienceSelectionViewModel
                                              .experienceList![index];
                                      var randomTilt = _tiltAngles[
                                          index]; // Random tilt between -0.05 and 0.05

                                      return GestureDetector(
                                        onTap: () {
                                          // Toggle selection state through ViewModel
                                          experienceSelectionViewModel
                                              .toggleSelection(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Transform.rotate(
                                            angle: randomTilt,
                                            child: Stack(
                                              children: [
                                                // Image Container
                                                Container(
                                                  width: screenSize.width *
                                                      0.3, // Adjust the width as needed
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(8),
                                                  //   border: Border.all(
                                                  //       color: value
                                                  //               .selectedItems[index]
                                                  //           ? CustomColor
                                                  //               .progressComp // Border color when selected
                                                  //           : Colors.transparent,
                                                  //       width: 2),
                                                  // ),
                                                  child: ColorFiltered(
                                                    colorFilter: value
                                                                .selectedItems[
                                                            index]
                                                        ? ColorFilter.mode(
                                                            Colors.transparent,
                                                            BlendMode.multiply)
                                                        : ColorFilter.mode(
                                                            Colors.grey,
                                                            BlendMode
                                                                .saturation),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        experience.imageUrl!,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Center(
                                                          child: Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                        ), // Error fallback
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.0, top: 10),
                            child: TextField(
                              controller: describeController,
                              focusNode: _describeFocusNode,
                              maxLines: 3,
                              minLines: 3,
                              cursorColor: CustomColor.progressComp,
                              //scrollController: _scrollController, // Attach scroll controller
                              decoration: InputDecoration(
                                hintText: "/Describe you perfect hotspot",
                                hintStyle: GoogleFonts.spaceGrotesk(
                                    color: CustomColor.progressBg,
                                    fontSize: 20),
                                filled: true,
                                fillColor: Color.fromRGBO(255, 255, 255, 0.05),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor
                                        .progressComp, // Color when focused
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
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0, top: 16, bottom: 16),
                            child: ExperienceSelectionButton(
                              isEnabled: value.isEnabled,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OnboardingQuestion()));
                                // Handle button press
                                // if (value.isEnabled) {
                                //   _animateProgress(); // Animate progress when button is enabled
                                // }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  void _animateProgress() {
    setState(() {
      _progress = 0.5; // Set progress to 50%
    });
  }
}
