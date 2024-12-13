import 'package:flutter/material.dart';

class TestingScreen extends StatefulWidget {
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final List<CategorySeat> seatLayoutData = [
    CategorySeat(
      categoryName: 'VIP',
      seats: [
        ['empty', 'empty', 'empty', 'sold', 'available', 'sold', 'empty', 'available', 'available', 'sold', 'empty', 'empty', 'empty', 'empty'],
        ['empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty'],
        ['empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty'],
      ],
      rowLabels: ['A', '-', '-'],
    ),
    CategorySeat(
      categoryName: 'Silver',
      seats: [
        ['sold', 'sold', 'empty', 'empty', 'available', 'available', 'sold', 'sold', 'available', 'empty', 'empty', 'available', 'available'],
        ['sold', 'sold', 'empty', 'empty', 'available', 'available', 'sold', 'sold', 'available', 'empty', 'empty', 'available', 'available'],
        ['sold', 'sold', 'empty', 'empty', 'available', 'available', 'sold', 'sold', 'available', 'empty', 'empty', 'available', 'available'],
        ['sold', 'sold', 'empty', 'empty', 'available', 'available', 'sold', 'sold', 'available', 'empty', 'empty', 'available', 'available'],
        ['sold', 'sold', 'empty', 'empty', 'available', 'available', 'sold', 'sold', 'available', 'empty', 'empty', 'available', 'available'],
        ['empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty'],
      ],
      rowLabels: ['B', 'C', 'D', 'E', 'F', '-'],
    ),
     CategorySeat(
      categoryName: 'Regular',
      seats: [
        ['empty', 'empty', 'available', 'available', 'available', 'available', 'sold', 'sold', 'available', 'available', 'available', 'empty', 'empty'],
        ['empty', 'empty', 'available', 'available', 'available', 'available', 'sold', 'sold', 'available', 'available', 'available', 'empty', 'empty'],
        ['empty', 'empty', 'available', 'available', 'available', 'available', 'sold', 'sold', 'available', 'available', 'available', 'empty', 'empty'],
        ['empty', 'empty', 'available', 'available', 'available', 'available', 'sold', 'sold', 'available', 'available', 'available', 'empty', 'empty'],
        ['empty', 'empty', 'available', 'available', 'available', 'available', 'sold', 'sold', 'available', 'available', 'available', 'empty', 'empty'],
        
      ],
      rowLabels: ['G', 'H', 'I', 'J', 'K'],
    ),
  ];

  Map<int, Set<int>> selectedSeats = {}; // stores selected seat indices
  List<String> selectedSeatDetails = []; // stores selected seat labels like 'A12', 'B2'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Movie Name', style: TextStyle(fontSize: 18.0)),
            Text('Theater Name', style: TextStyle(fontSize: 14.0)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date, Day, and Show timing
          SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Wed, Nov 27', style: TextStyle(fontSize: 16.0)),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Show Timing: 7:30 PM'),
                ),
              ],
            ),
          ),

          // Seat Layout
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildSeatLayout(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Available', Colors.green, false),
              _buildLegendItem('Selected', Colors.green, true),
              _buildLegendItem('Sold', Colors.grey.shade400, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, bool filled) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: filled ? color : Colors.transparent,
            border: Border.all(color: color),
          ),
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildSeatLayout() {
    return InteractiveViewer(
      maxScale: 3.0,
      minScale: 0.2,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: seatLayoutData.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    category.categoryName,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: category.seats.asMap().entries.map((rowEntry) {
                    int rowIndex = rowEntry.key;
                    List<String> row = rowEntry.value;
        
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Row label aligned vertically
                        Container(
                          width: 30,
                          child: category.rowLabels![rowIndex] == '-'
                              ? Text('')
                              : Text(
                                  category.rowLabels![rowIndex],
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                        // Seat layout
                        Row(
                          children: row.asMap().entries.map((seatEntry) {
                            int columnIndex = seatEntry.key;
                            String seatStatus = seatEntry.value;
                            bool isSelected = selectedSeats[rowIndex]?.contains(columnIndex) ?? false;
        
                            return GestureDetector(
                              onTap: seatStatus == 'available'
                                  ? () => _toggleSeatSelection(rowIndex, columnIndex)
                                  : null,
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color:seatStatus == 'available' ? Colors.transparent: _getSeatColor(seatStatus, isSelected),
                                  border: Border.all(color: _getSeatBorderColor(seatStatus)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getSeatColor(String seatStatus, bool isSelected) {
    if (seatStatus == 'sold') {
      return Colors.grey.shade400;
    } else if (seatStatus == 'empty') {
      return Colors.transparent;
    } else if (isSelected) {
      return Colors.green;
    } else {
      return Colors.green.withOpacity(0.5);
    }
  }

  Color _getSeatBorderColor(String seatStatus) {
    if (seatStatus == 'empty') {
      return Colors.white;
    } else if (seatStatus == 'sold') {
      return Colors.grey.shade400;
    } else {
      return Colors.grey;
    }
  }

  void _toggleSeatSelection(int rowIndex, int columnIndex) {
    setState(() {
      if (selectedSeats[rowIndex]?.contains(columnIndex) ?? false) {
        selectedSeats[rowIndex]!.remove(columnIndex);
      } else {
        selectedSeats.putIfAbsent(rowIndex, () => {}).add(columnIndex);
      }

      // Store selected seat in human-readable format like 'A12', 'B2'
      String seatLabel = '${seatLayoutData[rowIndex].rowLabels?[rowIndex]}${columnIndex + 1}';
      if (selectedSeats[rowIndex]?.contains(columnIndex) ?? false) {
        selectedSeatDetails.add(seatLabel);
      } else {
        selectedSeatDetails.remove(seatLabel);
      }
    });
  }
}

class CategorySeat {
  final String categoryName;
  final List<List<String>> seats;
  final List<String>? rowLabels;

  CategorySeat({required this.categoryName, required this.seats, this.rowLabels});
}
