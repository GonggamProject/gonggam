import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/service/note/note_service.dart';
import 'package:screenshot/screenshot.dart';
import 'package:table_calendar/table_calendar.dart';
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
  PageController _pageController = PageController(initialPage: 365);

  bool isRefresh = Get.arguments["isRefresh"] ?? false;

  DateTime _currentCalendarDate = DateTime.now();
  bool isCalendarMode = false;

  final DateTime now = DateTime.now();

  Future<List<Widget>>? _future;

  @override
  void initState() {
    super.initState();

    _future = getBottomNoteList(selectedGroupId, customerId, _changeCustomerId);
    groupController.setGroup(groupController.groups.groups.firstWhere((element) => element.id == selectedGroupId).copyWith());

    if(isRefresh) {
      setState(() {
        if(Get.arguments["currentDateState"] != null) {
          _currentPageIndex = Get.arguments["currentDateState"];
          _currentPageIndex = 365 + _currentPageIndex;

          _pageController = PageController(initialPage: _currentPageIndex);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 30,),
              GestureDetector(
                onTap: () {
                  showBookStoreListModal(context, groupController, (id) {
                    Group group = groupController.groups.groups.firstWhere((element) => element.id == id);
                    groupController.setGroup(group.copyWith());
                    selectedGroupId = group.id;
                    currentGroupName = group.name;
                    customerId = Prefs.getCustomerId();
                    _future = getBottomNoteList(selectedGroupId, customerId, _changeCustomerId);
                    _currentCalendarDate = DateTime.now();
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
              )
            ],
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
              getNoteNav(),
              const SizedBox(height: 5),
              getNoteViewWidget(isCalendarMode),
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
        bottomNavigationBar: getBottomNavigationBar(context, groupController, 0));
  }

  Widget getDateNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            if(isCalendarMode && Utils.compartDateTimeByMonth(_currentCalendarDate, getFirstDay()) == 1) {
              setState(() {
                _currentCalendarDate = Utils.getPreviousMonth(_currentCalendarDate);
              });
            } else {
              Utils.isAfterCreateAt(groupController.group.createdAt, _currentPageIndex - 365) ? _changePage(-1) : null;
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            minimumSize: MaterialStateProperty.all(const Size(24, 24)),
            foregroundColor: MaterialStateProperty.all<Color>(
            isCalendarMode ?
              (Utils.compartDateTimeByMonth(_currentCalendarDate, getFirstDay()) == 1 ? Colors.black : COLOR_GRAY) :
              (Utils.isAfterCreateAt(groupController.group.createdAt, _currentPageIndex - 365) ? Colors.black : COLOR_GRAY)
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
          ),
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 5),
        isCalendarMode ? Text(Utils.targetDateToFormatDate(_currentCalendarDate, "yyyy.MM"),
            style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18)) :
        Text(Utils.formatDate("yyyy.MM.dd", _currentPageIndex - 365),
            style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18)),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            if(isCalendarMode && Utils.compartDateTimeByMonth(_currentCalendarDate, getLastDay()) == -1) {
              setState(() {
                _currentCalendarDate = Utils.getNextMonth(_currentCalendarDate);
              });
            } else {
              _currentPageIndex - 365 >= 0 ? null : _changePage(1);
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            minimumSize: MaterialStateProperty.all(const Size(24, 24)),
            foregroundColor: MaterialStateProperty.all<Color>(
              isCalendarMode ?
              (Utils.compartDateTimeByMonth(_currentCalendarDate, getLastDay()) == -1 ? Colors.black : COLOR_GRAY ) :
              (_currentPageIndex - 365 >= 0 ? COLOR_GRAY : Colors.black)
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return Colors.transparent;
              },
            ),
          ),
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }

  Widget getNoteNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getDateNav(),
        ElevatedButton(
            onPressed: () {
              setState(() {
                isCalendarMode = !isCalendarMode;
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
              ),
              backgroundColor: COLOR_LIGHTGRAY,
              shadowColor: Colors.transparent,
            ),
            child: Text(isCalendarMode ? "책방보기" : "캘린더보기", style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB))
        )
      ],
    );
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
    int currentDateState = _currentPageIndex != 365 ? _currentPageIndex - 365 : index - 365;
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

  Widget getNoteViewWidget(bool isCalendarMode) {
    return isCalendarMode ? getCalendarWidget() : getNoteWidget();
  }

  Widget getNoteWidget() {
    return Expanded(
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
    );
  }

  Widget getCalendarWidget() {
    String targetDate = Utils.targetDateToFormatDate(_currentCalendarDate, "yyyyMM");

    return FutureBuilder(
        future: NoteService.getCalendar(selectedGroupId, customerId, targetDate),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final double ratio = MediaQuery.of(context).devicePixelRatio;

            return Expanded(
              flex: 7,
              child: TableCalendar(
                availableGestures: AvailableGestures.none,
                locale: "ko_KR",
                focusedDay: _currentCalendarDate,
                currentDay: DateTime.now(),
                firstDay: getFirstDay(),
                lastDay: getLastDay(),
                headerVisible: false,
                shouldFillViewport: true,
                daysOfWeekHeight: 35,
                calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, dateTime, _) {
                      return snapshot.data!.writtenDates.contains(Utils.targetDateToFormatDate(dateTime, "yyyyMMdd")) ? writedDay(dateTime, ratio) : defaultDay(dateTime, ratio);
                    },
                    todayBuilder: (context, dateTime, _) {
                      return snapshot.data!.writtenDates.contains(Utils.targetDateToFormatDate(dateTime, "yyyyMMdd")) ? writedDay(dateTime, ratio) : defaultDay(dateTime, ratio);
                    },
                    outsideBuilder: (context, dateTime, _) {
                      return const SizedBox.shrink();
                    },
                    disabledBuilder: (context, dateTime, _) {
                      return const SizedBox.shrink();
                    }
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: COLOR_SUB, fontFamily: FONT_NANUMMYNGJO, fontSize: 14),
                  weekendStyle: TextStyle(color: COLOR_BOOK4, fontFamily: FONT_NANUMMYNGJO, fontSize: 14),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  if(snapshot.data!.writtenDates.contains(Utils.targetDateToFormatDate(selectedDay, "yyyyMMdd"))) {
                    isCalendarMode = false;

                    _currentPageIndex = 365 - (DateTime.now().difference(selectedDay).inDays);
                    setState(() {
                      _pageController = PageController(initialPage: _currentPageIndex);
                    });
                  }
                },
              )
            );
          } else {
            return const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(),));
          }
        });
  }

  Widget defaultDay(DateTime dateTime, double ratio) {
    bool isToday = DateTime(now.year, now.month, now.day).compareTo(DateTime(dateTime.year, dateTime.month, dateTime.day)) == 0;
    bool isWeekend = dateTime.weekday == 6 || dateTime.weekday == 7;
    return Container(
        margin: const EdgeInsets.all(5),
        padding: EdgeInsets.fromLTRB(7, 4.5 * ratio, 7, 4.5 * ratio),
        alignment: Alignment.topCenter,
      child: Container(
        width: 20,
        decoration: isToday ? BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: isWeekend ? COLOR_BOOK4 : Colors.black,
                    width: 2.0
                )
            )
        ) : const BoxDecoration(),
        child: Text(
          dateTime.day.toString(),
          textAlign: TextAlign.center,
          style: isWeekend
              ? TextStyle(color: COLOR_BOOK4, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)
              : TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }

  Widget writedDay(DateTime dateTime, double ratio) {
    bool isToday = DateTime(now.year, now.month, now.day).compareTo(DateTime(dateTime.year, dateTime.month, dateTime.day)) == 0;
    bool isWeekend = dateTime.weekday == 6 || dateTime.weekday == 7;
    return Container(
      margin: const EdgeInsets.all(5),
      padding: EdgeInsets.fromLTRB(7, 4.5 * ratio, 7, 4.5 * ratio),
      decoration: const BoxDecoration(
        color: COLOR_LIGHTGRAY,
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            decoration: isToday ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: isWeekend ? COLOR_BOOK4 : Colors.black,
                    width: 2.0
                )
              )
            ) : const BoxDecoration(),
            child: Text(dateTime.day.toString(),
            textAlign: TextAlign.center,
            style: isWeekend
                ? TextStyle(color: COLOR_BOOK4, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)
                : TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Expanded(child:
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Image.asset(
                "$IMAGE_PATH/calendar_logo.png",
                height: 21,
                fit: BoxFit.fitWidth,
              ),
            )
          ),
        ],
      ),
    );
  }

  DateTime getFirstDay() {
    DateTime createAt = DateTime.parse(groupController.group.createdAt);
    DateTime firstDayOfThisMonth = DateTime(createAt.year, createAt.month, 1);
    return firstDayOfThisMonth;
  }

  DateTime getLastDay() {
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfThisMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDayOfThisMonth;
  }
}
