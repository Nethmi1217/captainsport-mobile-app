import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_widgets.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onSave;

  const EditProductScreen({
    Key? key,
    required this.product,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _skuController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _costPriceController;
  late TextEditingController _stockController;
  late TextEditingController _thresholdController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  late String _selectedDepartment;
  late String _selectedCategory;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _brandController = TextEditingController(text: widget.product.brand);
    _skuController = TextEditingController(text: widget.product.sku);
    _sellingPriceController = TextEditingController(text: widget.product.sellingPrice.toStringAsFixed(2));
    _costPriceController = TextEditingController(text: widget.product.costPrice.toStringAsFixed(2));
    _stockController = TextEditingController(text: widget.product.stockQuantity.toString());
    _thresholdController = TextEditingController(text: widget.product.minStockThreshold.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl ?? '');

    _selectedDepartment = widget.product.department;
    _selectedCategory = widget.product.category;
    _isActive = widget.product.isActive;
  }

  void _onDepartmentChanged(String? newDept) {
    if (newDept != null) {
      setState(() {
        _selectedDepartment = newDept;
        final availableCategories = StoreCategories.departmentCategories[newDept] ?? ['General'];
        if (!availableCategories.contains(_selectedCategory)) {
          _selectedCategory = availableCategories.first;
        }
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updated = widget.product.copyWith(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        brand: _brandController.text.trim(),
        department: _selectedDepartment,
        category: _selectedCategory,
        sellingPrice: double.tryParse(_sellingPriceController.text) ?? widget.product.sellingPrice,
        costPrice: double.tryParse(_costPriceController.text) ?? widget.product.costPrice,
        stockQuantity: int.tryParse(_stockController.text) ?? widget.product.stockQuantity,
        minStockThreshold: int.tryParse(_thresholdController.text) ?? widget.product.minStockThreshold,
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
        isActive: _isActive,
        updatedAt: DateTime.now(),
      );

      widget.onSave(updated);
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = StoreCategories.departmentCategories[_selectedDepartment] ?? ['General'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLightGrey,
      appBar: AppBar(
        title: Text('Edit: ${widget.product.sku}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.accentRed),
            tooltip: 'Save Changes',
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Status & Overview Banner
            CaptainBlackCard(
              hasRedLeftGlow: widget.product.status != StockStatus.inStock,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFF24242C),
                      child: widget.product.imageUrl != null
                          ? Image.network(
                              widget.product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.sports, color: AppTheme.accentRed),
                            )
                          : const Icon(Icons.sports, color: AppTheme.accentRed),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            StockStatusBadge(status: widget.product.status, count: widget.product.stockQuantity),
                            const SizedBox(width: 8),
                            Text(
                              'ID: ${widget.product.id}',
                              style: const TextStyle(color: AppTheme.textMutedGrey, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section 1: Department & Category
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Department & Sport Classification',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color(0xFF282830), height: 20),
                  const Text('Sport / Department',
                      style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    dropdownColor: AppTheme.cardBlack,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    items: StoreCategories.allDepartments.map((d) {
                      return DropdownMenuItem(value: d, child: Text(d));
                    }).toList(),
                    onChanged: _onDepartmentChanged,
                  ),
                  const SizedBox(height: 14),
                  const Text('Category',
                      style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                    dropdownColor: AppTheme.cardBlack,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    items: categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (c) {
                      if (c != null) setState(() => _selectedCategory = c);
                    },
                  ),
                ],
              ),
            ),

            // Section 2: Product Details
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Specifications & Branding',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color(0xFF282830), height: 20),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      prefixIcon: Icon(Icons.edit, color: AppTheme.accentRed),
                    ),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _brandController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Brand',
                            prefixIcon: Icon(Icons.branding_watermark, color: AppTheme.accentRed),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _skuController,
                          style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                          decoration: const InputDecoration(
                            labelText: 'SKU Code',
                            prefixIcon: Icon(Icons.qr_code, color: AppTheme.accentRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            // Section 3: Pricing & Inventory
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pricing & Stock Levels',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color(0xFF282830), height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sellingPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Selling Price (Rs.)',
                            prefixText: 'LKR ',
                            prefixStyle: TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _costPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Cost Price (Rs.)',
                            prefixText: 'LKR ',
                            prefixStyle: TextStyle(color: AppTheme.textMutedGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Current Stock',
                            prefixIcon: Icon(Icons.inventory_2, color: AppTheme.accentRed),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _thresholdController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Low Stock Alert Limit',
                            prefixIcon: Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primaryRed,
                    title: const Text('Store Visibility',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Show or hide product in customer app',
                        style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 12)),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                ],
              ),
            ),

            // Section 4: Image URL
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Image URL',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color(0xFF282830), height: 20),
                  TextFormField(
                    controller: _imageUrlController,
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Image Web URL',
                      prefixIcon: Icon(Icons.image, color: AppTheme.accentRed),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  CaptainPrimaryButton(
                    label: 'Save & Update Product',
                    icon: Icons.save,
                    onPressed: _saveChanges,
                  ),
                  const SizedBox(height: 10),
                  CaptainPrimaryButton(
                    label: 'Cancel Without Saving',
                    isSecondary: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
