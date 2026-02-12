
import '../../../../../../utils/library_utils.dart';

class TextEditorBottomSheet extends StatefulWidget {
  final CreateReelsController controller;
  final Map<String, dynamic>? existingTextData; // For editing existing text
  
  const TextEditorBottomSheet({
    super.key,
    required this.controller,
    this.existingTextData,
  });

  @override
  State<TextEditorBottomSheet> createState() => _TextEditorBottomSheetState();
}

class _TextEditorBottomSheetState extends State<TextEditorBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Color _selectedColor = Colors.white;
  double _fontSize = 20.0;
  String _selectedFontStyle = 'Roboto';
  bool _isBold = false;
  bool _isItalic = false;
  bool _hasUnderline = false;
  final bool _hasStrikethrough = false;
  TextAlign _textAlign = TextAlign.center;
  Color? _backgroundColor; // Track background color
  String? _editingTextId;
  String? _selectedComponent; // Track which component is selected (null, 'font', 'color', 'effects', etc.)
  
  final List<Map<String, dynamic>> _fontStyles = [
    {'name': 'Roboto', 'style': GoogleFonts.roboto},
    {'name': 'Mono', 'style': GoogleFonts.monoton},
    {'name': 'Sans', 'style': GoogleFonts.openSans},
    {'name': 'oswald', 'style': GoogleFonts.oswald},
    {'name': 'Playfair', 'style': GoogleFonts.playfairDisplay},
    {'name': 'Gravitas', 'style': GoogleFonts.gravitasOne},
    {'name': 'Dancing', 'style': GoogleFonts.dancingScript},
    {'name': 'Anton', 'style': GoogleFonts.anton},
    {'name': 'Satisfy', 'style': GoogleFonts.satisfy},
    {'name': 'Lavishly', 'style': GoogleFonts.lavishlyYours},
  ];
  
  final List<Color> _colors = [
    Colors.white,
    Colors.black,
    Color(0xFF9B59B6), // Purple
    Color(0xFF3498DB), // Blue
    Color(0xFF2ECC71), // Green
    Color(0xFFF1C40F), // Yellow
    Color(0xFFE67E22), // Orange
    Color(0xFFE74C3C), // Red
    Color(0xFFE91E63), // Magenta/Pink
  ];
  
  @override
  void initState() {
    super.initState();
    
    // If editing existing text, populate fields
    if (widget.existingTextData != null) {
      final data = widget.existingTextData!;
      _textController.text = data['text'] as String? ?? '';
      _selectedColor = data['color'] as Color? ?? Colors.white;
      _fontSize = data['fontSize'] as double? ?? 20.0;
      _selectedFontStyle = data['fontStyle'] as String? ?? 'Roboto';
      _isBold = data['isBold'] as bool? ?? false;
      _isItalic = data['isItalic'] as bool? ?? false;
      _hasUnderline = data['hasUnderline'] as bool? ?? false;
      _textAlign = data['textAlign'] as TextAlign? ?? TextAlign.center;
      _backgroundColor = data['backgroundColor'] as Color?;
      _editingTextId = data['id'] as String?;
      
      // Ensure editing text ID is set in controller to hide it from create reels screen
      // (It should already be set in DraggableTextWidget, but set it here as well for safety)
      if (_editingTextId != null && widget.controller.editingTextId.value != _editingTextId) {
        widget.controller.editingTextId.value = _editingTextId!;
      }
    }
    
    // Auto-focus the text field when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    
    _textController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    // Clear editing text ID when closing editor (if not already cleared in _handleDone)
    if (widget.controller.editingTextId.value == _editingTextId) {
      widget.controller.editingTextId.value = '';
    }
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Container(
        height: ((MediaQuery.of(context).size.height)),
        width: (MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
        ),
        child: Stack(
          fit: StackFit.expand,
        children: [
          // Top TextField area with background color
          Positioned(
            top: 150,
            left: 10,
            right: 10,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width) - 40,
                  minWidth: 50,
                ),
                decoration: BoxDecoration(
                  // color: _backgroundColor, // Apply background color
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IntrinsicWidth(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    style: _getTextStyle(),
                    autofocus: true, // Auto-focus when bottom sheet opens
                    maxLines: null,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    textAlign: _textAlign,
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: _fontSize,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {}); // Update UI when text changes
                    },
                  ),
                ),
              ),
            ),
          ),
          // Left side vertical text size slider
          Positioned(
            left: 16,
            top: 150,
            child: SizedBox(
              height: 220,
              child: FontSizeSlider(
                onChanged: (double value) {
                  setState(() => _fontSize = value);
                },
              ),
            ),
          ),


          // Top header with Done button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    SizedBox(width: 60),
                // Text(
                //   _editingTextId != null ? 'Edit Text' : 'Add Text',
                //   style: AppTextStyles.subHeading.copyWith(
                //     color: whiteColor,
                //     fontSize: 18,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(
                        onTap: (){
                          debugPrint('==============>>>${_textController.text} ');
                          if (_textController.text.isNotEmpty) {
                            if (_editingTextId != null) {
                              // Update existing text
                              final index = widget.controller.addedTexts.indexWhere(
                                    (t) => t['id'] == _editingTextId,
                              );
                              if (index != -1) {
                                // Update text content first
                                widget.controller.addedTexts[index]['text'] = _textController.text;

                                // Update all style properties
                                widget.controller.updateTextStyle(
                                  _editingTextId!,
                                  isBold: _isBold,
                                  isItalic: _isItalic,
                                  hasUnderline: _hasUnderline,
                                  color: _selectedColor,
                                  fontSize: _fontSize,
                                  fontStyle: _selectedFontStyle,
                                  textAlign: _textAlign,
                                  backgroundColor: _backgroundColor,
                                );

                                // Ensure background color is updated
                                widget.controller.addedTexts[index]['backgroundColor'] = _backgroundColor;

                                // Refresh the list to update UI
                                widget.controller.addedTexts.refresh();

                                // Clear editing ID BEFORE closing so text reappears immediately
                                widget.controller.editingTextId.value = '';

                                // Force controller update
                                widget.controller.update();
                              }
                            } else {
                              // Add new text
                              final textWidth = _textController.text.length * _fontSize * 0.6;
                              final centerX = (Get.width - textWidth) / 2;
                              final centerY = Get.height / 3;

                              widget.controller.addText(
                                _textController.text,
                                _selectedColor,
                                _fontSize,
                                Offset(centerX.clamp(0.0, Get.width - 100), centerY),
                                fontStyle: _selectedFontStyle,
                                isBold: _isBold,
                                isItalic: _isItalic,
                                hasUnderline: _hasUnderline,
                                textAlign: _textAlign,
                                backgroundColor: _backgroundColor,
                              );
                            }
                            Get.back();
                          } else {
                            ShowToast.show(
                              message: 'Please enter some text',
                              type: ToastType.error,
                            );
                          }
                        },
                    title: 'Done',
                    isDisable: false,
                    bgColor: Colors.transparent,
                      //   child: Text(
                      //     'Done',
                      //     style: TextStyle(
                      // color: whiteColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      ),
                ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom toolbar and keyboard area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sub-component toolbar (appears when component is selected)
                  if (_selectedComponent != null) _buildSubToolbar(),
                  
                  // Main toolbar row
                  _buildMainToolbar(),
                ],
              ),
            ),
          ),
          
        ],
      ),
    ));
  }
  
  Widget _buildMainToolbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          color: greyBgColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Font style (Aa)
              _buildToolbarIcon(
                imagePath: AppImages.fontAdjustmentIcon,
                label: 'Aa',
                isSelected: _selectedComponent == 'font',
                onTap: () {
                  setState(() {
                    _selectedComponent = _selectedComponent == 'font' ? null : 'font';
                  });
                },
              ),

              // Color picker (rainbow circle) - Use Material icon since color_plate.png doesn't exist
              _buildToolbarIcon(
                icon: Icons.color_lens,
                isColor: false,
                imagePath: AppImages.colorPlatIcon,
                label: '',
                isSelected: _selectedComponent == 'color',
                onTap: () {
                  setState(() {
                    _selectedComponent = _selectedComponent == 'color' ? null : 'color';
                  });
                },
              ),

              // Effects (///A - strikethrough)
              _buildToolbarIcon(
                imagePath: AppImages.textEditIcon,
                label: '///A',
                isSelected: _selectedComponent == 'effects',
                onTap: () {
                  setState(() {
                    _selectedComponent = _selectedComponent == 'effects' ? null : 'effects';
                  });
                },
              ),

              // Menu (alignment)
              _buildToolbarIcon(
                imagePath: AppImages.textAlignIcon,
                label: '',
                isSelected: _selectedComponent == 'menu',
                onTap: () {
                  setState(() {
                    _selectedComponent = _selectedComponent == 'menu' ? null : 'menu';
                  });
                },
              ),

              // Background (A in square)
              _buildToolbarIcon(
                imagePath: AppImages.textBgFillIcon,
                label: 'A',
                isSelected: _selectedComponent == 'background',
                onTap: () {
                  setState(() {
                    _selectedComponent = _selectedComponent == 'background' ? null : 'background';
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSubToolbar() {
    switch (_selectedComponent) {
      case 'font':
        return _buildFontSubToolbar();
      case 'color':
        return _buildColorSubToolbar();
      case 'effects':
        return _buildEffectsSubToolbar();
      // case 'animation':
      //   return _buildAnimationSubToolbar();
      case 'menu':
        return _buildMenuSubToolbar();
      case 'background':
        return _buildBackgroundSubToolbar();
      default:
        return SizedBox.shrink();
    }
  }
  
  Widget _buildFontSubToolbar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
      ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _fontStyles.length,
              itemBuilder: (context, index) {
                final font = _fontStyles[index];
                final isSelected = _selectedFontStyle == font['name'];
                final fontBuilder = font['style'] as TextStyle Function({
                Color? color,
                double? fontSize,
                FontWeight? fontWeight,
                });
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFontStyle = font['name'] as String;
                      // Keep sub-toolbar open - don't close it
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                     padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    decoration: BoxDecoration(
                      color: isSelected ? whiteColor : blackColor.withValues(alpha: 0.1),
                      border: Border.all(color: whiteColor,width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        font['name'] as String,
                        style: fontBuilder(
                          color: isSelected ? Colors.black : whiteColor,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildColorSubToolbar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
      ),
            child: Row(
              children: [
                // Eyedropper icon
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
              color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.colorize, color: whiteColor, size: 20),
                ),
                12.width,
                // Color squares
                Expanded(
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final color = _colors[index];
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                              // Keep sub-toolbar open - don't close it
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? whiteColor : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
              },
                  ),
                ),
              ],
            ),
    );
  }
  
  Widget _buildEffectsSubToolbar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
      ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
          _buildSubToolbarButton(
                  icon: Icons.format_bold,
                  label: 'Bold',
                  isSelected: _isBold,
                  onTap: () {
                    setState(() {
                      _isBold = !_isBold;
                      // Keep sub-toolbar open - don't close it
                    });
                  },
                ),
          _buildSubToolbarButton(
                  icon: Icons.format_italic,
                  label: 'Italic',
                  isSelected: _isItalic,
                  onTap: () {
                    setState(() {
                      _isItalic = !_isItalic;
                      // Keep sub-toolbar open - don't close it
                    });
                  },
                ),
          _buildSubToolbarButton(
            icon: Icons.format_underlined,
            label: 'Underline',
            isSelected: _hasUnderline,
            onTap: () {
              setState(() {
                _hasUnderline = !_hasUnderline;
                // Keep sub-toolbar open - don't close it
              });
            },
          ),
          // _buildSubToolbarButton(
          //   icon: Icons.format_strikethrough,
          //   label: 'Strike',
          //   isSelected: _hasStrikethrough,
          //   onTap: () {
          //     setState(() {
          //       _hasStrikethrough = !_hasStrikethrough;
          //       // Keep sub-toolbar open - don't close it
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
  
  Widget _buildMenuSubToolbar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        // color: Colors.grey[800]?.withValues(alpha:0.95),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left alignment
          _buildSubToolbarButton(
            icon: Icons.format_align_left,
            label: 'Left',
            isSelected: _textAlign == TextAlign.start,
            onTap: () {
              setState(() {
                _textAlign = TextAlign.start;
                // Keep sub-toolbar open - don't close it
              });
            },
          ),
          // Center alignment
          _buildSubToolbarButton(
            icon: Icons.format_align_center,
            label: 'Center',
            isSelected: _textAlign == TextAlign.center,
            onTap: () {
              setState(() {
                _textAlign = TextAlign.center;
                // Keep sub-toolbar open - don't close it
              });
            },
          ),
          // Right alignment
          _buildSubToolbarButton(
            icon: Icons.format_align_right,
            label: 'Right',
            isSelected: _textAlign == TextAlign.end,
            onTap: () {
              setState(() {
                _textAlign = TextAlign.end;
                // Keep sub-toolbar open - don't close it
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundSubToolbar() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
      ),
      child: Row(
        children: [
          // Fill toggle button
          // _buildSubToolbarButton(
          //   icon: Icons.format_color_fill,
          //   label: 'Fill',
          //   isSelected: _backgroundColor != null,
          //   onTap: () {
          //     setState(() {
          //       // Toggle background: null → white → black → null
          //       if (_backgroundColor == null) {
          //         _backgroundColor = Colors.white;
          //         // Only change text color if it's white or black
          //         if (_selectedColor == Colors.white) {
          //           _selectedColor = Colors.black;
          //         } else if (_selectedColor == Colors.black) {
          //           _selectedColor = Colors.white;
          //         }
          //         // If text color is other than white/black, keep it unchanged
          //       } else if (_backgroundColor == Colors.white) {
          //         _backgroundColor = Colors.black;
          //         // Only change text color if it's white or black
          //         if (_selectedColor == Colors.white) {
          //           _selectedColor = Colors.black;
          //         } else if (_selectedColor == Colors.black) {
          //           _selectedColor = Colors.white;
          //         }
          //         // If text color is other than white/black, keep it unchanged
          //       } else {
          //         _backgroundColor = null;
          //         // Keep text color as is when removing background
          //       }
          //       // Keep sub-toolbar open - don't close it
          //     });
          //   },
          // ),
          // 12.width,
          // Background color selection
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colors.length + 1, // +1 for transparent/no background
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Transparent/no background option
                  final isSelected = _backgroundColor == null;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _backgroundColor = null;
                        // Keep sub-toolbar open - don't close it
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected ? whiteColor : Colors.grey[600]!,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.clear,
                          color: isSelected ? whiteColor : Colors.grey[400],
                          size: 18,
                        ),
                      ),
                    ),
                  );
                } else {
                  final color = _colors[index - 1];
                  final isSelected = _backgroundColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _backgroundColor = color;
                        // Only change text color if it's white or black
                        if (_selectedColor == Colors.white && color == Colors.white) {
                          _selectedColor = Colors.black;
                        } else if (_selectedColor == Colors.black && color == Colors.black) {
                          _selectedColor = Colors.white;
                        }
                        // If text color is other than white/black, keep it unchanged
                        // Keep sub-toolbar open - don't close it
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected ? whiteColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildToolbarIcon({
    String? imagePath,
    IconData? icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isColor=true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 45,
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected?grey575654Color:null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: imagePath != null
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    imagePath,
                    color: !isColor?null: whiteColor,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image fails to load
                      return Icon(
                        icon ?? Icons.error_outline,
                        color: whiteColor,
                        size: 25,
                      );
                    },
                  ),
                )
              : Icon(
                  icon ?? Icons.error_outline,
                  color: whiteColor,
                  size: 25,
                ),
        ),
      ),
    );
  }
  
  Widget _buildSubToolbarButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
            color: isSelected ? whiteColor : Colors.transparent,
              border: Border.all(color: whiteColor,width: 0.5
              ),
              borderRadius: BorderRadius.circular(8),
            ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected?blackColor:whiteColor, size: 18),
            4.width,
            Text(
              label,
              style: AppTextStyles.regular.copyWith(
                color:isSelected?blackColor: whiteColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDone() {
    if (_textController.text.isNotEmpty) {
      if (_editingTextId != null) {
        // Update existing text
        final index = widget.controller.addedTexts.indexWhere(
          (t) => t['id'] == _editingTextId,
        );
        if (index != -1) {
          // Update text content first
          widget.controller.addedTexts[index]['text'] = _textController.text;

          // Update all style properties
          widget.controller.updateTextStyle(
            _editingTextId!,
            isBold: _isBold,
            isItalic: _isItalic,
            hasUnderline: _hasUnderline,
            color: _selectedColor,
            fontSize: _fontSize,
            fontStyle: _selectedFontStyle,
            textAlign: _textAlign,
            backgroundColor: _backgroundColor,
          );

          // Ensure background color is updated
          widget.controller.addedTexts[index]['backgroundColor'] = _backgroundColor;

          // Refresh the list to update UI
          widget.controller.addedTexts.refresh();

          // Clear editing ID BEFORE closing so text reappears immediately
          widget.controller.editingTextId.value = '';

          // Force controller update
          widget.controller.update();
        }
      } else {
        // Add new text
        final textWidth = _textController.text.length * _fontSize * 0.6;
        final centerX = (Get.width - textWidth) / 2;
        final centerY = Get.height / 3;

        widget.controller.addText(
          _textController.text,
          _selectedColor,
          _fontSize,
          Offset(centerX.clamp(0.0, Get.width - 100), centerY),
          fontStyle: _selectedFontStyle,
          isBold: _isBold,
          isItalic: _isItalic,
          hasUnderline: _hasUnderline,
          textAlign: _textAlign,
          backgroundColor: _backgroundColor,
        );
      }
      Get.back();
    } else {
      ShowToast.show(
        message: 'Please enter some text',
        type: ToastType.error,
      );
    }
  }
  
  TextStyle _getTextStyle() {
    final selectedFont = _fontStyles.firstWhere(
      (font) => font['name'] == _selectedFontStyle,
      orElse: () => _fontStyles[0],
    );
    
    final fontBuilder = selectedFont['style'] as TextStyle Function({
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
    });
    
    final baseStyle = fontBuilder(
      color: _selectedColor,
      fontSize: _fontSize,
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
    );
    
    return baseStyle.copyWith(
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      decorationColor: whiteColor,
      decorationThickness: 2,
      decoration: _hasUnderline
          ? TextDecoration.underline
          : (_hasStrikethrough ? TextDecoration.lineThrough : null),
    );
  }
}
