import 'package:bai_tap/features/views/trang_nguyen.dart';
import 'package:bai_tap/features/views/vio_edu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

enum WebNames {
  trangNguyen,
  vioedu,
  unknown,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;

  final _webName = WebNames.trangNguyen.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (_webName.value) {
          case WebNames.trangNguyen:
            return const TrangNguyen();
          case WebNames.vioedu:
            return const VioEdu();
          default:
            return Container();
        }
      }
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        buttonSize: buttonSize,
        // it's the SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        label: extend ? const Text("Open") : null,
        // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        activeLabel: extend ? const Text("Close") : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: childrenButtonSize,
        visible: visible,
        direction: speedDialDirection,
        switchLabelPosition: switchLabelPosition,

        /// If true user is forced to close dial manually
        closeManually: closeManually,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: renderOverlay,
        // overlayColor: Colors.black,
        // overlayOpacity: 0.5,
        onOpen: () => debugPrint('OPENING DIAL'),
        onClose: () => debugPrint('DIAL CLOSED'),
        useRotationAnimation: useRAnimation,
        tooltip: 'Mở mục lục',
        heroTag: 'speed-dial-hero-tag',
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        elevation: 8.0,
        animationCurve: Curves.fastOutSlowIn,
        isOpenOnStart: false,
        animationDuration: const Duration(milliseconds: 150),
        shape: customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Mở Trạng Nguyên',
            onTap: () => _webName.value = WebNames.trangNguyen,
            onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.brush),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Mở VioEdu',
            onTap: () => _webName.value = WebNames.vioedu,
          ),
          // SpeedDialChild(
          //   child: const Icon(Icons.margin),
          //   backgroundColor: Colors.indigo,
          //   foregroundColor: Colors.white,
          //   label: 'Show Snackbar',
          //   onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(("Third Child Pressed")))),
          //   onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
          // ),
        ],
      ),
    );
  }
}
