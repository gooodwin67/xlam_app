import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
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
    context
        .read<MainScreenProvider>()
        .getAllDb(context.read<MainScreenProvider>().activeCategory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List productList = context.read<MainScreenProvider>().products;
    bool dataIsLoaded = context.watch<MainScreenProvider>().dataIsLoaded;
    String nameCategory = context.read<MainScreenProvider>().nameCategory;

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => showExitPopup(context),
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
                        onTap: () {},
                        child: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Жалко выкинуть',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 25),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/main/account');
                        },
                        child: const Icon(
                          Icons.manage_accounts_outlined,
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
                      itemCount:
                          context.read<MainScreenProvider>().Categories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<MainScreenProvider>().getAllDb(context
                                .read<MainScreenProvider>()
                                .Categories[index]
                                .numCategory);

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
                expandedHeight: 20,
                title: Center(
                  child: Text(
                    nameCategory,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: !dataIsLoaded ? 4 : productList.length,
                    (context, index) {
                      return ProductBlock(
                          productList: productList,
                          dataIsLoaded: dataIsLoaded,
                          index: index);
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
    );
  }
}
