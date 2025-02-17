import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Running on: $_platformVersion\n',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final file = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      SocialShare.shareInstagramStory(
                        file.path,
                        backgroundTopColor: "#ffffff",
                        backgroundBottomColor: "#000000",
                        attributionURL: "https://deep-link-url",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share On Instagram Story"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final file =
                            await File('${directory.path}/temp.png').create();
                        await file.writeAsBytes(image);

                        SocialShare.shareInstagramStory(
                          file.path,
                          backgroundTopColor: "#ffffff",
                          backgroundBottomColor: "#000000",
                          attributionURL: "https://deep-link-url",
                          backgroundImagePath: file.path,
                        ).then((data) {
                          print(data);
                        });
                      });
                    },
                    child: Text("Share On Instagram Story with background"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        SocialShare.shareFacebook('http://facebook.com');
                      },
                      child: Text('Share facebook post')),
                  ElevatedButton(
                      onPressed: () {
                        SocialShare.shareLine('Hello');
                      },
                      child: Text('Share Line message')),
                  ElevatedButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final file =
                            await File('${directory.path}/temp.png').create();
                        await file.writeAsBytes(image);
                        //facebook appId is mandatory for andorid or else share won't work
                        Platform.isAndroid
                            ? SocialShare.shareFacebookStory(
                                file.path,
                                "#ffffff",
                                "#000000",
                                "https://google.com",
                                appId: "xxxxxxxxxxxxx",
                              ).then((data) {
                                print(data);
                              })
                            : SocialShare.shareFacebookStory(
                                file.path,
                                "#ffffff",
                                "#000000",
                                "https://google.com",
                              ).then((data) {
                                print(data);
                              });
                      });
                    },
                    child: Text("Share On Facebook Story"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.copyToClipboard(
                        "This is Social Share plugin",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Copy to clipboard"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.shareTwitter(
                        "This is Social Share twitter example",
                        hashtags: ["hello", "world", "foo", "bar"],
                        url: "https://google.com/#/hello",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share on twitter"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.shareSms(
                        "This is Social Share Sms example",
                        url: "\nhttps://google.com/",
                        trailingText: "\nhello",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share on Sms"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await screenshotController.capture().then((image) async {
                        SocialShare.shareOptions("Hello world").then((data) {
                          print(data);
                        });
                      });
                    },
                    child: Text("Share Options"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.shareWhatsapp(
                        "Hello World \n https://google.com",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share on Whatsapp"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.shareTelegram(
                        "Hello World \n https://google.com",
                      ).then((data) {
                        print(data);
                      });
                    },
                    child: Text("Share on Telegram"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SocialShare.checkInstalledAppsForShare().then((data) {
                        print(data.toString());
                      });
                    },
                    child: Text("Get all Apps"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
