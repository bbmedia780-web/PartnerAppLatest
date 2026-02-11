
import '../../../../../../utils/library_utils.dart';

class DraggableTextWidget extends StatefulWidget {
  final Map<String, dynamic> textData;
  final CreateReelsController controller;
  final Size? mediaSize; // Media display size
  final Offset? mediaOffset; // Media display offset from screen
  
  const DraggableTextWidget({
    super.key,
    required this.textData,
    required this.controller,
    this.mediaSize,
    this.mediaOffset,
  });

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  Offset? _dragStartPosition; // Position when drag starts
  double _lastScale = 1.0;
  double _lastRotation = 0.0;
  bool _isDragging = false;
  bool _isScaling = false;
  
  Map<String, dynamic> _getTextData() {
    try {
      return widget.controller.addedTexts.firstWhere(
        (t) => t['id'] == widget.textData['id'],
        orElse: () => widget.textData,
      );
    } catch (e) {
      return widget.textData;
    }
  }
  
  // Get TextStyle based on font style name
  TextStyle _getTextStyle({
    required String fontStyle,
    required Color color,
    required double fontSize,
    required bool isBold,
    required bool isItalic,
    required bool hasUnderline,
  }) {
    TextStyle baseStyle;
    
    // Map font style names to GoogleFonts
    switch (fontStyle) {
      case 'Roboto':
        baseStyle = GoogleFonts.roboto(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Mono':
        baseStyle = GoogleFonts.monoton(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Sans':
        baseStyle = GoogleFonts.openSans(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'oswald':
        baseStyle = GoogleFonts.oswald(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Playfair':
        baseStyle = GoogleFonts.playfairDisplay(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Gravitas':
        baseStyle = GoogleFonts.gravitasOne(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Dancing':
        baseStyle = GoogleFonts.dancingScript(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Anton':
        baseStyle = GoogleFonts.anton(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Satisfy':
        baseStyle = GoogleFonts.satisfy(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      case 'Lavishly':
        baseStyle = GoogleFonts.lavishlyYours(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
        break;
      default:
        // Default to Roboto if font style not found
        baseStyle = GoogleFonts.roboto(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        );
    }
    
    // Apply underline decoration if needed
    if (hasUnderline) {
      return baseStyle.copyWith(decoration: TextDecoration.underline);
    }
    
    return baseStyle;
  }
  
  @override
  Widget build(BuildContext context) {
    final textId = widget.textData['id'] as String;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate media bounds (where text can be positioned)
    final mediaSize = widget.mediaSize ?? Size(screenWidth, screenHeight);
    final mediaOffset = widget.mediaOffset ?? Offset.zero;
    final mediaLeft = mediaOffset.dx;
    final mediaTop = mediaOffset.dy;
    final mediaRight = mediaLeft + mediaSize.width;
    final mediaBottom = mediaTop + mediaSize.height;
    
    return Obx(() {
      // Check if text still exists
      if (!widget.controller.addedTexts.any((t) => t['id'] == textId)) {
        return SizedBox.shrink();
      }
      
      // Always read latest data from controller
      final textData = _getTextData();
      
      final String text = textData['text'] as String;
      final Color color = textData['color'] as Color;
      final double fontSize = textData['fontSize'] as double;
      final String fontStyle = textData['fontStyle'] as String? ?? 'Roboto';
      final bool isBold = textData['isBold'] as bool? ?? false;
      final bool isItalic = textData['isItalic'] as bool? ?? false;
      final bool hasUnderline = textData['hasUnderline'] as bool? ?? false;
      final Color? backgroundColor = textData['backgroundColor'] as Color?;
      final Offset position = textData['position'] as Offset;
      final double scale = textData['scale'] as double? ?? 1.0;
      final double rotation = textData['rotation'] as double? ?? 0.0;
      final TextAlign textAlign = textData['textAlign'] as TextAlign? ?? TextAlign.center;
      
      // Estimate text size for clamping within media bounds
      final estimatedTextWidth = (text.length * fontSize * 0.6).clamp(50.0, mediaSize.width * 0.9);
      final estimatedTextHeight = (fontSize * 1.5).clamp(30.0, mediaSize.height * 0.3);
      
      // Constrain position to media bounds
      final maxX = mediaRight - estimatedTextWidth;
      final maxY = mediaBottom - estimatedTextHeight;
      final minX = mediaLeft;
      final minY = mediaTop;
      
      // Clamp position to media bounds
      final clampedX = position.dx.clamp(minX, maxX.clamp(minX, mediaRight));
      final clampedY = position.dy.clamp(minY, maxY.clamp(minY, mediaBottom));
      
      return Positioned(
        left: clampedX,
        top: clampedY,
        child: GestureDetector(
          onTap: () {
            if (!_isDragging && !_isScaling) {
              // Toggle background: white → black → transparent → white
              widget.controller.toggleTextBackground(textId);
            }
          },
          onLongPress: () {
            if (!_isDragging && !_isScaling) {
              _showEditDeleteDialog();
            }
          },
          
          // Scale gesture handles both drag (single finger) and scale/rotate (two fingers)
          onScaleStart: (details) {
            setState(() {
              _lastScale = scale;
              _lastRotation = rotation;
              _dragStartPosition = position;
              
              // Determine if this is scaling (2+ fingers) or dragging (1 finger)
              if (details.pointerCount > 1) {
                _isScaling = true;
                _isDragging = false;
              } else {
                _isDragging = true;
                _isScaling = false;
              }
            });
          },
          
          onScaleUpdate: (details) {
            if (_dragStartPosition == null) return;
            
            // Two fingers: Scale and rotate
            if (details.pointerCount > 1) {
              setState(() {
                _isScaling = true;
                _isDragging = false;
              });
              
              final newScale = (_lastScale * details.scale).clamp(0.5, 3.0);
              final newRotation = _lastRotation + details.rotation;
              
              widget.controller.updateTextScale(textId, newScale);
              widget.controller.updateTextRotation(textId, newRotation);
            } 
            // Single finger: Drag
            else {
              setState(() {
                _isDragging = true;
                _isScaling = false;
              });
              
              // Calculate new position relative to media bounds
              final newX = (_dragStartPosition!.dx + details.focalPointDelta.dx)
                  .clamp(minX, maxX.clamp(minX, mediaRight));
              final newY = (_dragStartPosition!.dy + details.focalPointDelta.dy)
                  .clamp(minY, maxY.clamp(minY, mediaBottom));
              
              final newPosition = Offset(newX, newY);
              
              // Update drag start position for continuous dragging
              setState(() {
                _dragStartPosition = newPosition;
              });
              
              widget.controller.updateTextPosition(textId, newPosition);
            }
          },
          
          onScaleEnd: (details) {
            setState(() {
              _isScaling = false;
              _isDragging = false;
              _dragStartPosition = null;
            });
          },

          child: Transform.rotate(
            angle: rotation,
            child: IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  text,
                  textAlign: textAlign,
                  style: _getTextStyle(
                    fontStyle: fontStyle,
                    color: color,
                    fontSize: fontSize, // Font size changes inversely with scale
                    isBold: isBold,
                    isItalic: isItalic,
                    hasUnderline: hasUnderline,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  
  void _openTextEditor() {
    final textData = _getTextData();
    final textId = textData['id'] as String?;
    
    // Set editing text ID IMMEDIATELY before opening bottom sheet
    // This ensures the text is hidden from create reels screen right away
    if (textId != null) {
      widget.controller.editingTextId.value = textId;
    }
    
    // Import the text editor bottom sheet
    Get.bottomSheet(
      TextEditorBottomSheet(
        controller: widget.controller,
        existingTextData: textData,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
  
  void _showEditDeleteDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit option
            ListTile(
              leading: Icon(Icons.edit, color: whiteColor),
              title: Text(
                'Edit',
                style: TextStyle(color: whiteColor, fontSize: 16),
              ),
              onTap: () {
                Get.back(); // Close dialog
                _openTextEditor(); // Open text editor with pre-filled data
              },
            ),
            Divider(color: Colors.grey[700], height: 1),
            // Delete option
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              onTap: () {
                widget.controller.removeText(widget.textData['id'] as String);
                Get.back(); // Close dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}

