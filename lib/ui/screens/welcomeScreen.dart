import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/appTheme.dart';
import '../utils/welcomePage_strings.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              WelcomePage(
                image: WelcomepageStrings.image1,
                title: WelcomepageStrings.title1,
                subTitle: WelcomepageStrings.subTitle1,
              ),
              WelcomePage(
                image: WelcomepageStrings.image2,
                title: WelcomepageStrings.title2,
                subTitle: WelcomepageStrings.subTitle2,
              ),
              WelcomePage(
                image: WelcomepageStrings.image3,
                title: WelcomepageStrings.title3,
                subTitle: WelcomepageStrings.subTitle3,
              ),
            ],
          ),
          Positioned(
            top: 30,
            right: 20,
            child: TextButton(
              onPressed: () {},
              child: Text("Skip", style: AppTheme.subheading),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: SmoothPageIndicator(
              controller: PageController(),
              count: 3,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppTheme.brandColor,
                dotHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          image: AssetImage(image),
        ),
        Text(title, style: AppTheme.brandName, textAlign: TextAlign.center),
        const SizedBox(height: 16.0),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Text(
            subTitle,
            style: AppTheme.subheading,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
