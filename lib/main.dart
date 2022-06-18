import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_loading_animation/modal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    loadFonts();
    super.initState();
  }

  loadFonts() {
    GoogleFonts.quicksand();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Animation for Image Loading',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1611558709798-e009c8fd7706?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1601288496920-b6154fe3626a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1507114845806-0347f6150324?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1606893995103-a431bce9c219?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1642802767829-bea7b5a6c15f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1512850692650-c382e34f7fb2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1617079098163-43d49057277d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1622347434466-147a44cffda7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1625698457101-fec2f565a8f0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
              CustomImage(
                  imageURL:
                      'https://images.unsplash.com/photo-1654797314248-c41c8a8cf35b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&h=800&q=80'),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomImage extends StatefulWidget {
  final String imageURL;
  const CustomImage({Key? key, required this.imageURL}) : super(key: key);

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late ImageStream _imageStream;
  late ImageInfo _imageInfo;

  late ImageDetail _imageDetail;
  late ImageValueNotifier _imageValueNotifier;

  @override
  void initState() {
    _imageDetail = ImageDetail();
    _imageValueNotifier = ImageValueNotifier(_imageDetail);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _animation = Tween<double>(begin: 600.0, end: 400.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    super.initState();

    _imageStream = NetworkImage(widget.imageURL +
            '?${DateTime.now().millisecondsSinceEpoch.toString()}')
        .resolve(const ImageConfiguration());

    _imageStream.addListener(
      ImageStreamListener(
        (info, value) {
          _imageInfo = info;
          _imageValueNotifier.changeLoadingState(true);
          _controller.forward();
        },
        onChunk: (event) {
          _imageValueNotifier
              .changeCumulativeBytesLoaded(event.expectedTotalBytes!);
          _imageValueNotifier
              .changeCumulativeBytesLoaded(event.cumulativeBytesLoaded);
        },
      ),
    );
  }

  @override
  void dispose() {
    _imageInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _imageValueNotifier,
      builder: (context, ImageDetail value, child) {
        return Container(
          height: 400.0,
          width: 300.0,
          margin: const EdgeInsets.all(15.0),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: !value.isLoaded
              ? Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 40,
                  ),
                )
              : Center(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return OverflowBox(
                        minHeight: 400.0,
                        maxHeight: 600.0,
                        minWidth: 300.0,
                        maxWidth: 500.0,
                        child: SizedBox(
                          height: _animation.value,
                          width: _animation.value - 100.0,
                          child: child,
                        ),
                      );
                    },
                    child: RawImage(
                      image: _imageInfo.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
