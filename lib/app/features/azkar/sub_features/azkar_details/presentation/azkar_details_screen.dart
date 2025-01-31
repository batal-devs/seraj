// ignore_for_file: deprecated_member_use

import 'package:athar/app/core/extension_methods/bloc_x.dart';
import 'package:athar/app/core/extension_methods/text_style_x.dart';
import 'package:athar/app/core/l10n/l10n.dart';
import 'package:athar/app/core/theming/app_colors_extension.dart';
import 'package:athar/app/core/theming/text_theme_extension.dart';
import 'package:athar/app/features/azkar/domain/azkar.dart';
import 'package:athar/app/features/azkar/sub_features/azkar_details/bloc/azkar_details_bloc.dart';
import 'package:athar/app/features/settings/domain/settings.dart';
import 'package:athar/app/features/settings/settings/settings_bloc.dart';
import 'package:athar/app/widgets/screen.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class AzkarDetailsScreen extends StatelessWidget {
  const AzkarDetailsScreen(this.azkar, {super.key});

  final Azkar azkar;

  static const String name = 'azkar-details-screen';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AzkarDetailsBloc, AzkarDetailsState>(
      listenWhen: (previous, current) => previous.action != current.action,
      listener: (context, state) {
        if (state.action.isDeleted) context.pop();
      },
      child: Screen(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(10.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: context.pop,
                          child: Icon(Icons.keyboard_arrow_right_outlined, size: 32.w),
                        ),
                        const Spacer(flex: 2),
                        Text(
                          context.l10n.azkar,
                          style: context.textThemeX.heading.bold,
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                    Gap(20.h),
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorsX.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorsX.primary.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(25.h),
                            const Spacer(flex: 4),
                            Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: Text(
                                azkar.text,
                                style: context.textThemeX.heading.copyWith(
                                  fontSize: 24.sp,
                                  fontFamily: GoogleFonts.amiri().fontFamily,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Spacer(flex: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BlocSelector<AzkarDetailsBloc, AzkarDetailsState, bool>(
                                  selector: (state) => state.azkar.isFavourite,
                                  builder: (context, isFavourite) {
                                    return IconButton(
                                      onPressed: () => context
                                          .read<AzkarDetailsBloc>()
                                          .add(const AzkarFavouriteToggled()),
                                      icon: Icon(
                                        isFavourite
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                        color: isFavourite
                                            ? context.colorsX.error
                                            : context.colorsX.onBackground,
                                        size: 20.r,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.trash, size: 18.r),
                                  onPressed: () =>
                                      context.read<AzkarDetailsBloc>().add(const AzkarDeleted()),
                                ),
                                Gap(10.w),
                              ],
                            ),
                            const Spacer(),
                            Gap(25.h),
                          ],
                        ),
                      ),
                    ),
                    Gap(25.h),
                    BlocBuilder<AzkarDetailsBloc, AzkarDetailsState>(
                      builder: (context, state) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              context.l10n.repetition,
                              style: context.textThemeX.heading.bold.copyWith(
                                fontSize: 20.sp,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: context.colorsX.primary.withValues(alpha: 0.5),
                              child: IconButton(
                                onPressed: () =>
                                    context.read<AzkarDetailsBloc>().add(IncrementCounter()),
                                icon: Icon(
                                  FontAwesomeIcons.add,
                                  size: 20.r,
                                  color: context.colorsX.onBackground,
                                ),
                              ),
                            ),
                            Gap(10.w),
                            Text(
                              state.counterValue.toString(),
                              style: context.textThemeX.heading.bold.copyWith(
                                fontSize: 18.sp,
                                color: azkar.noOfRepetitions == state.counterValue
                                    ? context.colorsX.error
                                    : context.colorsX.primary,
                              ),
                            ),
                            Text(
                              '/${azkar.noOfRepetitions}',
                              style: context.textThemeX.heading.bold.copyWith(
                                fontSize: 18.sp,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                            Gap(10.w),
                            CircleAvatar(
                              backgroundColor: context.colorsX.primary.withValues(alpha: 0.5),
                              child: IconButton(
                                onPressed: () =>
                                    context.read<AzkarDetailsBloc>().add(DecrementCounter()),
                                icon: Icon(
                                  FontAwesomeIcons.subtract,
                                  size: 20.r,
                                  color: context.colorsX.onBackground,
                                ),
                              ),
                            ),
                            Gap(10.w),
                          ],
                        );
                      },
                    ),
                    Gap(25.h),
                    ExpandablePanel(
                      theme: ExpandableThemeData(
                        hasIcon: true,
                        expandIcon: Icons.expand_more,
                        collapseIcon: Icons.expand_less,
                        iconSize: 24.w,
                        iconColor: context.colorsX.onBackground,
                      ),
                      header: Text(
                        context.l10n.explaination,
                        style: context.textThemeX.heading.bold.copyWith(fontSize: 20.sp),
                      ),
                      collapsed: const SizedBox(),
                      expanded: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                        child: Container(
                          height: 200.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: context.colorsX.primary.withValues(alpha: 0.5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Text(
                              azkar.description ?? context.l10n.noDescription,
                              style: context.textThemeX.medium.copyWith(fontSize: 18.sp),
                              textDirection: context.settingsBloc.state.settings.isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _ShareAndCopyWidget(text: azkar.text),
            Gap(20.h)
          ],
        ),
      ),
    );
  }
}

class _ShareAndCopyWidget extends StatelessWidget {
  final String text;

  const _ShareAndCopyWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: context.colorsX.primary.withValues(alpha: 0.5),
            ),
            onPressed: () => Share.share(text),
            icon: Icon(Icons.share, color: context.colorsX.onBackground),
            label: Text(
              context.l10n.share,
              style: context.textThemeX.medium.copyWith(color: context.colorsX.onBackground),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: context.colorsX.primary.withValues(alpha: 0.5),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.copied)),
              );
            },
            icon: Icon(Icons.copy, color: context.colorsX.onBackground),
            label: Text(
              context.l10n.copy,
              style: context.textThemeX.medium.copyWith(color: context.colorsX.onBackground),
            ),
          ),
        ],
      ),
    );
  }
}
