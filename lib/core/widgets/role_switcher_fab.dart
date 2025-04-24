import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/controllers/home_page_controller.dart';
import 'custom_snackbar.dart';

class RoleSwitcherFab extends StatefulWidget {
  final void Function()? onPressed;

  const RoleSwitcherFab({
    super.key,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RoleSwitcherFabState createState() => _RoleSwitcherFabState();
}

class _RoleSwitcherFabState extends State<RoleSwitcherFab> {
  bool isLoading = false;
  Offset _fabPosition = Offset.zero;
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tooltipKey.currentState?.ensureTooltipVisible();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set the initial position of the FAB to the bottom-right corner of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      _fabPosition = Offset(screenWidth - 86, screenHeight - 236);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      left: _fabPosition.dx.clamp(0.0, screenWidth - 56),
      // Keep within left-right screen bounds
      top: _fabPosition.dy.clamp(0.0, screenHeight - 56),
      // Keep within top-bottom screen bounds
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            // Calculate the new position but constrain it within screen bounds
            _fabPosition = Offset(
              (_fabPosition.dx + details.delta.dx)
                  .clamp(0.0, screenWidth - 56), // 56 is the FAB size
              (_fabPosition.dy + details.delta.dy)
                  .clamp(0.0, screenHeight - 56),
            );
          });
        },
        child: Tooltip(
          key: _tooltipKey,
          message: 'Drag to change its position',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: isLoading ? null : widget.onPressed,
                backgroundColor: const Color.fromARGB(123, 0, 0, 0),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              const Text(
                'Browse as',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              const Text(
                'Customer',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
