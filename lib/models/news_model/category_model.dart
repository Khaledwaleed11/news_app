import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String value;
  final IconData icon;

  const CategoryModel({
    required this.name,
    required this.value,
    required this.icon,
  });

  static const List<CategoryModel> categories = [
    CategoryModel(
      name: 'General',
      value: 'general',
      icon: Icons.public_rounded,
    ),
    CategoryModel(
      name: 'Business',
      value: 'business',
      icon: Icons.business_center_rounded,
    ),
    CategoryModel(
      name: 'Entertainment',
      value: 'entertainment',
      icon: Icons.movie_rounded,
    ),
    CategoryModel(
      name: 'Health',
      value: 'health',
      icon: Icons.health_and_safety_rounded,
    ),
    CategoryModel(
      name: 'Science',
      value: 'science',
      icon: Icons.science_rounded,
    ),
    CategoryModel(
      name: 'Sports',
      value: 'sports',
      icon: Icons.sports_soccer_rounded,
    ),
    CategoryModel(
      name: 'Technology',
      value: 'technology',
      icon: Icons.computer_rounded,
    ),
  ];
}
