import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/main.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/screens/main_screens/bottom_bar.dart';
import 'package:xlam_app/screens/main_screens/category_block.dart';
import 'package:xlam_app/screens/main_screens/product_block.dart';
import 'package:xlam_app/screens/main_screens/show_exit_poput.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});
  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  @override
  void initState() {
    // print('Город ${context.read<MainProvider>().userCity}');
    // context
    //     .read<MainScreenProvider>()
    //     .changeActieCity(context.read<MainProvider>().userCity); //Автоматический выбор города пользователя
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //context.read<BottomBarProvider>().onItemTapped(0);
    List productList = context.read<MainScreenProvider>().products;
    bool dataIsLoaded = context.watch<MainScreenProvider>().dataIsLoaded;
    String nameCategory = context.read<MainScreenProvider>().nameCategory;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => showExitPopup(context),
          child: RefreshIndicator(
            onRefresh: () {
              if (dataIsLoaded) {
                context.read<MainScreenProvider>().getAllDb();
              }
              setState(() {});
              return Future((() => true));
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  floating: true,
                  pinned: false,
                  snap: false,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  expandedHeight: 59,
                  title: Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            context.go('/main/search');
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          nameApp,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 25),
                        ),
                        InkWell(
                          onTap: () {
                            if (context.read<MainProvider>().isLogin == true) {
                              context.read<BottomBarProvider>().onItemTapped(2);
                              context.go('/main/account');
                            } else {
                              context.go('/main/login');
                            }
                          },
                          child: context.read<MainProvider>().isLogin == true
                              ? const Icon(
                                  Icons.manage_accounts_outlined,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.person_add_alt_outlined,
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 10),
                  sliver: SliverAppBar(
                    toolbarHeight: 120,
                    elevation: 0,
                    floating: true,
                    pinned: false,
                    snap: true,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: context
                            .read<MainScreenProvider>()
                            .Categories
                            .length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              context.read<MainScreenProvider>().getAllDb();

                              context
                                  .read<MainScreenProvider>()
                                  .changeName(index);
                              setState(() {});
                            },
                            child: CategoryBlock(
                              index: context
                                  .read<MainScreenProvider>()
                                  .activeCategory,
                              numCat: context
                                  .read<MainScreenProvider>()
                                  .Categories[index]
                                  .numCategory,
                              name: context
                                  .read<MainScreenProvider>()
                                  .Categories[index]
                                  .nameCategory,
                              icon: context
                                  .read<MainScreenProvider>()
                                  .Categories[index]
                                  .iconCategory,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverAppBar(
                  elevation: 0,
                  floating: true,
                  pinned: false,
                  snap: false,
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  expandedHeight: 80,
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nameCategory,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 22),
                        ),
                        Container(
                          width: 100,
                          height: 38,
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                            items: cities
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        e,
                                        overflow: TextOverflow.fade,
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              dataIsLoaded = false;
                              setState(() {});
                              context
                                  .read<MainScreenProvider>()
                                  .changeActieCity(value);
                              context.read<MainScreenProvider>().getAllDb();
                            },
                            value: 'Все города',
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(top: 0, bottom: 0, left: 0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: !dataIsLoaded ? 4 : productList.length,
                      (context, index) {
                        return InkWell(
                          onTap: () => dataIsLoaded
                              ? context.go('/main/${productList[index].id}')
                              : null,
                          child: ProductBlock(
                              productList: productList,
                              dataIsLoaded: dataIsLoaded,
                              index: index),
                        );
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 210,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
