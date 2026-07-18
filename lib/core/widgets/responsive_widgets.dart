import 'package:flutter/material.dart';
import '../extensions/responsive_extensions.dart';

/// Responsive Container - scales based on device type
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobilePadding;
  final double? tabletPadding;
  final double? desktopPadding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobilePadding = 20,
    this.tabletPadding,
    this.desktopPadding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveDimension(
      mobile: mobilePadding ?? 20,
      tablet: tabletPadding,
      desktop: desktopPadding,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}

/// Responsive Grid View - automatically adjusts columns based on screen size
class ResponsiveGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double? mobileChildHeight;
  final double? tabletChildHeight;
  final double? desktopChildHeight;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mobileChildHeight,
    this.tabletChildHeight,
    this.desktopChildHeight,
    this.mobileColumns = 2,
    this.tabletColumns = 3,
    this.desktopColumns = 4,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.getGridColumns(
      mobileColumns: mobileColumns,
      tabletColumns: tabletColumns,
      desktopColumns: desktopColumns,
    );

    final childAspectRatio = _getChildAspectRatio(context);

    return GridView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }

  double _getChildAspectRatio(BuildContext context) {
    if (mobileChildHeight != null ||
        tabletChildHeight != null ||
        desktopChildHeight != null) {
      final columns = context.getGridColumns(
        mobileColumns: mobileColumns,
        tabletColumns: tabletColumns,
        desktopColumns: desktopColumns,
      );
      final height = context.responsiveDimension(
        mobile: mobileChildHeight ?? 200,
        tablet: tabletChildHeight,
        desktop: desktopChildHeight,
      );

      final itemWidth =
          (context.screenWidth - (columns - 1) * crossAxisSpacing) / columns;
      return itemWidth / height;
    }
    return 1;
  }
}

/// Responsive Row - switches between row and column based on screen size
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final double? mobileSpacing;
  final double? tabletSpacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 12,
    this.mobileSpacing,
    this.tabletSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final gap = context.responsiveDimension(
      mobile: mobileSpacing ?? spacing,
      tablet: tabletSpacing ?? spacing,
      desktop: spacing,
    );

    if (context.isMobile) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, gap),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addSpacing(children, gap),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double gap) {
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: gap, height: gap));
      }
    }
    return result;
  }
}

/// Responsive Sized Box - scales based on device type
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = mobileWidth != null
        ? context.responsiveDimension(
            mobile: mobileWidth!,
            tablet: tabletWidth,
            desktop: desktopWidth,
          )
        : null;

    final height = mobileHeight != null
        ? context.responsiveDimension(
            mobile: mobileHeight!,
            tablet: tabletHeight,
            desktop: desktopHeight,
          )
        : null;

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

/// Responsive Expanded - respects min/max constraints
class ResponsiveExpanded extends StatelessWidget {
  final Widget child;
  final int flex;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;

  const ResponsiveExpanded({
    super.key,
    required this.child,
    this.flex = 1,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          minHeight: minHeight ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: child,
      ),
    );
  }
}

/// Responsive Padding - applies different padding based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double mobileHorizontal;
  final double mobileVertical;
  final double? tabletHorizontal;
  final double? tabletVertical;
  final double? desktopHorizontal;
  final double? desktopVertical;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobileHorizontal = 16,
    this.mobileVertical = 12,
    this.tabletHorizontal,
    this.tabletVertical,
    this.desktopHorizontal,
    this.desktopVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsiveSymmetricPadding(
        horizontalMobile: mobileHorizontal,
        verticalMobile: mobileVertical,
        horizontalTablet: tabletHorizontal,
        verticalTablet: tabletVertical,
        horizontalDesktop: desktopHorizontal,
        verticalDesktop: desktopVertical,
      ),
      child: child,
    );
  }
}

/// Responsive Text - scales font size based on device
class ResponsiveText extends StatelessWidget {
  final String text;
  final double mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final TextDecoration? decoration;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = context.responsiveFontSize(
      mobile: mobileFontSize,
      tablet: tabletFontSize,
      desktop: desktopFontSize,
    );

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive App Bar - hides/shows elements based on screen size
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double? elevation;
  final bool hideActionsOnMobile;

  const ResponsiveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.hideActionsOnMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: hideActionsOnMobile && context.isMobile ? null : actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Layout builder with device type - cleaner alternative to LayoutBuilder
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext) mobile;
  final Widget Function(BuildContext)? tablet;
  final Widget Function(BuildContext)? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return context.buildResponsive(
      mobile: mobile(context),
      tablet: tablet != null ? tablet!(context) : null,
      desktop: desktop != null ? desktop!(context) : null,
    );
  }
}
