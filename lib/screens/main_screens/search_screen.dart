import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/searchScreenProvider.dart';
import 'package:xlam_app/screens/main_screens/bottom_bar.dart';
import 'package:xlam_app/screens/main_screens/product_block.dart';

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({super.key});

  @override
  State<SearchScreenWidget> createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreenWidget> {
  @override
  void initState() {
    context.read<SearchScreenProvider>().getAllDbWithSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List productList = context.read<SearchScreenProvider>().products;
    bool dataIsLoaded = context.watch<SearchScreenProvider>().dataIsLoaded;
    bool searchingNow = context.watch<SearchScreenProvider>().searchingNow;
    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                floating: false,
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
                          context.pop();
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Поиск',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 25),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 10),
                sliver: SliverAppBar(
                  toolbarHeight: 100,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  snap: true,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: Container(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: TextEditingController()
                            ..text =
                                context.read<SearchScreenProvider>().searchText,
                          onChanged: (value) {
                            context
                                .read<SearchScreenProvider>()
                                .changeSearchText(value);
                          },
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            context
                                .read<SearchScreenProvider>()
                                .startSearching();
                            context
                                .read<SearchScreenProvider>()
                                .getAllDbWithSearch();
                          },
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: InkWell(
                              onTap: () {
                                context
                                    .read<SearchScreenProvider>()
                                    .startSearching();
                                context
                                    .read<SearchScreenProvider>()
                                    .getAllDbWithSearch();
                              },
                              child: Icon(
                                Icons.send_rounded,
                                color: mainColor,
                              ),
                            ),
                            label: Text(
                              'Что ищем?',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 155, 155, 155)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 155, 155, 155)),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        context.read<SearchScreenProvider>().searchText == ''
                            ? Text('',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19))
                            : Text(
                                'Поиск: ${context.read<SearchScreenProvider>().searchText}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount:
                        !dataIsLoaded || searchingNow ? 4 : productList.length,
                    (context, index) {
                      return InkWell(
                        onTap: () => dataIsLoaded && !searchingNow
                            ? context
                                .go('/main/search/${productList[index].id}')
                            : null,
                        child: ProductBlock(
                            productList: productList,
                            dataIsLoaded: dataIsLoaded,
                            index: index),
                      );
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
        ));
  }
}
