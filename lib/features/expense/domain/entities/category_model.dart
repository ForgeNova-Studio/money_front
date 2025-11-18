import 'package:flutter/material.dart';

class CategoryModel {
  final String categoryCode;
  final String categoryName;
  final String iconName;
  final String colorHex;
  final int sortOrder;

  CategoryModel({
    required this.categoryCode,
    required this.categoryName,
    required this.iconName,
    required this.colorHex,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryCode: json['categoryCode'],
      categoryName: json['categoryName'],
      iconName: json['iconName'],
      colorHex: json['colorHex'],
      sortOrder: json['sortOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      'iconName': iconName,
      'colorHex': colorHex,
      'sortOrder': sortOrder,
    };
  }

  Color get color {
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }

  IconData get icon {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'movie':
        return Icons.movie;
      case 'home':
        return Icons.home;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'more_horiz':
      default:
        return Icons.more_horiz;
    }
  }

  // 기본 카테고리 목록
  static List<CategoryModel> getDefaultCategories() {
    return [
      CategoryModel(
        categoryCode: 'FOOD',
        categoryName: '식비',
        iconName: 'restaurant',
        colorHex: '#FF6B6B',
        sortOrder: 1,
      ),
      CategoryModel(
        categoryCode: 'TRANSPORT',
        categoryName: '교통',
        iconName: 'directions_car',
        colorHex: '#4ECDC4',
        sortOrder: 2,
      ),
      CategoryModel(
        categoryCode: 'SHOPPING',
        categoryName: '쇼핑',
        iconName: 'shopping_bag',
        colorHex: '#FFE66D',
        sortOrder: 3,
      ),
      CategoryModel(
        categoryCode: 'CULTURE',
        categoryName: '문화생활',
        iconName: 'movie',
        colorHex: '#A8E6CF',
        sortOrder: 4,
      ),
      CategoryModel(
        categoryCode: 'HOUSING',
        categoryName: '주거/통신',
        iconName: 'home',
        colorHex: '#95E1D3',
        sortOrder: 5,
      ),
      CategoryModel(
        categoryCode: 'MEDICAL',
        categoryName: '의료/건강',
        iconName: 'local_hospital',
        colorHex: '#F38181',
        sortOrder: 6,
      ),
      CategoryModel(
        categoryCode: 'EDUCATION',
        categoryName: '교육',
        iconName: 'school',
        colorHex: '#AA96DA',
        sortOrder: 7,
      ),
      CategoryModel(
        categoryCode: 'EVENT',
        categoryName: '경조사',
        iconName: 'card_giftcard',
        colorHex: '#FCBAD3',
        sortOrder: 8,
      ),
      CategoryModel(
        categoryCode: 'ETC',
        categoryName: '기타',
        iconName: 'more_horiz',
        colorHex: '#C7CEEA',
        sortOrder: 9,
      ),
    ];
  }
}
