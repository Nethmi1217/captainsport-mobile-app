import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_widgets.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProductManagementScreen extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductAdded;
  final Function(Product) onProductUpdated;
  final Function(String) onProductDeleted;
  final Function(Product, int, String) onStockAdjusted;

  const ProductManagementScreen({
    Key? key,
    required this.products,
    required this.onProductAdded,
    required this.onProductUpdated,
    required this.onProductDeleted,
    required this.onStockAdjusted,
  }) : super(key: key);

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  StockStatus? _selectedStockStatusFilter;
  final TextEditingController _searchController = TextEditingController();

  List<Product> get _filteredProducts {
    return widget.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesDepartment = _selectedDepartment == 'All' || p.department == _selectedDepartment;

      final matchesStatus = _selectedStockStatusFilter == null || p.status == _selectedStockStatusFilter;

      return matchesSearch && matchesDepartment && matchesStatus;
    }).toList();
  }

  void _navigateToAddProduct() async {
    final newProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          onSave: (product) {
            widget.onProductAdded(product);
          },
        ),
      ),
    );

    if (newProduct != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newProduct.name} added successfully!'),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigateToEditProduct(Product product) async {
    final updatedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          product: product,
          onSave: (prod) {
            widget.onProductUpdated(prod);
          },
        ),
      ),
    );

    if (updatedProduct != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedProduct.name} updated!'),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.accentRed, width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: AppTheme.accentRed),
            SizedBox(width: 8),
            Text(
              'Remove Product',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${product.name}"? This action cannot be undone.',
          style: const TextStyle(color: AppTheme.textMutedGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onProductDeleted(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${product.name}'),
                  backgroundColor: AppTheme.primaryRedDark,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showQuickStockAdjust(Product product) {
    final qtyController = TextEditingController();
    String reason = 'Restock';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppTheme.accentRed, width: 1),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.inventory_2, color: AppTheme.accentRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Quick Stock Update: ${product.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Current Stock: ${product.stockQuantity} units',
                style: const TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Quantity to Add / Adjust',
                  hintText: 'e.g. +10 or 25',
                  prefixIcon: const Icon(Icons.numbers, color: AppTheme.accentRed),
                  fillColor: const Color(0xFF24242C),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: reason,
                dropdownColor: AppTheme.cardBlack,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Adjustment Reason',
                  prefixIcon: Icon(Icons.label_outline, color: AppTheme.accentRed),
                ),
                items: ['Restock', 'Physical Count Adjustment', 'Damaged / Write-off', 'Customer Return']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setSheetState(() => reason = val);
                },
              ),
              const SizedBox(height: 20),
              CaptainPrimaryButton(
                label: 'Confirm Stock Update',
                icon: Icons.check,
                onPressed: () {
                  final entered = int.tryParse(qtyController.text);
                  if (entered != null) {
                    widget.onStockAdjusted(product, entered, reason);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updated stock for ${product.name} to ${product.stockQuantity}'),
                        backgroundColor: AppTheme.primaryRed,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final lowStockCount = widget.products.where((p) => p.status == StockStatus.lowStock).length;
    final outOfStockCount = widget.products.where((p) => p.status == StockStatus.outOfStock).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLightGrey,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.sports_basketball, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CAPTAIN SPORTS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text('Product & Catalog Management',
                    style: TextStyle(fontSize: 11, color: AppTheme.textMutedGrey, fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppTheme.accentRed),
            onPressed: () {
              // Toggle or reset filters
              setState(() {
                _selectedDepartment = 'All';
                _selectedStockStatusFilter = null;
                _searchController.clear();
                _searchQuery = '';
              });
            },
            tooltip: 'Reset Filters',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        backgroundColor: AppTheme.primaryRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // KPI Metric Bar (Black cards on light grey background)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: KpiMetricCard(
                    title: 'Total Items',
                    value: '${widget.products.length}',
                    icon: Icons.inventory_2_outlined,
                    accentColor: Colors.white70,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KpiMetricCard(
                    title: 'Low Stock',
                    value: '$lowStockCount',
                    icon: Icons.warning_amber_rounded,
                    accentColor: AppTheme.accentRed,
                    subtitle: lowStockCount > 0 ? 'Needs restock' : 'Healthy',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KpiMetricCard(
                    title: 'Out of Stock',
                    value: '$outOfStockCount',
                    icon: Icons.error_outline,
                    accentColor: AppTheme.primaryRed,
                    subtitle: outOfStockCount > 0 ? 'Action required' : 'None',
                  ),
                ),
              ],
            ),
          ),

          // Search and Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search by sports item name, brand, SKU...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryRed),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppTheme.primaryRed, width: 2),
                ),
              ),
            ),
          ),

          // Sports Category Horizontal Filter Chips
          Container(
            height: 44,
            margin: const EdgeInsets.only(bottom: 6),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SportDepartmentFilterChip(
                  label: 'All Sports',
                  isSelected: _selectedDepartment == 'All',
                  onSelected: () => setState(() => _selectedDepartment = 'All'),
                ),
                ...StoreCategories.allDepartments.map((dept) => SportDepartmentFilterChip(
                      label: dept,
                      isSelected: _selectedDepartment == dept,
                      onSelected: () => setState(() => _selectedDepartment = dept),
                    )),
              ],
            ),
          ),

          // Product List Header & Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PRODUCTS (${filtered.length})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Color(0xFF4B5563),
                  ),
                ),
                // Quick Stock Filter
                Row(
                  children: [
                    FilterChip(
                      label: const Text('Low / Out Only', style: TextStyle(fontSize: 11)),
                      selected: _selectedStockStatusFilter != null,
                      onSelected: (val) {
                        setState(() {
                          _selectedStockStatusFilter = val ? StockStatus.lowStock : null;
                        });
                      },
                      selectedColor: AppTheme.accentRed.withOpacity(0.2),
                      checkmarkColor: AppTheme.primaryRed,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Product Cards List (Black Cards)
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sports_volleyball, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No sports products found',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text('Try adjusting search filters or add a new product',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _navigateToAddProduct,
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Product'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryRed),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final isLowOrOut = product.status != StockStatus.inStock;

                      return CaptainBlackCard(
                        hasRedLeftGlow: isLowOrOut,
                        onTap: () => _navigateToEditProduct(product),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail or Sport Icon Badge
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF282830),
                                      border: Border.all(color: AppTheme.borderSubtleRed),
                                    ),
                                    child: product.imageUrl != null
                                        ? Image.network(
                                            product.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) => const Icon(
                                              Icons.sports,
                                              color: AppTheme.accentRed,
                                              size: 32,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.sports,
                                            color: AppTheme.accentRed,
                                            size: 32,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Product Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryRed.withOpacity(0.18),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              product.department.toUpperCase(),
                                              style: const TextStyle(
                                                color: AppTheme.accentRed,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '• ${product.brand}',
                                            style: const TextStyle(
                                              color: AppTheme.textMutedGrey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                          height: 1.25,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'SKU: ${product.sku}',
                                        style: const TextStyle(
                                          color: Color(0xFF888894),
                                          fontSize: 11,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Overflow Menu
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                                  color: AppTheme.cardBlack,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: AppTheme.borderSubtleRed),
                                  ),
                                  onSelected: (action) {
                                    switch (action) {
                                      case 'edit':
                                        _navigateToEditProduct(product);
                                        break;
                                      case 'adjust_stock':
                                        _showQuickStockAdjust(product);
                                        break;
                                      case 'delete':
                                        _confirmDelete(product);
                                        break;
                                    }
                                  },
                                  itemBuilder: (ctx) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 18, color: AppTheme.accentRed),
                                          SizedBox(width: 10),
                                          Text('Edit Product', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'adjust_stock',
                                      child: Row(
                                        children: [
                                          Icon(Icons.inventory, size: 18, color: Colors.amber),
                                          SizedBox(width: 10),
                                          Text('Adjust Stock', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuDivider(height: 8),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline, size: 18, color: AppTheme.primaryRed),
                                          SizedBox(width: 10),
                                          Text('Delete', style: TextStyle(color: AppTheme.accentRed)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const Divider(color: Color(0xFF2A2A33), height: 20),

                            // Footer: Price and Stock Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SELLING PRICE',
                                      style: TextStyle(
                                        color: AppTheme.textMutedGrey,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${product.sellingPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    StockStatusBadge(
                                      status: product.status,
                                      count: product.stockQuantity,
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle, color: AppTheme.accentRed, size: 24),
                                      tooltip: 'Quick Add Stock',
                                      onPressed: () => _showQuickStockAdjust(product),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
