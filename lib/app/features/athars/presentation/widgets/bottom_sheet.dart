part of '../athars_screen.dart';

Future<void> _openBottomSheet(BuildContext context) async {
  // ignore: inference_failure_on_function_invocation
  await showModalBottomSheet(
    elevation: 0,
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity,
        height: 330.h,
        decoration: BoxDecoration(
          color: context.colorsX.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.h),
            topRight: Radius.circular(24.h),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          child: _BottomSheetBody(
            items: [context.l10n.propheticHadith, context.l10n.quranicVerse, context.l10n.others],
          ),
        ),
      );
    },
  );
}

class _BottomSheetBody extends StatelessWidget {
  const _BottomSheetBody({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DragIndicator(),
        Gap(10.h),
        Text(context.l10n.addNew, style: context.textThemeX.large.bold),
        Gap(20.h),
        Expanded(
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Gap(20.h),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    context.pushNamed(AddHadith.name);
                }
              },
              child: _BottomSheetWidget(items[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomSheetWidget extends StatelessWidget {
  const _BottomSheetWidget(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.w),
        color: context.colorsX.primary,
      ),
      child: Center(child: Text(label, style: context.textThemeX.large.bold)),
    );
  }
}

class _DragIndicator extends StatelessWidget {
  const _DragIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 6.h,
        width: 80.w,
        decoration: BoxDecoration(
          color: context.colorsX.onBackground,
          borderRadius: BorderRadius.circular(32.w),
        ),
      ),
    );
  }
}
