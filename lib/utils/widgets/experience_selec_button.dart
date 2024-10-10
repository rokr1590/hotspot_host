import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspot_hosts/utils/colors.dart';

class ExperienceSelectionButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const ExperienceSelectionButton({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5, // Button is disabled with lower opacity
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  Color.fromRGBO(34, 34, 34, 0.4), // Gradient start
                  Color.fromRGBO(153, 153, 153, 0.4), // Gradient middle
                  Color.fromRGBO(34, 34, 34, 0.4), // Gradient end
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: CustomColor.progressBg) // Rounded corners
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8), // Space between text and icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
