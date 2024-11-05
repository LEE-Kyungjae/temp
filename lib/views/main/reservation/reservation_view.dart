import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReservationView extends StatefulWidget {
  const ReservationView({super.key});

  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  final DateTime today = DateTime.now();
  final int daysBefore = 30;
  final int daysAfter = 30;
  DateTime? selectedDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko', null);
    selectedDate = today;
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 초기 스크롤 위치 설정: 오늘 날짜가 더 잘 보이도록 오프셋 조정
      double initialScrollOffset = (daysBefore + 4.0) * MediaQuery.of(context).size.width / 7;
      _scrollController.jumpTo(initialScrollOffset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double itemWidth = MediaQuery.of(context).size.width / 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text('방탈출'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 날짜 선택 영역
            SizedBox(
              height: 80,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: daysBefore + daysAfter + 1,
                itemBuilder: (context, index) {
                  DateTime date = today.subtract(Duration(days: daysBefore - index));
                  bool isPastDate = date.isBefore(today);
                  bool isFutureDate = date.isAfter(today.add(Duration(days: daysAfter)));
                  bool isSelectable = !isPastDate && !isFutureDate;
                  bool isSelected = selectedDate != null && selectedDate!.difference(date).inDays == 0;

                  return GestureDetector(
                    onTap: isSelectable
                        ? () {
                      setState(() {
                        selectedDate = date;
                      });
                      print('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
                    }
                        : null,
                    child: Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isSelectable ? Colors.green[400] : Colors.grey[600],
                        borderRadius: BorderRadius.circular(8.0),
                        border: isSelected
                            ? Border.all(color: Colors.yellow, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E('ko').format(date), // 한글 요일 표시
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat.d().format(date), // 날짜 표시
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 시간 및 필터 옵션
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('시간 : ', style: TextStyle(fontSize: 16)),
                      Text('15:34 이후', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      Spacer(),
                      Text('일행 : ', style: TextStyle(fontSize: 16)),
                      Text('끼끼', style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: const Text('예약 가능'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('안 한 테마'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('중복'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('찜'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('신규'),
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('폐업'),
                        onSelected: (selected) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text('예약 가능 테마', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('가까운 순', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            // 예약 가능한 테마 리스트
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10, // 예시 데이터 개수
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(
                            'https://example.com/image.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 60);
                            },
                          ),
                        ),
                        title: const Text('룸즈에이 일산라페스타점'),
                        subtitle: const Text('행방불냥'),
                        trailing: const Icon(Icons.favorite_border),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('₩22,000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('15:40', style: TextStyle(color: Colors.blue)),
                            const Text('16:55', style: TextStyle(color: Colors.blue)),
                            const Text('18:10', style: TextStyle(color: Colors.blue)),
                            const Text('19:25', style: TextStyle(color: Colors.blue)),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('빠른 예약'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
