import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'theme/app_theme.dart';
import 'screens/product_management_screen.dart';
import 'screens/inventory_management_screen.dart';

void main() {
  runApp(const CaptainSportsApp());
}

class CaptainSportsApp extends StatelessWidget {
  const CaptainSportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Captain Sports Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AdminHomeScreen(),
    );
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentTabIndex = 0;
  late List<Product> _products;
  final List<InventoryLog> _inventoryLogs = [];

  @override
  void initState() {
    super.initState();
    _products = getInitialMockProducts();

    // Initial log entries
    _inventoryLogs.addAll([
      InventoryLog(
        id: 'LOG-01',
        productId: 'CS-001',
        productName: 'SS Ton Gladiator English Willow Cricket Bat',
        type: 'RESTOCK',
        quantityChange: 10,
        resultingStock: 4,
        reason: 'Supplier batch restock',
      ),
      InventoryLog(
        id: 'LOG-02',
        productId: 'CS-005',
        productName: 'Kookaburra Kahuna Pro Batting Gloves',
        type: 'SALE',
        quantityChange: -5,
        resultingStock: 0,
        reason: 'Bulk team purchase fulfillment',
      ),
    ]);
  }

  void _handleProductAdded(Product product) {
    setState(() {
      _products.insert(0, product);
      _inventoryLogs.insert(
        0,
        InventoryLog(
          id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          productName: product.name,
          type: 'RESTOCK',
          quantityChange: product.stockQuantity,
          resultingStock: product.stockQuantity,
          reason: 'Initial catalog creation',
        ),
      );
    });
  }

  void _handleProductUpdated(Product updatedProduct) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
    });
  }

  void _handleProductDeleted(String productId) {
    setState(() {
      _products.removeWhere((p) => p.id == productId);
    });
  }

  void _handleStockAdjusted(Product product, int delta, String reason) {
    setState(() {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        final newStock = (_products[index].stockQuantity + delta).clamp(0, 999999);
        _products[index].stockQuantity = newStock;

        _inventoryLogs.insert(
          0,
          InventoryLog(
            id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
            productId: product.id,
            productName: product.name,
            type: delta >= 0 ? 'RESTOCK' : 'ADJUSTMENT',
            quantityChange: delta,
            resultingStock: newStock,
            reason: reason,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ProductManagementScreen(
        products: _products,
        onProductAdded: _handleProductAdded,
        onProductUpdated: _handleProductUpdated,
        onProductDeleted: _handleProductDeleted,
        onStockAdjusted: _handleStockAdjusted,
      ),
      InventoryManagementScreen(
        products: _products,
        logs: _inventoryLogs,
        onStockAdjusted: _handleStockAdjusted,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (idx) => setState(() => _currentTabIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer_outlined),
            activeIcon: Icon(Icons.sports_soccer),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
