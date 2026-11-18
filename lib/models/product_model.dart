import 'package:flutter/material.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class Product {
  final String id;
  final String name;
  final String sku;
  final String brand;
  final String department; // e.g., Cricket, Badminton, Football, Swimming, Gym
  final String category; // e.g., Bats, Rackets, Footwear, Apparel
  final double sellingPrice; // LKR (Sri Lankan Rupee)
  final double costPrice;
  int stockQuantity;
  final int minStockThreshold;
  final String description;
  final String? imageUrl;
  final Map<String, String> specifications; // Size, Color, Weight, Material
  final bool isActive;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.brand,
    required this.department,
    required this.category,
    required this.sellingPrice,
    required this.costPrice,
    required this.stockQuantity,
    this.minStockThreshold = 10,
    required this.description,
    this.imageUrl,
    this.specifications = const {},
    this.isActive = true,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  StockStatus get status {
    if (stockQuantity <= 0) return StockStatus.outOfStock;
    if (stockQuantity <= minStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  String get statusLabel {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock ($stockQuantity left)';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  Color get statusColor {
    switch (status) {
      case StockStatus.inStock:
        return const Color(0xFF10B981); // Emerald Green
      case StockStatus.lowStock:
        return const Color(0xFFFF5252); // Red Accent warning
      case StockStatus.outOfStock:
        return const Color(0xFFD32F2F); // Deep Red
    }
  }

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? brand,
    String? department,
    String? category,
    double? sellingPrice,
    double? costPrice,
    int? stockQuantity,
    int? minStockThreshold,
    String? description,
    String? imageUrl,
    Map<String, String>? specifications,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      brand: brand ?? this.brand,
      department: department ?? this.department,
      category: category ?? this.category,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      specifications: specifications ?? this.specifications,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class InventoryLog {
  final String id;
  final String productId;
  final String productName;
  final String type; // 'RESTOCK', 'MANUAL_ADJUST', 'SALE', 'DAMAGED'
  final int quantityChange;
  final int resultingStock;
  final String reason;
  final DateTime timestamp;

  InventoryLog({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantityChange,
    required this.resultingStock,
    required this.reason,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Departments and Categories for Captain Sports Store
class StoreCategories {
  static const Map<String, List<String>> departmentCategories = {
    'Cricket': [
      'Cricket Bats',
      'Batting Gloves',
      'Pads & Leg Guards',
      'Cricket Balls',
      'Helmets & Protection',
      'Cricket Spikes Shoes',
      'Kit Bags'
    ],
    'Badminton': [
      'Badminton Rackets',
      'Shuttlecocks',
      'Grips & Strings',
      'Badminton Shoes',
      'Racket Bags'
    ],
    'Football': [
      'Football Balls',
      'Football Boots & Studs',
      'Goalkeeper Gloves',
      'Shin Guards',
      'Team Jerseys'
    ],
    'Swimming': [
      'Swimwear & Jammers',
      'Swimming Goggles',
      'Swim Caps',
      'Kickboards & Fins',
      'Towels & Accessories'
    ],
    'Gym & Fitness': [
      'Dumbbells & Barbells',
      'Resistance Bands',
      'Yoga & Fitness Mats',
      'Gym Belts & Straps',
      'Supplements & Shakers'
    ],
    'Running & Athletics': [
      'Running Shoes',
      'Compression Gear',
      'Track Pants & Shorts',
      'Hydration Bottles'
    ],
  };

  static List<String> get allDepartments => departmentCategories.keys.toList();
}

/// Initial Mock Products for Captain Sports Store (Sri Lanka)
List<Product> getInitialMockProducts() {
  return [
    Product(
      id: 'CS-001',
      name: 'SS Ton Gladiator English Willow Cricket Bat',
      sku: 'BAT-SS-GLAD-01',
      brand: 'SS Sunridges',
      department: 'Cricket',
      category: 'Cricket Bats',
      sellingPrice: 75000.0,
      costPrice: 58000.0,
      stockQuantity: 4,
      minStockThreshold: 5,
      description: 'Grade 1 air dried English willow bat crafted for explosive stroke play with thick edges and clean straight grains.',
      specifications: {
        'Willow': 'Grade 1 English Willow',
        'Weight': '2lb 8oz',
        'Handle': '12-piece cane handle',
        'Size': 'Short Handle (SH)'
      },
      imageUrl: 'https://images.unsplash.com/photo-1593341646782-e0b495cff86d?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-002',
      name: 'Yonex Astrox 88D Pro Graphite Racket',
      sku: 'RKT-YNX-88D-PR',
      brand: 'Yonex',
      department: 'Badminton',
      category: 'Badminton Rackets',
      sellingPrice: 58500.0,
      costPrice: 42000.0,
      stockQuantity: 14,
      minStockThreshold: 8,
      description: 'Rotational generator system for aggressive rear-court doubles smashes. Made in Japan with high modulus graphite.',
      specifications: {
        'Flex': 'Stiff',
        'Weight/Grip': '4U (Avg. 83g) G5',
        'String Tension': '20 - 28 lbs',
        'Balance': 'Head Heavy'
      },
      imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-003',
      name: 'Adidas Pro Match Official Match Football',
      sku: 'BAL-ADI-PRO-05',
      brand: 'Adidas',
      department: 'Football',
      category: 'Football Balls',
      sellingPrice: 22000.0,
      costPrice: 15500.0,
      stockQuantity: 28,
      minStockThreshold: 10,
      description: 'FIFA Quality Pro certified thermally bonded seamless match ball designed for championship tournaments.',
      specifications: {
        'Size': 'Size 5 (Official)',
        'Construction': 'Thermally bonded seamless surface',
        'Bladder': 'High-grade butyl bladder'
      },
      imageUrl: 'https://images.unsplash.com/photo-1614632537423-1e6c2e7e0aab?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-004',
      name: 'Speedo Fastskin Hyper Elite Mirror Goggles',
      sku: 'SWM-SPD-HYP-01',
      brand: 'Speedo',
      department: 'Swimming',
      category: 'Swimming Goggles',
      sellingPrice: 16500.0,
      costPrice: 11000.0,
      stockQuantity: 2,
      minStockThreshold: 6,
      description: 'Hydrodynamic racing goggles packed with IQfit 3D seal technology for zero leakage and minimum drag in competitive swimming.',
      specifications: {
        'Lens': 'Mirrored Anti-Fog Polycarbonate',
        'Strap': 'IQfit tension scale strap',
        'Nose Bridge': '4 interchangeable bridges'
      },
      imageUrl: 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-005',
      name: 'Kookaburra Kahuna Pro Batting Gloves',
      sku: 'GLV-KKB-KAH-01',
      brand: 'Kookaburra',
      department: 'Cricket',
      category: 'Batting Gloves',
      sellingPrice: 18500.0,
      costPrice: 13000.0,
      stockQuantity: 0,
      minStockThreshold: 5,
      description: 'Premium sheep leather palm with multi-flex chamber protection and high-density foam finger rolls.',
      specifications: {
        'Palm': 'Top Grade Pittards Leather',
        'Protection': 'Tri-Layer Poron XRD foam',
        'Size': 'Men Right Hand'
      },
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-006',
      name: 'Cast Iron Hex Rubber Encased Dumbbell (Pair 15kg)',
      sku: 'GYM-HEX-DB-15',
      brand: 'Captain Pro',
      department: 'Gym & Fitness',
      category: 'Dumbbells & Barbells',
      sellingPrice: 32000.0,
      costPrice: 22000.0,
      stockQuantity: 18,
      minStockThreshold: 5,
      description: 'Anti-roll hexagonal heavy duty rubber coated cast iron dumbbell with ergonomic knurled chrome handle.',
      specifications: {
        'Weight': '15kg x 2 (30kg Total)',
        'Material': 'Cast Iron core with virgin rubber coating',
        'Grip': 'Ergonomic knurled steel'
      },
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500&auto=format&fit=crop&q=60',
    ),
    Product(
      id: 'CS-007',
      name: 'Nike Air Zoom Pegasus 40 Running Shoes',
      sku: 'SHO-NIK-PEG-40',
      brand: 'Nike',
      department: 'Running & Athletics',
      category: 'Running Shoes',
      sellingPrice: 48000.0,
      costPrice: 34000.0,
      stockQuantity: 7,
      minStockThreshold: 10,
      description: 'Responsive daily running trainer equipped with dual Zoom Air units and engineered breathable mesh upper.',
      specifications: {
        'Cushioning': 'Nike React foam + Dual Zoom Air',
        'Drop': '10mm',
        'Size Range': 'UK 7, 8, 9, 10, 11'
      },
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60',
    ),
  ];
}
