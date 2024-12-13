
// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

class ShowDetailsModel {
  List<ShowDetail> showDetails;

  ShowDetailsModel({required this.showDetails});

  factory ShowDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShowDetailsModel(
      showDetails: (json['ShowDetails'] as List)
          .map((e) => ShowDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ShowDetails': showDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class ShowDetail {
  String date;
  Event event;
  List<Venue> venues;

  ShowDetail({required this.date, required this.event, required this.venues});

  factory ShowDetail.fromJson(Map<String, dynamic> json) {
    return ShowDetail(
      date: json['Date'],
      event: Event.fromJson(json['Event']),
      venues: (json['Venues'] as List).map((e) => Venue.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'Event': event.toJson(),
      'Venues': venues.map((e) => e.toJson()).toList(),
    };
  }
}

class Event {
  String eventTitle;
  List<ChildEvent> childEvents;

  Event({
    required this.eventTitle,
    required this.childEvents,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventTitle: json['EventTitle'] ?? '',
      childEvents: (json['ChildEvents'] as List)
          .map((e) => ChildEvent.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EventTitle': eventTitle,
      'ChildEvents': childEvents.map((e) => e.toJson()).toList(),
    };
  }
}

class ChildEvent {
  String eventTitle;
  String eventLang;
  String eventName;
  String eventGenre;
  String eventCensor;
  String eventDimension;
  String starring;
  String trailerUrl;

  ChildEvent({
    required this.eventTitle,
    required this.eventLang,
    required this.eventName,
    required this.eventGenre,
    required this.eventCensor,
    required this.eventDimension,
    required this.starring,
    required this.trailerUrl,
  });

  factory ChildEvent.fromJson(Map<String, dynamic> json) {
    return ChildEvent(
      eventTitle: json['EventTitle'] ?? '',
      eventLang: json['EventLang'] ?? '',
      eventName: json['EventName'] ?? '',
      eventGenre: json['EventGenre'] ?? '',
      eventCensor: json['EventCensor'] ?? '',
      eventDimension: json['EventDimension'] ?? '',
      starring: json['Starring'] ?? '',
      trailerUrl: json['TrailerUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EventTitle': eventTitle,
      'EventLang': eventLang,
      'EventName': eventName,
      'EventGenre': eventGenre,
      'EventCensor': eventCensor,
      'EventDimension': eventDimension,
      'Starring': starring,
      'TrailerUrl': trailerUrl,
    };
  }
}

class Venue {
  String venueName;
  String venueAdd;
  String venueInfoMessage;
  List<ShowTime> showTimes;

  Venue({
    required this.venueName,
    required this.venueAdd,
    required this.venueInfoMessage,
    required this.showTimes,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      venueName: json['VenueName'] ?? '',
      venueAdd: json['VenueAdd'] ?? '',
      venueInfoMessage: json['VenueInfoMessage'] ?? '',
      showTimes: (json['ShowTimes'] as List)
          .map((e) => ShowTime.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VenueName': venueName,
      'VenueAdd': venueAdd,
      'VenueInfoMessage': venueInfoMessage,
      'ShowTimes': showTimes.map((e) => e.toJson()).toList(),
    };
  }
}

class ShowTime {
  String showDateTime;
  String showTime;
  double minPrice;
  double maxPrice;
  List<Category> categories;

  ShowTime({
    required this.showDateTime,
    required this.showTime,
    required this.minPrice,
    required this.maxPrice,
    required this.categories,
  });

  factory ShowTime.fromJson(Map<String, dynamic> json) {
    return ShowTime(
      showDateTime: json['ShowDateTime'] ?? '',
      showTime: json['ShowTime'] ?? '',
      minPrice: (json['MinPrice'] as num).toDouble(),
      maxPrice: (json['MaxPrice'] as num).toDouble(),
      categories: (json['Categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ShowDateTime': showDateTime,
      'ShowTime': showTime,
      'MinPrice': minPrice,
      'MaxPrice': maxPrice,
      'Categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class Category {
  String priceCode;
  String priceDesc;
  double curPrice;

  Category({
    required this.priceCode,
    required this.priceDesc,
    required this.curPrice,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      priceCode: json['PriceCode'] ?? '',
      priceDesc: json['PriceDesc'] ?? '',
      curPrice: (json['CurPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PriceCode': priceCode,
      'PriceDesc': priceDesc,
      'CurPrice': curPrice,
    };
  }
}

enum SeatStatus { available, sold, empty, blocked }

/// Extension to add methods to the SeatStatus enum
extension SeatStatusExtension on SeatStatus {
  /// Converts the enum to a string
  String toValueString() {
    switch (this) {
      case SeatStatus.available:
        return 'available';
      case SeatStatus.sold:
        return 'sold';
      case SeatStatus.empty:
        return 'empty';
      case SeatStatus.blocked:
        return 'blocked';
    }
  }

  /// Static helper method to convert a string to a SeatStatus enum value.
  static SeatStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return SeatStatus.available;
      case 'sold':
        return SeatStatus.sold;
      case 'empty':
        return SeatStatus.empty;
      case 'blocked':
        return SeatStatus.blocked;
      default:
        throw Exception('Invalid seat status: $status');
    }
  }
}

class SeatModel {
  List<MovieSeatDetail> movieSeatDetails;

  SeatModel({required this.movieSeatDetails});

  /// Factory method to create a SeatModel from a JSON map.
  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      movieSeatDetails: json.entries
          .map((entry) => MovieSeatDetail.fromJson(entry.value))
          .toList(),
    );
  }

  /// Convert SeatModel to JSON format.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    for (var detail in movieSeatDetails) {
      jsonMap[detail.movieName] = detail.toJson();
    }
    return jsonMap;
  }
}

class MovieSeatDetail {
  String movieName;
  String venueName;
  String movieTime;
  List<String> categories;
  List<CategorySeat> numberOfRowAndColumn;

  MovieSeatDetail({
    required this.movieName,
    required this.venueName,
    required this.movieTime,
    required this.categories,
    required this.numberOfRowAndColumn,
  });

  /// Factory method to create MovieSeatDetail from a JSON map.
  factory MovieSeatDetail.fromJson(Map<String, dynamic> json) {
    return MovieSeatDetail(
      movieName: json['moviename'] ?? '',
      venueName: json['venuename'] ?? '',
      movieTime: json['movietime'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      numberOfRowAndColumn: (json['numberofrowandcolumn'] as List)
          .map((e) => CategorySeat.fromJson(e))
          .toList(),
    );
  }

  /// Convert MovieSeatDetail to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'moviename': movieName,
      'venuename': venueName,
      'movietime': movieTime,
      'categories': categories,
      'numberofrowandcolumn':
          numberOfRowAndColumn.map((e) => e.toJson()).toList(),
    };
  }
}

class CategorySeat {
  String categoryName;
  List<List<SeatStatus>> seats;

  CategorySeat({required this.categoryName, required this.seats});

  /// Factory method to create CategorySeat from a JSON map.
  factory CategorySeat.fromJson(Map<String, dynamic> json) {
    return CategorySeat(
      categoryName: json.keys.first,
      seats: (json.values.first as List)
          .map((row) => (row as List)
              .map((status) => SeatStatusExtension.fromString(status))
              .toList())
          .toList(),
    );
  }

  /// Convert CategorySeat to JSON format.
  Map<String, dynamic> toJson() {
    return {
      categoryName: seats
          .map((row) => row.map((seat) => seat.toValueString()).toList())
          .toList(),
    };
  }
}
