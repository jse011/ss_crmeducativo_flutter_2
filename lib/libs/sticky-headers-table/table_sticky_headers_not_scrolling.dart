library table_sticky_headers;

export 'cell_alignments.dart';
export 'cell_dimensions.dart';

import 'package:flutter/material.dart';

import 'cell_alignments.dart';
import 'cell_dimensions.dart';

/// Table with sticky headers. Whenever you scroll content horizontally
/// or vertically - top and left headers always stay.
class StickyHeadersTableNotExpandedNotScrolling extends StatefulWidget {
  StickyHeadersTableNotExpandedNotScrolling({
    Key? key,

    /// Number of Columns (for content only)
    required this.columnsLength,

    /// Number of Rows (for content only)
    required this.rowsLength,

    /// Title for Top Left cell (always visible)
    this.legendCell = const Text(''),

    /// Builder for column titles. Takes index of content column as parameter
    /// and returns String for column title
    required this.columnsTitleBuilder,

    /// Builder for row titles. Takes index of content row as parameter
    /// and returns String for row title
    required this.rowsTitleBuilder,

    /// Builder for content cell. Takes index for content column first,
    /// index for content row second and returns String for cell
    required this.contentCellBuilder,

    /// Table cell dimensions
    this.cellDimensions = CellDimensions.base,

    /// Alignments for cell contents
    this.cellAlignments/* = CellAlignments.base*/,

    /// Callbacks for when pressing a cell
    Function()? onStickyLegendPressed,
    Function(int columnIndex)? onColumnTitlePressed,
    Function(int rowIndex)? onRowTitlePressed,
    Function(int columnIndex, int rowIndex)? onContentCellPressed,


  })  :this.onStickyLegendPressed = onStickyLegendPressed ?? (() {}),
        this.onColumnTitlePressed = onColumnTitlePressed ?? ((_) {}),
        this.onRowTitlePressed = onRowTitlePressed ?? ((_) {}),
        this.onContentCellPressed = onContentCellPressed ?? ((_, __) {}),
        super(key: key) {
    cellDimensions.runAssertions(rowsLength, columnsLength);
    cellAlignments?.runAssertions(rowsLength, columnsLength);
  }

  final int rowsLength;
  final int columnsLength;
  final Widget legendCell;
  final Widget Function(int columnIndex) columnsTitleBuilder;
  final Widget Function(int rowIndex) rowsTitleBuilder;
  final Widget Function(int columnIndex, int rowIndex) contentCellBuilder;
  final CellDimensions cellDimensions;
  final CellAlignments? cellAlignments;
  final Function() onStickyLegendPressed;
  final Function(int columnIndex) onColumnTitlePressed;
  final Function(int rowIndex) onRowTitlePressed;
  final Function(int columnIndex, int rowIndex) onContentCellPressed;

  @override
  _StickyHeadersTableState createState() => _StickyHeadersTableState();
}

class _StickyHeadersTableState extends State<StickyHeadersTableNotExpandedNotScrolling> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onStickyLegendPressed,
              child: Container(
                width: widget.cellDimensions.stickyLegendWidth,
                height: widget.cellDimensions.stickyLegendHeight,
                alignment: widget.cellAlignments?.stickyLegendAlignment,
                child: widget.legendCell,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
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
                      alignment: widget.cellAlignments?.rowAlignment(i),
                      child: widget.columnsTitleBuilder(i),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // STICKY COLUMN
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: List.generate(
                  widget.rowsLength,
                      (i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.onRowTitlePressed(i),
                    child: Container(
                      width: widget.cellDimensions.stickyLegendWidth,
                      height: widget.cellDimensions.stickyHeight(i),
                      alignment: widget.cellAlignments?.columnAlignment(i),
                      child: widget.rowsTitleBuilder(i),
                    ),
                  ),
                ),
              ),
            ),
            // CONTENT
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
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
                                ?.contentAlignment(rowIdx, columnIdx),
                            child: widget.contentCellBuilder(
                                columnIdx, rowIdx),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
