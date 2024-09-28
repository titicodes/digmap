import 'package:digmap/module/dashboard/controller/home_controller.dart';
import 'package:digmap/module/dashboard/view/home/hospital_view.dart';
import 'package:digmap/module/dashboard/view/home/recent_searc.dart';
import 'package:digmap/module/dashboard/view/home/roads_view.dart';
import 'package:digmap/module/dashboard/view/home/schools_view.dart';
import 'package:digmap/module/dashboard/view/home/searc_utils_view.dart';
import 'package:digmap/module/dashboard/view/home/search_hospital_view.dart';
import 'package:digmap/module/dashboard/view/home/search_roads.dart';
import 'package:digmap/module/dashboard/view/home/search_schools_view.dart';
import 'package:digmap/module/dashboard/view/home/utils_view.dart';
import 'package:digmap/module/map/main_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.put(HomeController()); // Instantiate the controller

    return DefaultTabController(
        length: 4, // Adjusted to the number of tabs
        child: Scaffold(
          backgroundColor: const Color(0xffFAFAFA),
          body: Obx(() => (controller
                  .isMapVisible.value) // Use .value for observables
              ?  MainMapView() // You can implement your map view here
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        elevation: 4,
                        automaticallyImplyLeading: false,
                        floating: true,
                        pinned: true,
                        snap: true,
                        expandedHeight: 110,
                        title: (controller
                                .isSearchActive.value) // Use .value here
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                     // controller.updateIsSearchActive();
                                      controller.updateSearchText("");
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Color(0xff575757),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      child: TextFormField(
                                        controller: controller.searchText,
                                        onChanged: (value) {
                                          controller.updateSearchText(value);
                                          controller.searchForInfrastructure();
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: SvgPicture.asset(
                                              "assets/images/search.svg"),
                                          fillColor: const Color(0xffF7F7F7),
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10),
                                          hintText: "Search for infrastructure",
                                          hintStyle: const TextStyle(
                                              color: Color(0xffCCCCCC),
                                              fontSize: 16),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SvgPicture.asset(
                                "assets/images/FuelAlert Logo.svg",
                                height: 47,
                                width: 155,
                              ),
                        actions: [
                          (controller.isSearchActive.value)
                              ? const SizedBox.shrink()
                              : InkWell(
                                  onTap: () {
                                    //controller.updateIsSearchActive();
                                  },
                                  child: SvgPicture.asset(
                                      "assets/images/search.svg"),
                                ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.asset("assets/images/filter.svg"),
                          ),
                          const SizedBox(width: 15),
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: const TabBar(
                          padding: EdgeInsets.only(left: 15),
                          tabAlignment: TabAlignment.start,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Color(0xff009933),
                          dividerHeight: 0,
                          isScrollable: true,
                          labelStyle: TextStyle(
                            color: Color(0xff009933),
                            fontFamily: "PoppinsMeds",
                            fontSize: 14,
                          ),
                          unselectedLabelStyle: TextStyle(
                            color: Color(0xff9599AD),
                            fontFamily: "PoppinsMeds",
                            fontSize: 14,
                          ),
                          tabs: [
                            Tab(text: "Hospitals"),
                            Tab(text: "Schools"),
                            Tab(text: "Roads"),
                            Tab(text: "Utilities"),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: (controller.isSearchActive.value) // Use .value here
                      ? (controller.searchText.text.isEmpty)
                          ? const RecentSearchView() // Assuming you have this view implemented
                          : const TabBarView(children: [
                              SearchHospitalsView(), // You will implement these
                              SearchSchoolsView(),
                              SearchRoadsView(),
                              SearchUtilitiesView(),
                            ])
                      : const TabBarView(children: [
                          HospitalsView(), // You will implement these
                          SchoolsView(),
                          RoadsView(),
                          UtilitiesView(),
                        ]),
                )),
        ));
  }
}
