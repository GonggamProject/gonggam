import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/prefs.dart';
import '../../controller/group_controller.dart';
import '../../domain/group/group.dart';
import '../../utils.dart';
import '../common/bookstore_list_modal.dart';
import '../common/bottom_navigation_bar.dart';
import '../../common/constants.dart';
import '../common/note_list_menu.dart';
import 'bookstore_note_widget.dart';

class BookStoreMainWidget extends StatefulWidget {
  const BookStoreMainWidget({super.key});

  @override
  State<BookStoreMainWidget> createState() => _BookStoreMainWidgetState();
}

class _BookStoreMainWidgetState extends State<BookStoreMainWidget> {
  final GroupController groupController = Get.find();
  late int selectedGroupId = groupController.group.id;
  late String currentGroupName = groupController.group.name;

  String customerId = Prefs.getCustomerId();
  int _currentPageIndex = 365;
  final PageController _pageController = PageController(initialPage: 365);

  bool isRefreseh = Get.arguments ?? false;

  Future<List<Widget>>? _future;

  @override
  void initState() {
    super.initState();

    _future = getBottomNoteList(selectedGroupId, customerId, _changeCustomerId);
    groupController.setGroup(groupController.groups.groups.firstWhere((element) => element.id == selectedGroupId).copyWith());

    if(isRefreseh) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              showBookStoreListModal(context, groupController, (id) {
                Group group = groupController.groups.groups.firstWhere((element) => element.id == id);
                groupController.setGroup(group.copyWith());
                selectedGroupId = group.id;
                currentGroupName = group.name;
                customerId = Prefs.getCustomerId();
                _future = getBottomNoteList(selectedGroupId, customerId, _changeCustomerId);
                setState(() {});
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  groupController.groups.groups.firstWhere((element) => element.id == selectedGroupId).name,
                  style: const TextStyle(
                      fontFamily: FONT_NANUMMYNGJO,
                      fontSize: 15,
                      color: Colors.black),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                )
              ],
            ),
          ),
          foregroundColor: Colors.black,
          backgroundColor: COLOR_BACKGROUND,
          elevation: 0,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(27, 0, 27, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Utils.isAfterCreateAt(groupController.group.createdAt, _currentPageIndex - 365) ? _changePage(-1) : null;
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Utils.isAfterCreateAt(groupController.group.createdAt, _currentPageIndex - 365)
                            ? Colors.black
                            : COLOR_GRAY,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const SizedBox(width: 5),
                  Text(Utils.formatDate("yyyy.MM.dd", _currentPageIndex - 365),
                      style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18)),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () {
                      _currentPageIndex - 365 >= 0 ? null : _changePage(1);
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: _currentPageIndex - 365 >= 0
                            ? COLOR_GRAY
                            : Colors.black,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(index);
                  },
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                child: FutureBuilder(
                  future: _future,
                  builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // 데이터가 로딩 중일 때 표시할 위젯
                    } else {
                      return Stack(children: snapshot.data!);
                    }
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: getBottomNavigationBar(context, groupController));
  }

  Widget _buildPage(int index) {
    return Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("$IMAGE_PATH/bookstore_note.png"),
                fit: BoxFit.fill)),
        child: getPage(index));
  }

  Widget getPage(int index) {
    int currentDateState = index - 365;
    return noteFactory(context, currentDateState, customerId, groupController);
  }

  void _changePage(int delta) {
    final newPageIndex = _currentPageIndex + delta;
    _pageController.animateToPage(
      newPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPageIndex = newPageIndex;
    });
  }

  void _changeCustomerId(String changedCustomerId) {
    customerId = changedCustomerId;
    _future = getBottomNoteList(selectedGroupId, customerId, _changeCustomerId);
    setState(() {});
  }
}
