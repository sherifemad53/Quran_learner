import 'package:flutter/material.dart';
import 'package:quranic_tool_box/common/constants.dart';

import '../../app_routes.dart';

class AyaAhdithSemanticSearchScreen extends StatelessWidget {
  const AyaAhdithSemanticSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size? size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Semantic Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(kdefualtPadding),
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Semantic Search is search with “meaning” , this can refer to Different parts',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Understanding the query ,  instead of finding literal matches.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Representation of knowledge for later retrieval and comparison. ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        fixedSize: Size.fromWidth(size.width * 0.7),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context).backgroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.ayatMotshbha);
                      },
                      child: FittedBox(
                        child: Text(
                          'الايات المشابهة',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        fixedSize: Size.fromWidth(size.width * 0.7),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context).backgroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.ahadithMotshbha);
                      },
                      child: FittedBox(
                        child: Text(
                          'الاحاديث المشابهة',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const AppButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 100,
      // height: 40,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        // color: const Color(0xffee8f8b),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
