import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controllers/welcome_page_controller.dart';
import '../theme/app_theme.dart';
import '../utils/welcome_page_strings.dart';
import 'package:get/get.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controler = Get.put(WelcomePageController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controler.pageController,
            onPageChanged: controler.updatePageIndicator,
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
          SkipButton(),
          DotNavigation(),
          NextButton(),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: kBottomNavigationBarHeight,
      child: ElevatedButton(
        onPressed: () => WelcomePageController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: AppTheme.brandColor,
          iconSize: 40,
        ),
        child: const Icon(Icons.arrow_right, color: Colors.white),
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 24,
      child: TextButton(
        onPressed: () => WelcomePageController.instance.skipPage(),
        child: Text("Skip", style: AppTheme.subheading),
      ),
    );
  }
}

class DotNavigation extends StatelessWidget {
  const DotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WelcomePageController.instance;

    return Positioned(
      bottom: kBottomNavigationBarHeight + 25,
      left: 24,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: const ExpandingDotsEffect(
          activeDotColor: AppTheme.brandColor,
          dotColor: Colors.blueGrey,
          dotHeight: 6,
        ),
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
