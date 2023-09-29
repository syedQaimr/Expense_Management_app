import 'package:flutter/material.dart';
import 'package:mad_project/utils/constants.dart';

class HomeProfileTab extends StatelessWidget {
  const HomeProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: fontLight,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: defaultSpacing),
            child: Icon(
              Icons.settings,
              color: fontLight,
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultSpacing,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultRadius)),
                      child: Image.asset(
                        "assets/images/5856.jpg",
                        width: 100,
                      ),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 3,
                    ),
                    Text(
                      "Shehroz Ali",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700, color: fontDark),
                    ),
                    Text(
                      "shehrozrafaqat@gmail.com",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: fontLight),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    const Chip(
                      backgroundColor: primaryLight,
                      label: Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "General",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700, color: fontDark),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
