library table_sticky_headers;

export 'cell_alignments.dart';
export 'cell_dimensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cell_alignments.dart';

/// Table with sticky headers. Whenever you scroll content horizontally
/// or vertically - top and left headers always stay.
class StickyHeadersTableRubro extends StatefulWidget {
  StickyHeadersTableRubro({
    Key? key,
    required this.headsLength,
    /// Number of Columns (for content only)
    required this.columnsLength,

    /// Number of Rows (for content only)
    required this.rowsLength,

    /// Title for Top Left cell (always visible)
    this.legendCell = const Text(''),
    this.legendHead = const Text(''),
    /// Builder for column titles. Takes index of content column as parameter
    /// and returns String for column title
    required this.columnsTitleBuilder,
    required this.columnsHeadBuilder,

    /// Builder for row titles. Takes index of content row as parameter
    /// and returns String for row title
    required this.rowsTitleBuilder,

    /// Builder for content cell. Takes index for content column first,
    /// index for content row second and returns String for cell
    required this.contentCellBuilder,

    /// Table cell dimensions
    this.cellDimensions = CellDimensions.base,

    /// Alignments for cell contents
    this.cellAlignments = CellAlignments.base,

    /// Callbacks for when pressing a cell
    Function()? onStickyLegendPressed,
    Function(int columnIndex)? onColumnTitlePressed,
    Function(int columnIndex)? onColumnHeadPressed,
    Function(int rowIndex)? onRowTitlePressed,
    Function(int columnIndex, int rowIndex)? onContentCellPressed,

    /// Initial scroll offsets in X and Y directions
    this.initialScrollOffsetX = 0.0,
    this.initialScrollOffsetY = 0.0,

    /// Called when scrolling has ended, passing the current offset position
    this.onEndScrolling,

    /// Scroll controllers for the table
    ScrollControllers? scrollControllers,
  })  : this.scrollControllers = scrollControllers ?? ScrollControllers(),
        this.onStickyLegendPressed = onStickyLegendPressed ?? (() {}),
        this.onColumnTitlePressed = onColumnTitlePressed ?? ((_) {}),
        this.onColumnHeadPressed = onColumnHeadPressed ?? ((_) {}),
        this.onRowTitlePressed = onRowTitlePressed ?? ((_) {}),
        this.onContentCellPressed = onContentCellPressed ?? ((_, __) {}),
        super(key: key) {
    cellDimensions.runAssertions(rowsLength, columnsLength);
    cellAlignments.runAssertions(rowsLength, columnsLength);
  }

  final int rowsLength;
  final int headsLength;
  final int columnsLength;
  final Widget legendCell;
  final Widget legendHead;
  final Widget Function(int columnIndex) columnsTitleBuilder;
  final Widget Function(int columnIndex) columnsHeadBuilder;
  final Widget Function(int rowIndex) rowsTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final CellDimensions cellDimensions;
  final CellAlignments cellAlignments;
  final Function() onStickyLegendPressed;
  final Function(int columnIndex) onColumnTitlePressed;
  final Function(int columnIndex) onColumnHeadPressed;
  final Function(int rowIndex) onRowTitlePressed;
  final Function(int columnIndex, int rowIndex) onContentCellPressed;
  final double initialScrollOffsetX;
  final double initialScrollOffsetY;
  final Function(double x, double y)? onEndScrolling;
  final ScrollControllers scrollControllers;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTableRubro> {
  late _SyncScrollController _horizontalSyncController;
  late _SyncScrollController _verticalSyncController;

  late double _scrollOffsetX;
  late double _scrollOffsetY;

  @override
  void initState() {
    super.initState();
    _scrollOffsetX = widget.initialScrollOffsetX;
    _scrollOffsetY = widget.initialScrollOffsetY;
    _verticalSyncController = _SyncScrollController([
      widget.scrollControllers._verticalTitleController,
      widget.scrollControllers._verticalBodyController,
    ]);
    _horizontalSyncController = _SyncScrollController([
      widget.scrollControllers._horizontalTitleController,
      widget.scrollControllers._horizontalTitleController2,
      widget.scrollControllers._horizontalBodyController,
    ]);
  }

  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      try{
        widget.scrollControllers._horizontalTitleController
            .jumpTo(widget.initialScrollOffsetX);
        widget.scrollControllers._verticalTitleController
            .jumpTo(widget.initialScrollOffsetY);
      }catch(e){

      }
    });
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // STICKY LEGEND
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onStickyLegendPressed,
              child: Container(
                width: widget.cellDimensions.stickyLegendWidth,
                height: widget.cellDimensions.stickyHeadHeight,
                alignment: widget.cellAlignments.stickyLegendAlignment,
                child: widget.legendHead,
              ),
            ),
            // STICKY ROW
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      widget.headsLength, (i) {
                       // int span = widget.headSpanLength[i];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => widget.onColumnHeadPressed(i),
                          child: Container(
                            width: widget.cellDimensions.stickyHeadWidth(i),
                            height: widget.cellDimensions.stickyHeadHeight,
                            alignment: widget.cellAlignments.rowAlignment(i),
                            child: widget.columnsHeadBuilder(i),
                          ),
                        );
                      },
                    ),
                  ),
                  controller: widget.scrollControllers._horizontalTitleController2,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                  _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalTitleController2,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget
                        .scrollControllers._horizontalTitleController2.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            // STICKY LEGEND
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onStickyLegendPressed,
              child: Container(
                width: widget.cellDimensions.stickyLegendWidth,
                height: widget.cellDimensions.stickyLegendHeight,
                alignment: widget.cellAlignments.stickyLegendAlignment,
                child: widget.legendCell,
              ),
            ),
            // STICKY ROW
            Expanded(
              child: NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      widget.columnsLength,
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onColumnTitlePressed(i),
                        child: Container(
                          width: widget.cellDimensions.stickyWidth(i),
                          height: widget.cellDimensions.stickyLegendHeight,
                          alignment: widget.cellAlignments.rowAlignment(i),
                          child: widget.columnsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller:
                      widget.scrollControllers._horizontalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _horizontalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._horizontalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetX = widget
                        .scrollControllers._horizontalTitleController.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
            )
          ],
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // STICKY COLUMN
              NotificationListener<ScrollNotification>(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.rowsLength,
                      (i) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onRowTitlePressed(i),
                        child: Container(
                          width: widget.cellDimensions.stickyLegendWidth,
                          height: widget.cellDimensions.stickyHeight(i),
                          alignment: widget.cellAlignments.columnAlignment(i),
                          child: widget.rowsTitleBuilder(i),
                        ),
                      ),
                    ),
                  ),
                  controller: widget.scrollControllers._verticalTitleController,
                ),
                onNotification: (ScrollNotification notification) {
                  final didEndScrolling =
                      _verticalSyncController.processNotification(
                    notification,
                    widget.scrollControllers._verticalTitleController,
                  );
                  if (widget.onEndScrolling != null && didEndScrolling) {
                    _scrollOffsetY = widget
                        .scrollControllers._verticalTitleController.offset;
                    widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                  }
                  return true;
                },
              ),
              // CONTENT
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller:
                        widget.scrollControllers._horizontalBodyController,
                    child: NotificationListener<ScrollNotification>(
                      child: SingleChildScrollView(
                        controller:
                            widget.scrollControllers._verticalBodyController,
                        child: Column(
                          children: List.generate(
                            widget.rowsLength,
                            (int rowIdx) => Row(
                              children: List.generate(
                                widget.columnsLength,
                                (int columnIdx) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => widget.onContentCellPressed(
                                      columnIdx, rowIdx),
                                  child: Container(
                                    width: widget.cellDimensions
                                        .contentSize(rowIdx, columnIdx)
                                        .width,
                                    height: widget.cellDimensions
                                        .contentSize(rowIdx, columnIdx)
                                        .height,
                                    alignment: widget.cellAlignments
                                        .contentAlignment(rowIdx, columnIdx),
                                    child: widget.contentCellBuilder(
                                        columnIdx, rowIdx),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onNotification: (ScrollNotification notification) {
                        final didEndScrolling =
                            _verticalSyncController.processNotification(
                          notification,
                          widget.scrollControllers._verticalBodyController,
                        );
                        if (widget.onEndScrolling != null && didEndScrolling) {
                          _scrollOffsetY = widget
                              .scrollControllers._verticalBodyController.offset;
                          widget.onEndScrolling!(
                              _scrollOffsetX, _scrollOffsetY);
                        }
                        return true;
                      },
                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    final didEndScrolling =
                        _horizontalSyncController.processNotification(
                      notification,
                      widget.scrollControllers._horizontalBodyController,
                    );
                    if (widget.onEndScrolling != null && didEndScrolling) {
                      _scrollOffsetX = widget
                          .scrollControllers._horizontalBodyController.offset;
                      widget.onEndScrolling!(_scrollOffsetX, _scrollOffsetY);
                    }
                    return true;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ScrollControllers {
  final ScrollController _verticalTitleController;
  final ScrollController _verticalBodyController;

  final ScrollController _horizontalBodyController;
  final ScrollController _horizontalTitleController;
  final ScrollController _horizontalTitleController2;

  ScrollControllers({
    ScrollController? verticalTitleController,
    ScrollController? verticalBodyController,
    ScrollController? horizontalBodyController,
    ScrollController? horizontalTitleController,
    ScrollController? horizontalTitleController2,
  })  : this._verticalTitleController =
            verticalTitleController ?? ScrollController(),
        this._verticalBodyController =
            verticalBodyController ?? ScrollController(),
        this._horizontalBodyController =
            horizontalBodyController ?? ScrollController(),
        this._horizontalTitleController =
            horizontalTitleController ?? ScrollController(),
        this._horizontalTitleController2 =
            horizontalTitleController2 ?? ScrollController();

  ScrollController get verticalBodyController => _verticalBodyController;


}

/// SyncScrollController keeps scroll controllers in sync.
class _SyncScrollController {
  _SyncScrollController(List<ScrollController> controllers) {
    controllers
        .forEach((controller) => _registeredScrollControllers.add(controller));
  }

  final List<ScrollController> _registeredScrollControllers = [];

  ScrollController? _scrollingController;
  bool _scrollingActive = false;

  /// Returns true if reached scroll end
  bool processNotification(
    ScrollNotification notification,
    ScrollController controller,
  ) {
    if (notification is ScrollStartNotification && !_scrollingActive) {
      _scrollingController = controller;
      _scrollingActive = true;
      return false;
    }

    if (identical(controller, _scrollingController) && _scrollingActive) {
      if (notification is ScrollEndNotification) {
        _scrollingController = null;
        _scrollingActive = false;
        return true;
      }

      if (notification is ScrollUpdateNotification) {
        for (ScrollController controller in _registeredScrollControllers) {
          if (identical(_scrollingController, controller)) continue;
          controller.jumpTo(_scrollingController!.offset);
        }
      }
    }
    return false;
  }
}

/// Dimensions for table.
class CellDimensions {
  static const CellDimensions base = CellDimensions.fixed(
    contentCellWidth: 70.0,
    contentCellHeight: 50.0,
    stickyLegendWidth: 120.0,
    stickyLegendHeight: 50.0,
    stickyHeadHeight: 50.0,
  );

  @Deprecated('Use CellDimensions.fixed instead.')
  const CellDimensions({
    /// Content cell width. Also applied to sticky row width.
    required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyHeadHeight,
  })   : this.columnWidths = null,
        this.rowHeights = null,
        this.headWidths = null;

  /// Same dimensions for each cell.
  const CellDimensions.uniform({
    required double width,
    required double height,
  }) : this.fixed(
    contentCellWidth: width,
    contentCellHeight: height,
    stickyLegendWidth: width,
    stickyLegendHeight: height,
    stickyHeadHeight: height,
  );

  /// Same dimensions for each content cell, but different dimensions for the
  /// sticky legend, column and row.
  const CellDimensions.fixed({
    /// Content cell width. Also applied to sticky row width.
    required this.contentCellWidth,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyHeadHeight,
  })   : this.columnWidths = null,
        this.rowHeights = null,
        this.headWidths = null;

  /// Different width for each column.
  const CellDimensions.variableColumnWidth({
    /// Column widths (for content only). Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    required this.columnWidths,
    required this.headWidths,

    /// Content cell height. Also applied to sticky column height.
    required this.contentCellHeight,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
    required this.stickyHeadHeight,
  })   : this.contentCellWidth = null,
        this.rowHeights = null;

  /// Different height for each row.
  const CellDimensions.variableRowHeight({
    /// Content cell width. Also applied to sticky row width.
    required this.contentCellWidth,

    /// Row heights (for content only). Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    required this.rowHeights,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyHeadHeight,
  })   : this.columnWidths = null,
        this.contentCellHeight = null,
        this.headWidths = null;

  /// Different width for each column and different height for each row.
  const CellDimensions.variableColumnWidthAndRowHeight({
    /// Column widths (for content only). Also applied to sticky row widths.
    /// Length of list needs to match columnsLength.
    required this.columnWidths,
    required this.rowHeights,

    /// Row heights (for content only). Also applied to sticky row heights.
    /// Length of list needs to match rowsLength.
    required this.headWidths,

    /// Sticky legend width. Also applied to sticky column width.
    required this.stickyLegendWidth,

    /// Sticky legend height. Also applied to sticky row height.
    required this.stickyLegendHeight,
    required this.stickyHeadHeight,
  })   : this.contentCellWidth = null,
        this.contentCellHeight = null;

  final double? contentCellWidth;
  final double? contentCellHeight;
  final List<double>? columnWidths;
  final List<double>? headWidths;
  final List<double>? rowHeights;
  final double stickyLegendWidth;
  final double stickyLegendHeight;
  final double stickyHeadHeight;

  Size contentSize(int i, int j) {
    final width =
        (columnWidths != null ? columnWidths![j] : contentCellWidth) ??
            base.contentCellWidth!;
    final height = (rowHeights != null ? rowHeights![i] : contentCellHeight) ??
        base.contentCellHeight!;
    return Size(width, height);
  }

  double stickyWidth(int i) =>
      (columnWidths != null ? columnWidths![i] : contentCellWidth) ??
          base.contentCellWidth!;

  double stickyHeadWidth(int i) =>
      (headWidths != null ? headWidths![i] : contentCellWidth) ??
          base.contentCellWidth!;

  double stickyHeight(int i) =>
      (rowHeights != null ? rowHeights![i] : contentCellHeight) ??
          base.contentCellHeight!;

  void runAssertions(int rowsLength, int columnsLength) {
    assert(contentCellWidth != null || columnWidths != null);
    assert(contentCellHeight != null || rowHeights != null);
    if (columnWidths != null) {
      assert(columnWidths!.length == columnsLength);
    }
    if (rowHeights != null) {
      assert(rowHeights!.length == rowsLength);
    }
  }
}

