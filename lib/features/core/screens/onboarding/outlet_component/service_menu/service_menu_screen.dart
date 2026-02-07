import '../../../../../../utils/library_utils.dart';

class ServiceMenuScreen extends StatelessWidget {
  final ServiceMenuController controller = Get.put(ServiceMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar(
        title: "Service Menu",children: [

      ],),
      body: SafeArea(
        child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Expanded(
                          //                 child: Text(
                          //                   "Select Services",
                          //                   style: AppTextStyles.heading1.copyWith(
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: blackColor,
                          //                   ),
                          //                 ),
                          //               ),
                          //               Row(
                          //                 children: [
                          //                   GestureDetector(
                          //                     onTap: () {
                          //                       openAddCategoryDialog();
                          //                     },
                          //                     child: Container(
                          //                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          //                       decoration: BoxDecoration(
                          //                         borderRadius: BorderRadius.circular(4),
                          //                         border: Border.all(color: borderGreyColor,width: 1),
                          //                         color: whiteColor,
                          //                       ),
                          //                       child: Row(
                          //                         mainAxisSize: MainAxisSize.min,
                          //                         children: [
                          //                           Icon(Icons.add, color: kColorGray, size: 15),
                          //                           4.width,
                          //                           Text(
                          //                             'Add Category',
                          //                             style: AppTextStyles.regular.copyWith(
                          //                               fontSize: 10,
                          //                               color:blackColor,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //           // 5.height,
                          //           // Text(
                          //           //   "Choose the services you want to offer",
                          //           //   style: AppTextStyles.regular.copyWith(
                          //           //     fontSize: 12,
                          //           //     color: kColorGray,
                          //           //   ),
                          //           // ),
                          //         ],
                          //       ),
                          //     ),
                          //     // Action Buttons
                          //   ],
                          // ),
                          // 10.height,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelName: '',
                                  controller: controller.searchController,
                                  hintText: "Search...",
                                  showBorder: true,
                                  filled: false,
                                  hintTextStyle: AppTextStyles.regular.copyWith(
                                    fontSize: 14,
                                    color: kColorGray,
                                  ),
                                  prefixIcon: Icon(Icons.search, color: kColorGray, size: 18),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                                ),
                              ),
                              8.width,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: appColor.withOpacity(0.1),
                                ),
                                child: Icon(Icons.filter_alt_outlined, color: appColor, size: 20),
                              ),
                            ],
                          ),
                          10.height,
                          GestureDetector(
                            onTap: () {
                              openAddCategoryDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // border: Border.all(colors: borderGreyColor,width: 1),
                                color: appColor.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: appColor, size: 15),
                                  4.width,
                                  Text(
                                    'Add Category',
                                    style: AppTextStyles.heading2.copyWith(
                                      fontSize: 12,
                                      color:appColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          5.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(child: Row(
                                children: [
                                  Text(
                                    "${controller.totalSelected.value}",
                                    style: AppTextStyles.heading1.copyWith(
                                      fontSize: 20,
                                      color: appColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "selected services",
                                    style: AppTextStyles.regular.copyWith(
                                      color: blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )),


                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Select All',
                                      style: AppTextStyles.subHeading.copyWith(
                                        fontSize: 10,
                                        color: appColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Selected Count Badge - Creative Design
                          // Obx(() => Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          //   decoration: BoxDecoration(
                          //     gradient: LinearGradient(
                          //       colors: [
                          //         appColor.withOpacity(0.15),
                          //         appColor.withOpacity(0.08),
                          //       ],
                          //       begin: Alignment.topLeft,
                          //       end: Alignment.bottomRight,
                          //     ),
                          //     borderRadius: BorderRadius.circular(16),
                          //     border: Border.all(
                          //       color: appColor.withOpacity(0.2),
                          //       width: 1.5,
                          //     ),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: appColor.withOpacity(0.1),
                          //         blurRadius: 8,
                          //         offset: Offset(0, 4),
                          //       ),
                          //     ],
                          //   ),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       // Icon Badge
                          //       Container(
                          //         padding: EdgeInsets.all(10),
                          //         decoration: BoxDecoration(
                          //           gradient: LinearGradient(
                          //             colors: [appColor, appColor.withOpacity(0.8)],
                          //             begin: Alignment.topLeft,
                          //             end: Alignment.bottomRight,
                          //           ),
                          //           borderRadius: BorderRadius.circular(12),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: appColor.withOpacity(0.4),
                          //               blurRadius: 8,
                          //               offset: Offset(0, 2),
                          //             ),
                          //           ],
                          //         ),
                          //         child: Icon(
                          //           Icons.check_circle,
                          //           color: appWhite,
                          //           size: 20,
                          //         ),
                          //       ),
                          //       SizedBox(width: 12),
                          //       // Count and Text
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Row(
                          //             crossAxisAlignment: CrossAxisAlignment.baseline,
                          //             textBaseline: TextBaseline.alphabetic,
                          //             children: [
                          //               Text(
                          //                 "${controller.totalSelected.value}",
                          //                 style: AppTextStyles.heading1.copyWith(
                          //                   fontSize: 24,
                          //                   color: appColor,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               SizedBox(width: 4),
                          //               Text(
                          //                 "selected",
                          //                 style: AppTextStyles.regular.copyWith(
                          //                   color: kColorGray,
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.w500,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(height: 2),
                          //           Text(
                          //             "services",
                          //             style: AppTextStyles.regular.copyWith(
                          //               color: kColorGray.withOpacity(0.7),
                          //               fontSize: 11,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       SizedBox(width: 8),
                          //       // Decorative element
                          //       Container(
                          //         width: 2,
                          //         height: 30,
                          //         decoration: BoxDecoration(
                          //           gradient: LinearGradient(
                          //             colors: [
                          //               appColor.withOpacity(0.3),
                          //               appColor.withOpacity(0.1),
                          //             ],
                          //             begin: Alignment.topCenter,
                          //             end: Alignment.bottomCenter,
                          //           ),
                          //           borderRadius: BorderRadius.circular(1),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )),
                        ],
                      ),
                    ),
                // Services List
                10.height,
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 10.height,
                        Row(
                          children: [
                            12.width,
                            Text('Categories',style: AppTextStyles.heading2.copyWith(fontSize: 14),),
                          ],
                        ),

                        ...controller.categories.map((cat) => _buildCategoryCard(cat)),
                        100.height
                      ],
                    ),
                  ),
                ),],
                        ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: SafeArea(
                    child: CustomButton(
                      title: "Continue",
                      onTap: () {},
                      isDisable: false,
                      // height: 56,
                      radius: 12,
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
      // body: Obx(
      //       () => SingleChildScrollView(
      //     padding: const EdgeInsets.all(8),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //          Text(
      //           "Select Services",
      //           style: AppTextStyles.subHeading.copyWith(fontSize: 16,),
      //         ),
      //         6.height,
      //          Text(
      //           "Choose the services you want to offer to your customers",
      //            style: AppTextStyles.regular.copyWith(fontSize: 12,color:kColorGray),
      //         ),
      //         8.height,
      //         Text(
      //           "${controller.totalSelected.value} services selected",
      //           style: AppTextStyles.regular.copyWith(color: appColor,fontSize: 14),
      //         ),
      //         10.height,
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text('Categories',style: AppTextStyles.heading2.copyWith(fontSize: 16),),
      //             InkWell(
      //                 onTap: (){
      //                   openAddCategoryDialog();
      //                 },
      //                 child: Container(
      //                     decoration: BoxDecoration(color: appColor,borderRadius: BorderRadius.circular(8),),
      //                     child: Padding(
      //                       padding: const EdgeInsets.only(left: 15,top: 5,bottom: 5,right: 15),
      //                       child: Center(child: Text('+ Add',style: AppTextStyles.heading2.copyWith(fontSize: 16, color: whiteColor),)),
      //                     ))),
      //           ],
      //         ),
      //         10.height,
      //         ...controller.categories.map((cat) => _buildCategoryCard(cat)),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
  Widget _buildCategoryCard(CategoryModel cat) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5,top: 8,left: 8,right: 8),
      child: CustomContainer(

        child: Column(
          children: [
            // Category Header
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: appColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.category,
                            color: appWhite,
                            size: 16,
                          ),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.title,
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor,
                                ),
                              ),

                              Obx(() => Text(
                                "${cat.services.where((s) => s.isSelected.value).length}/${cat.services.length} services selected",
                                style: AppTextStyles.regular.copyWith(
                                  color: kColorGray,
                                  fontSize: 12,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Select All",
                  //       style: AppTextStyles.regular.copyWith(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         color: kColorGray,
                  //       ),
                  //     ),
                  //
                  //     Obx(() => Transform.scale(
                  //       scale: 0.65,
                  //       child: Switch(
                  //         value: cat.isAllSelected.value,
                  //         onChanged: (_) => controller.selectAll(cat),
                  //         activeColor: appColor,
                  //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //       ),
                  //     )),
                  //   ],
                  // ),
                ],
              ),
            ),
            // Divider(height: 1, thickness: 1, color: borderGreyColor.withOpacity(0.3)),
            // Services List
            Padding(
              padding: EdgeInsets.all(2),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Services',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Card(
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none
                        ),
                        elevation: 0.2,
                        color: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: GestureDetector(
                            onTap: () {
                              openAddServiceDialog();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: appColor, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Add Service',
                                  style: AppTextStyles.heading2.copyWith(
                                    fontSize: 11,
                                    color: appColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              10.height,
              // SizedBox(
              //   height: 180, // card height
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: cat.services.length,
              //     separatorBuilder: (_, __) => SizedBox(width: 0),
              //     itemBuilder: (context, index) {
              //       return SizedBox(
              //         width: MediaQuery.of(context).size.width * 0.35,  // 2.5 cards visible
              //         child: _buildServiceCard(cat, cat.services[index]),
              //       );
              //     },
              //   ),
              // )
                  ...cat.services.map((service) => _buildServiceRow(cat, service)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildServiceRow(CategoryModel cat, ServiceModel service) {
    return Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: service.isSelected.value
                    ? appColor.withOpacity(0.05)
                    : kColorGray.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: service.isSelected.value
                      ? appColor.withOpacity(0.3)
                      : borderGreyColor.withOpacity(0.5),
                  width: service.isSelected.value ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(AppImages.img1),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      //     ),
                      //     // Positioned(
                      //     //   top: 8,
                      //     //   left: 8,
                      //     //   child: Container(
                      //     //     padding: EdgeInsets.all(4),
                      //     //     decoration: BoxDecoration(
                      //     //       color: whiteColor,
                      //     //       borderRadius: BorderRadius.circular(6),
                      //     //       boxShadow: [
                      //     //         BoxShadow(
                      //     //           color: Colors.black.withOpacity(0.1),
                      //     //           blurRadius: 4,
                      //     //           offset: Offset(0, 2),
                      //     //         ),
                      //     //       ],
                      //     //     ),
                      //     //     child: SizedBox(
                      //     //       height: 20,
                      //     //       width: 20,
                      //     //       child: Checkbox(
                      //     //         side: BorderSide(color: kColorGray, width: 1.5),
                      //     //         shape: RoundedRectangleBorder(
                      //     //           borderRadius: BorderRadius.circular(4),
                      //     //         ),
                      //     //         value: service.isSelected.value,
                      //     //         onChanged: (_) => controller.toggleService(cat, service),
                      //     //         activeColor: appColor,
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            10.height,
                            Text(
                              service.name,
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: blackColor,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusColor(service.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  service.status,
                                  style: AppTextStyles.regular.copyWith(
                                    color: statusColor(service.status),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           Container(
                            //             width: 6,
                            //             height: 6,
                            //             decoration: BoxDecoration(
                            //               color: statusColor(service.status),
                            //               shape: BoxShape.circle,
                            //             ),
                            //           ),
                            //           SizedBox(width: 6),
                            //           Text(
                            //             service.status,
                            //             style: AppTextStyles.regular.copyWith(
                            //               color: statusColor(service.status),
                            //               fontSize: 12,
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //
                            //     // Row(
                            //     //   mainAxisAlignment: MainAxisAlignment.end,
                            //     //   children: [
                            //     //     // Padding(
                            //     //     //   padding: EdgeInsets.only(right: 5),
                            //     //     //   child: GestureDetector(
                            //     //     //     onTap: () {
                            //     //     //       // Edit service functionality
                            //     //     //     },
                            //     //     //     child: Container(
                            //     //     //       padding: EdgeInsets.all(5),
                            //     //     //       decoration: BoxDecoration(
                            //     //     //         color: appColor.withOpacity(0.1),
                            //     //     //         borderRadius: BorderRadius.circular(8),
                            //     //     //       ),
                            //     //     //       child: Icon(
                            //     //     //         Icons.edit_outlined,
                            //     //     //         color: appColor,
                            //     //     //         size: 18,
                            //     //     //       ),
                            //     //     //     ),
                            //     //     //   ),
                            //     //     // ),
                            //     //     // Padding(
                            //     //     //   padding: EdgeInsets.only(right: 5),
                            //     //     //   child: Container(
                            //     //     //     padding: EdgeInsets.all(5),
                            //     //     //     decoration: BoxDecoration(
                            //     //     //       color: kColorGray.withOpacity(0.1),
                            //     //     //       borderRadius: BorderRadius.circular(8),
                            //     //     //     ),
                            //     //     //     child: SizedBox(
                            //     //     //       height: 20,
                            //     //     //       width: 20,
                            //     //     //       child: Checkbox(
                            //     //     //         side: BorderSide(color: kColorGray, width: 1.5),
                            //     //     //         shape: RoundedRectangleBorder(
                            //     //     //           borderRadius: BorderRadius.circular(4),
                            //     //     //         ),
                            //     //     //         value: service.isSelected.value,
                            //     //     //         onChanged: (_) => controller.toggleService(cat, service),
                            //     //     //         activeColor: appColor,
                            //     //     //       ),
                            //     //     //     ),
                            //     //     //   ),
                            //     //     // ),
                            //     //   ],
                            //     // )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  )),

                 Row(
                   children: [
                     Text(
                       "view",
                       style: AppTextStyles.regular.copyWith(
                         color: appColor,
                         fontSize: 12,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     10.width,
                     Align(
                       alignment: Alignment.center,
                       child: Container(
                         padding: EdgeInsets.all(5),
                         // color: appColor,
                         // decoration: BoxDecoration(
                         //   color: kColorGray.withOpacity(0.1),
                         //   borderRadius: BorderRadius.circular(8),
                         // ),
                         child: SizedBox(
                           height: 20,
                           width: 20,
                           child: Checkbox(
                             side: BorderSide(color: kColorGray, width: 1.5),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(4),
                             ),
                             value: service.isSelected.value,
                             onChanged: (_) => controller.toggleService(cat, service),
                             activeColor: appColor,
                           ),
                         ),
                       ),
                     ),
                     10.width,
                   ],
                 )
                ],
              ),
            ),
          ),
    );
  }
  Widget _buildServiceCard(CategoryModel cat, ServiceModel service) {
    return Obx(() => Card(
      elevation: 0.1,
      child: Container(
        decoration: BoxDecoration(
          color:service.isSelected.value
              ? appColor.withOpacity(0.1)
              : whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: service.isSelected.value
                ? appColor
                : borderGreyColor.withOpacity(0.4),
            width: service.isSelected.value ? 2 : 1,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          children: [
            /// ---------------- IMG CAROUSEL ---------------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: service.images.isEmpty
                        ? _buildNoImagePlaceholder()
                        : CarouselSlider.builder(
                      itemCount: service.images.length,
                      itemBuilder: (context, imgIndex, realIndex) {
                        return _buildImage(service.images[imgIndex]);
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1,
                        autoPlayInterval: Duration(seconds: 3),
                        height: 130,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8,top: 8),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(color: whiteColor,borderRadius: BorderRadius.circular(2)),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: Checkbox(
                              side: BorderSide(color: kColorGray, width: 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              value: service.isSelected.value,
                              onChanged: (_) =>
                                  controller.toggleService(cat, service),
                              activeColor: appColor,
                            ),
                          ),
                        ),
                      ),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        8.height,
                        Text(
                          service.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ),

                        6.height,

                        /// STATUS INDICATOR
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: statusColor(service.status),
                                shape: BoxShape.circle,
                              ),
                            ),
                           6.width,
                            Text(
                              service.status,
                              style: AppTextStyles.regular.copyWith(
                                color: statusColor(service.status),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        /// EDIT + CHECKBOX

                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// EDIT BUTTON
                      GestureDetector(
                        onTap: () {
                          // your edit function
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: appColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit, size: 18, color: appColor),
                        ),
                      ),

                      /// CHECKBOX

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
  Widget _buildImage(String url) {
    return Image.asset(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildNoImagePlaceholder();
      },
    );
  }
  Widget _buildNoImagePlaceholder() {
    return Container(
      color: kColorGray.withOpacity(0.5),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: kColorGray,
          size: 25,
        ),
      ),
    );
  }
  void openAddCategoryDialog() async {
    var category = await Get.bottomSheet(
      AddCategoryDialog(),
      isScrollControlled: true,
    );

    if (category != null) {
      print("New Category: $category");
    }
  }
  void openAddServiceDialog() async {
    var category = await Get.bottomSheet(
      AddServiceDialog(),
      isScrollControlled: true,
    );

    if (category != null) {
      print("New Category: $category");
    }
  }

}
