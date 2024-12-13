class Movie {
  final String movieName;
  final String movieId;
  final List<Theater> theaters;

  Movie({
    required this.movieName,
    required this.movieId,
    required this.theaters,
  });
}

class Theater {
  final String theaterId;
  final String theaterName;
  final List<ShowTime> showTimes;
  final String screenName;
  final int screenNum;

  Theater({
    required this.theaterId,
    required this.theaterName,
    required this.showTimes,
    required this.screenName,
    required this.screenNum,
  });
}

class ShowTime {
  final String showDateTime;
  final SeatLayout seatLayout;
  final PriceInfo priceInfo;

  ShowTime({
    required this.showDateTime,
    required this.seatLayout,
    required this.priceInfo,
  });
}

class SeatLayout {
  final List<SeatRow> rows;

  SeatLayout({required this.rows});
}

class SeatRow {
  final String rowCategory; // e.g., "Club", "Premium", "Standard"
  final String rowId;       // e.g., "A", "B", "C"
  final List<Seat> seats;

  SeatRow({
    required this.rowCategory,
    required this.rowId,
    required this.seats,
  });
}

class Seat {
  final String seatNumber;   // e.g., "A1", "A2", "A0+0" (indicating space)
  final bool isAvailable;
  final bool isBlank;        // True if seat is a space/blank like "A0+0"
  
  Seat({
    required this.seatNumber,
    required this.isAvailable,
    required this.isBlank,
  });
}

class PriceInfo {
  final double price;
  final String priceCode;
  final String priceDescription;
  final String category;     // e.g., "Club", "Premium", "Standard"

  PriceInfo({
    required this.price,
    required this.priceCode,
    required this.priceDescription,
    required this.category,
  });
}
