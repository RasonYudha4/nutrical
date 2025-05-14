import 'package:flutter/material.dart';

class ActivityLevelDropdown extends StatefulWidget {
  const ActivityLevelDropdown({super.key});

  @override
  ActivityLevelDropdownState createState() => ActivityLevelDropdownState();
}

class ActivityLevelDropdownState extends State<ActivityLevelDropdown> {
  final Map<int, String> activityLevels = {
    0: 'Sedentary (little to no exercise)',
    1: 'Lightly Active (1–3 days/week)',
    2: 'Moderately Active (3–5 days/week)',
    3: 'Very Active (6–7 days/week)',
  };

  int? _selectedLevel;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFD3E671),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        activityLevels.entries.map((entry) {
                          return ListTile(
                            title: Text(entry.value),
                            onTap: () {
                              setState(() {
                                _selectedLevel = entry.key;
                              });
                              _removeOverlay();
                            },
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Color(0xFFD3E671),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedLevel != null
                    ? activityLevels[_selectedLevel!]!
                    : 'Activity Level',
              ),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }
}
