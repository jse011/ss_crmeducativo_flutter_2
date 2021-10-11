import 'package:flutter/cupertino.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class ColumnCountProvider{



  static int columnsForWidthTarea(BuildContext context) {
    double widthPx = context.widthPx;
    if (widthPx >= 900) {
      return 6;
    } else if (widthPx >= 720) {
      return 5;
    } else if (widthPx >= 600) {
      return 4;
    } else if (widthPx >= 480) {
      return 3;
    } else if (widthPx >= 320) {
      return 2;
    } else {
      return 2;
    }
  }
  static double aspectRatioForWidthTarea(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if (widthPx >= 1010) {
      return (pixcel) / 1.1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1.2;
    } else if (widthPx >= 720) {
      return (pixcel) / 1.35;
    } else if (widthPx >= 600) {
      return (pixcel) / 1.25;
    } else if (widthPx >= 480) {
      return (pixcel) / 1.35;
    } else if (widthPx >= 320) {
      return (pixcel) / 1.15;
    } else {
      return (pixcel) / 1.2;
    }
  }

  static int columnsForWidthRubro(BuildContext context) {
    double widthPx = context.widthPx;
    if (widthPx >= 900) {
      return 6;
    } else if (widthPx >= 720) {
      return 5;
    } else if (widthPx >= 600) {
      return 4;
    } else if (widthPx >= 480) {
      return 3;
    } else if (widthPx >= 320) {
      return 2;
    } else {
      return 2;
    }
  }
  static double aspectRatioForWidthRubro(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if (widthPx >= 1010) {
      return (pixcel) / 1.1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1.2;
    } else if (widthPx >= 720) {
      return (pixcel) / 1.3;
    } else if (widthPx >= 600) {
      return (pixcel) / 1.2;
    } else if (widthPx >= 480) {
      return (pixcel) / 1.3;
    } else if (widthPx >= 320) {
      return (pixcel) / 1.2;
    } else {
      return (pixcel) / 1.2;
    }
  }

  static double aspectRatioForWidthTableRubro(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if (widthPx >= 900) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 720) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 600) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 480) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 320) {
      return (pixcel) * 1;
    } else {
      return (pixcel) * 1;
    }
  }

  static double aspectRatioForWidthTableEvalCapacidad(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if (widthPx >= 900) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 720) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 600) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 480) {
      return (pixcel) * 1.10;
    } else if (widthPx >= 320) {
      return (pixcel) * 1;
    } else {
      return (pixcel) * 1;
    }
  }

  static double aspectRatioForWidthTablePesoCriterio(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if (widthPx >= 900) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 720) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 600) {
      return (pixcel) * 1.15;
    } else if (widthPx >= 480) {
      return (pixcel) * 1.1;
    } else if (widthPx >= 320) {
      return (pixcel) * 1;
    } else {
      return (pixcel) * 1;
    }
  }

  static int columnsForWidthSesion(BuildContext context) {
    double widthPx = context.widthPx;
    if (widthPx >= 900) {
      return 6;
    } else if (widthPx >= 720) {
      return 5;
    } else if (widthPx >= 600) {
      return 4;
    } else if (widthPx >= 480) {
      return 3;
    } else if (widthPx >= 320) {
      return 2;
    } else {
      return 2;
    }
  }
  static double aspectRatioForWidthSesion(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X


    double widthPx = context.widthPx;
    double heightPx = context.heightPx;
    //if(heightPx < widthPx)widthPx = heightPx;
    print("widthPx: ${widthPx}");
   /* int column = columnsForWidthSesion(context);
    double margin = ((column-1) * 24) + 24 + 48;
    widthPx = widthPx - margin;
    widthPx = widthPx/column;*/
    if (widthPx >= 1010) {
      return (pixcel) / 1.1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1.2;
    } else if (widthPx >= 720) {
      return (pixcel) / 1.25;
    } else if (widthPx >= 600) {
      return (pixcel) / 1.15;
    } else if (widthPx >= 480) {
      return (pixcel) / 1.25;
    } else if (widthPx >= 320) {
      return (pixcel) / 1;
    } else {
      return (pixcel) / 1.1;
    }

  }

}