import '../../../../../utils/library_utils.dart';

///An Expansion style [ListTile] card which will look much better than
///traditional ExpansionTile, with some customization options
class ExpansionWidget extends StatefulWidget {
  ///Primary color of the [title], card, arrow widgets;

  ///Custom text color on valid values;
  final Color? validTextColor;

  ///Title widget to be shown
  final String title;

  ///Optional description widget to be shown
  final String? description;

  ///Children to be shown when expanded
  final List<Widget> children;

  ///OPtional static widget to be shown on the footer even on closed state
  final Widget? footer;

  ///To automatically hide the ExpansionWidget based on requirement
  final bool autoHide;

  ///Time to auto hide the ExpansionWidget widget in [milliseconds]
  final int autoHideDuration;

  ///Function to be executed when tapping the [ListTile]
  final VoidCallback? onTap;

  ///Card elevation value
  final double elevation;

  ///Padding to be given between [ListTile] children
  final EdgeInsetsGeometry? contentPadding;

  ///To expand the widget initially
  final bool initialyExpanded;

  ///MaxLines to control the description length
  final int? maxDescriptionLines;

  ///If the content or function is executed and the selection is valid,
  ///so we need to make the [ListTile] as currently selected/completed/done.
  final bool isValid;

  ///Outter padding of the widget
  final EdgeInsets? padding;

  const ExpansionWidget(
      {Key? key,
      this.validTextColor,
      required this.title,
      this.description,
      this.children = const <Widget>[],
      this.footer,
      this.autoHide = false,
      this.autoHideDuration = 5000,

      ///5 Seconds
      this.onTap,
      this.elevation = 0.0,
      this.contentPadding,
      this.initialyExpanded = false,
      this.maxDescriptionLines,
      this.isValid = false,
      this.padding})
      : super(key: key);

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  bool expanded = false;

  @override
  void initState() {
    expanded = widget.initialyExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        child: Column(
          children: <Widget>[
            infoTile(),
            childrenWidgets(),
          ],
        ),
      ),
    );
  }

  ///Where the basic information is shown, even the widget is not expanded
  ///
  Widget infoTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTitle(),
            const SizedBox(height: 3),
            _infoSubtitle() ?? SizedBox.shrink(),
          ],
        ),
        _expansionButton(),
      ],
    );
  }

  Widget _infoTitle() {
    return Text(
      widget.title,
      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget? _infoSubtitle() {
    return Visibility(
      visible: expanded ? false : true,
      child: Text(
        widget.description ?? '',
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _expansionButton() {
    return GestureDetector(
        onTap: changeExpansionFn,
        child: Text(
          expanded ? 'Cancel' : 'Edit',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
        ));
  }

  Widget childrenWidgets() {
    return CrossFade(
      useCenter: false,
      show: expanded,
      child: ListView(
        shrinkWrap: true,
        children: widget.children,
      ),
    );
  }

  ///Function to change the expansion state automatically
  Future<void> changeExpansionFn() async {
    if (widget.autoHide) {
      ///If already expanded, then don't allow to expand again!
      if (expanded) return;

      if (mounted) setState(() => expanded = true);
      await Widgets.wait(widget.autoHideDuration);
      if (mounted) setState(() => expanded = false);
    } else {
      if (mounted) setState(() => expanded = !expanded);
    }
  }
}
