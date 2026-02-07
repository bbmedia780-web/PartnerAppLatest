import '../../../../../../utils/library_utils.dart';

class HashtagSelectionBottomSheet extends StatefulWidget {
  final Function(String hashtag) onHashtagSelected;
  final VoidCallback? onClose;
  
  const HashtagSelectionBottomSheet({
    super.key,
    required this.onHashtagSelected,
    this.onClose,
  });

  @override
  State<HashtagSelectionBottomSheet> createState() => _HashtagSelectionBottomSheetState();
}

class _HashtagSelectionBottomSheetState extends State<HashtagSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _filteredHashtags = [];
  
  // Sample hashtag data - in production, this would come from an API
  final List<Map<String, dynamic>> _allHashtags = [
    {'tag': 'newarrivals', 'count': 30412587},
    {'tag': 'newzealand', 'count': 25738561},
    {'tag': 'newbooks', 'count': 1923090},
    {'tag': 'newcollection', 'count': 68357032},
    {'tag': 'newmusic', 'count': 51380970},
    {'tag': 'newpost', 'count': 92147313},
    {'tag': 'newlook', 'count': 14058550},
    {'tag': 'newyear', 'count': 50000000},
    {'tag': 'newyearfirstfestival', 'count': 1000000},
    {'tag': 'newstyle', 'count': 25000000},
    {'tag': 'newtrend', 'count': 18000000},
    {'tag': 'newdesign', 'count': 32000000},
    {'tag': 'newfashion', 'count': 45000000},
    {'tag': 'newbeauty', 'count': 28000000},
    {'tag': 'newhair', 'count': 15000000},
  ];
  
  // Quick suggestions for the bottom bar
  final List<String> _quickSuggestions = [
    'new',
    'newyearfirstfestival',
    'newyear',
  ];
  
  @override
  void initState() {
    super.initState();
    _filteredHashtags = _allHashtags;
    _searchController.addListener(_filterHashtags);
    
    // Auto-focus search field when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _filterHashtags() {
    final query = _searchController.text.toLowerCase().replaceAll('#', '');
    setState(() {
      if (query.isEmpty) {
        _filteredHashtags = _allHashtags;
      } else {
        _filteredHashtags = _allHashtags
            .where((hashtag) => hashtag['tag'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }
  
  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
  
  void _selectHashtag(String hashtag) {
    widget.onHashtagSelected(hashtag);
    if (widget.onClose != null) {
      widget.onClose!();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Compact overlay mode - 400 height box
    return Container(
      height: 400,
      width: Get.width - 32, // Account for left/right padding
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (compact)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New reel',
                  style: AppTextStyles.subHeading.copyWith(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: whiteColor, size: 20),
                  onPressed: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Search input
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: TextStyle(color: whiteColor),
                decoration: InputDecoration(
                  hintText: 'Search hashtags...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixText: '#',
                  prefixStyle: TextStyle(color: whiteColor, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          
          12.height,
          
          // Hashtag list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredHashtags.length,
              itemBuilder: (context, index) {
                final hashtag = _filteredHashtags[index];
                final tag = hashtag['tag'] as String;
                final count = hashtag['count'] as int;
                
                return InkWell(
                  onTap: () => _selectHashtag(tag),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[800]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '#$tag',
                            style: AppTextStyles.subHeading.copyWith(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.width,
                          Text(
                            '${_formatCount(count)} public posts',
                            style: AppTextStyles.light.copyWith(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ),
                );
              },
            ),
          ),
          
            // Quick suggestions bar
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey[700]!,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.grey[400]),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _quickSuggestions.map((suggestion) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => _selectHashtag(suggestion),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[700],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '#$suggestion',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),

    );
  }
}

