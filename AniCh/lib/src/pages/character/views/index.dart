import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/character/controller.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class CharacterIndexView extends StatelessWidget {
  const CharacterIndexView({super.key, this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
    // 设置状态栏图标的亮度
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: currentBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));
    return GetBuilder(
        init: CharacterIndexController(),
        builder: (controller) {
          return SafeArea(
            top: false,
            bottom: false,
            maintainBottomViewPadding: true,
            child: Builder(builder: (context) {
              final parentController = PrimaryScrollController.of(context);
              final scrollController =
                  SubordinateScrollController(parentController);
              return KeepAliveWrapper(
                  child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (isTop) {
                    } else {
                      if (controller.isLoading.isFalse) {
                        controller.more();
                      }
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  displacement: 40,
                  edgeOffset: 60,
                  onRefresh: () async {
                    await controller.reload();
                  },
                  child: controller.obx(
                    (state) {
                      return CustomScrollView(
                        key: const PageStorageKey('character-index'),
                        controller:
                            active ? scrollController : ScrollController(),
                        shrinkWrap: true,
                        slivers: [
                          SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context)),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            sliver: SliverGrid.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 150,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.6),
                                itemCount: state!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/bangumi/${state[index].id}',
                                          arguments: state[index]);
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomCenter,
                                                    // fit: StackFit.expand,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                        ),
                                                        child: state[index]
                                                                .image!
                                                                .isEmpty
                                                            ? noImage
                                                            : Image.network(
                                                                state[index]
                                                                    .image!,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return noImage;
                                                                },
                                                              ),
                                                      ),
                                                      Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                                minWidth: double
                                                                    .infinity),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 50,
                                                                bottom: 5,
                                                                left: 10,
                                                                right: 10),
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .bottomCenter,
                                                                end: Alignment.topCenter,
                                                                stops: const [
                                                              0,
                                                              1
                                                            ],
                                                                colors: [
                                                              Colors.black
                                                                  .withAlpha(
                                                                      150),
                                                              Colors.transparent
                                                            ])),
                                                        child: Text(
                                                          state[index]
                                                                  .status!
                                                                  .isEmpty
                                                              ? '敬请期待'
                                                              : state[index]
                                                                          .status ==
                                                                      'released'
                                                                  ? '全1集'
                                                                  : state[index]
                                                                              .status ==
                                                                          'finale'
                                                                      ? '全${state[index].episodesTotal}集'
                                                                      : '更新至第${state[index].episode}集',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                                '/bangumi/${state[index].id}',
                                                                arguments:
                                                                    state[
                                                                        index]);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              state[index].title!,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            Opacity(
                                              opacity: 0.7,
                                              child: Text(
                                                state[index].tagline!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SliverToBoxAdapter(child: Obx(() {
                            return SizedBox(
                                height: 5,
                                child: Visibility(
                                  visible: controller.isLoading.isTrue,
                                  maintainSize: false,
                                  maintainSemantics: false,
                                  maintainAnimation: false,
                                  child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey,
                                      valueColor: AlwaysStoppedAnimation(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                ));
                          }))
                        ],
                      );
                    },
                    onError: (error) {
                      return const Text('加载失败');
                    },
                  ),
                ),
              ));
            }),
          );
        });
  }
}
