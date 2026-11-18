import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_widgets.dart';

class InventoryManagementScreen extends StatefulWidget {
  final List<Product> products;
  final List<InventoryLog> logs;
  final Function(Product, int, String) onStockAdjusted;

  const InventoryManagementScreen({
    Key? key,
    required this.products,
    required this.logs,
    required this.onStockAdjusted,
  }) : super(key: key);

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Low Stock, Out of Stock, Healthy
  final TextEditingController _searchController = TextEditingController();

  List<Product> get _filteredProducts {
    return widget.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.department.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesLevel = true;
      if (_selectedFilter == 'Low Stock') {
        matchesLevel = p.status == StockStatus.lowStock;
      } else if (_selectedFilter == 'Out of Stock') {
        matchesLevel = p.status == StockStatus.outOfStock;
      } else if (_selectedFilter == 'Healthy') {
        matchesLevel = p.status == StockStatus.inStock;
      }

      return matchesSearch && matchesLevel;
    }).toList();
  }

  void _openStockAdjustmentModal(Product product) {
    int adjustmentAmount = 10;
    String adjustmentType = 'RESTOCK';
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppTheme.accentRed, width: 1.5),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDeduction = adjustmentType == 'DAMAGED' || adjustmentType == 'MANUAL_DECREMENT';
          final resultingStock = isDeduction
              ? (product.stockQuantity - adjustmentAmount).clamp(0, 999999)
              : product.stockQuantity + adjustmentAmount;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sync_alt, color: AppTheme.accentRed),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Stock Quantity Adjustment',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            product.name,
                            style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF282830), height: 24),

                // Adjustment Types
                const Text('Adjustment Type:',
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Restock (+)'),
                      selected: adjustmentType == 'RESTOCK',
                      selectedColor: AppTheme.primaryRed,
                      onSelected: (val) => setModalState(() => adjustmentType = 'RESTOCK'),
                    ),
                    ChoiceChip(
                      label: const Text('Damaged / Defect (-)'),
                      selected: adjustmentType == 'DAMAGED',
                      selectedColor: AppTheme.accentRed,
                      onSelected: (val) => setModalState(() => adjustmentType = 'DAMAGED'),
                    ),
                    ChoiceChip(
                      label: const Text('Customer Return (+)'),
                      selected: adjustmentType == 'RETURN',
                      selectedColor: AppTheme.primaryRed,
                      onSelected: (val) => setModalState(() => adjustmentType = 'RETURN'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Counter control
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222228),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Adjust Quantity Units',
                              style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 11)),
                          Text(
                            '${isDeduction ? '-' : '+'}$adjustmentAmount Units',
                            style: TextStyle(
                              color: isDeduction ? AppTheme.accentRed : const Color(0xFF34D399),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.white70, size: 28),
                            onPressed: () {
                              if (adjustmentAmount > 1) {
                                setModalState(() => adjustmentAmount--);
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.cardBlack,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderSubtleRed),
                            ),
                            child: Text(
                              '$adjustmentAmount',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: AppTheme.accentRed, size: 28),
                            onPressed: () {
                              setModalState(() => adjustmentAmount++);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Resulting Stock Calculation Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131316),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderSubtleRed),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current: ${product.stockQuantity} units',
                        style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 13),
                      ),
                      const Icon(Icons.arrow_forward, color: AppTheme.accentRed, size: 16),
                      Text(
                        'New Stock: $resultingStock units',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Audit Note / Batch Reference (Optional)',
                    hintText: 'e.g., Supplier Batch #902 or Shelf Inspection',
                    prefixIcon: Icon(Icons.note_alt_outlined, color: AppTheme.accentRed),
                  ),
                ),
                const SizedBox(height: 20),

                CaptainPrimaryButton(
                  label: 'Commit Inventory Change',
                  icon: Icons.check,
                  onPressed: () {
                    final netChange = isDeduction ? -adjustmentAmount : adjustmentAmount;
                    final note = noteController.text.trim().isEmpty
                        ? adjustmentType
                        : '$adjustmentType: ${noteController.text.trim()}';

                    widget.onStockAdjusted(product, netChange, note);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Stock for ${product.name} updated to ${product.stockQuantity}!'),
                        backgroundColor: AppTheme.primaryRed,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogsHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: AppTheme.borderSubtleRed),
      ),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.history, color: AppTheme.accentRed),
                SizedBox(width: 10),
                Text(
                  'Inventory Movement Audit Log',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Tracks all database inventory triggers, restocks & adjustments',
              style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 12),
            ),
            const Divider(color: Color(0xFF282830), height: 24),
            Expanded(
              child: widget.logs.isEmpty
                  ? const Center(
                      child: Text('No inventory transactions recorded yet.',
                          style: TextStyle(color: AppTheme.textMutedGrey)),
                    )
                  : ListView.separated(
                      itemCount: widget.logs.length,
                      separatorBuilder: (c, i) => const Divider(color: Colors.white10),
                      itemBuilder: (c, i) {
                        final log = widget.logs[i];
                        final isPositive = log.quantityChange >= 0;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: isPositive
                                ? const Color(0xFF064E3B)
                                : AppTheme.primaryRedDark,
                            child: Icon(
                              isPositive ? Icons.add : Icons.remove,
                              color: isPositive ? const Color(0xFF34D399) : AppTheme.accentRed,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            log.productName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                          ),
                          subtitle: Text(
                            '${log.reason} • Result: ${log.resultingStock} in stock',
                            style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 12),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isPositive ? "+" : ""}${log.quantityChange}',
                                style: TextStyle(
                                  color: isPositive ? const Color(0xFF34D399) : AppTheme.accentRed,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: Color(0xFF71717A), fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final totalUnits = widget.products.fold<int>(0, (sum, p) => sum + p.stockQuantity);
    final totalValuation = widget.products.fold<double>(0.0, (sum, p) => sum + (p.stockQuantity * p.sellingPrice));
    final lowStockItems = widget.products.where((p) => p.status == StockStatus.lowStock).toList();
    final outOfStockItems = widget.products.where((p) => p.status == StockStatus.outOfStock).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLightGrey,
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppTheme.accentRed),
            tooltip: 'View Audit Logs',
            onPressed: _showLogsHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // KPI Metric Grid (Black Cards)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: KpiMetricCard(
                    title: 'Total Stock Units',
                    value: '$totalUnits',
                    icon: Icons.inventory,
                    accentColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KpiMetricCard(
                    title: 'Total Stock Value',
                    value: 'Rs. ${(totalValuation / 1000).toStringAsFixed(1)}K',
                    icon: Icons.monetization_on,
                    accentColor: const Color(0xFF34D399),
                  ),
                ),
              ],
            ),
          ),

          // Low Stock Alert Banner (If items need attention)
          if (lowStockItems.isNotEmpty || outOfStockItems.isNotEmpty)
            CaptainBlackCard(
              hasRedLeftGlow: true,
              margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notification_important, color: AppTheme.accentRed, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Attention Required!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          '${lowStockItems.length} low stock & ${outOfStockItems.length} out-of-stock items.',
                          style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {
                      setState(() => _selectedFilter = 'Low Stock');
                    },
                    child: const Text('Filter Alerts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search inventory by sport, SKU or name...',
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                for (final opt in ['All', 'Low Stock', 'Out of Stock', 'Healthy'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(opt),
                      selected: _selectedFilter == opt,
                      selectedColor: AppTheme.primaryRed,
                      labelStyle: TextStyle(
                        color: _selectedFilter == opt ? Colors.white : AppTheme.textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (val) => setState(() => _selectedFilter = opt),
                    ),
                  ),
              ],
            ),
          ),

          // Inventory Item List (Black Cards)
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No inventory records matching your filter.',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      final isLow = product.status != StockStatus.inStock;

                      return CaptainBlackCard(
                        hasRedLeftGlow: isLow,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Sport thumbnail
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF25252D),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppTheme.borderSubtleRed),
                                  ),
                                  child: product.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                          child: Image.network(product.imageUrl!, fit: BoxFit.cover),
                                        )
                                      : const Icon(Icons.sports, color: AppTheme.accentRed, size: 24),
                                ),
                                const SizedBox(width: 12),

                                // Product Title & SKU
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'SKU: ${product.sku} • ${product.department}',
                                        style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),

                                // Status Pill
                                StockStatusBadge(status: product.status, count: product.stockQuantity),
                              ],
                            ),

                            const Divider(color: Color(0xFF282830), height: 18),

                            // Inventory Metrics & Quick Adjust Controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('CURRENT LEVEL',
                                        style: TextStyle(
                                            color: AppTheme.textMutedGrey, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                    Text(
                                      '${product.stockQuantity} Units',
                                      style: TextStyle(
                                        color: isLow ? AppTheme.accentRed : Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'Threshold: ${product.minStockThreshold} units',
                                      style: const TextStyle(color: Color(0xFF71717A), fontSize: 10.5),
                                    ),
                                  ],
                                ),

                                // Quick Stock Adjust Action
                                Row(
                                  children: [
                                    // Quick decrement
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white60, size: 24),
                                      tooltip: 'Quick -1 unit',
                                      onPressed: () {
                                        if (product.stockQuantity > 0) {
                                          widget.onStockAdjusted(product, -1, 'Quick Decrement (-1)');
                                        }
                                      },
                                    ),
                                    // Quick increment
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: AppTheme.accentRed, size: 24),
                                      tooltip: 'Quick +1 unit',
                                      onPressed: () {
                                        widget.onStockAdjusted(product, 1, 'Quick Increment (+1)');
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    // Full modal adjuster
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryRed,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.tune, size: 16),
                                      label: const Text('Adjust', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      onPressed: () => _openStockAdjustmentModal(product),
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
