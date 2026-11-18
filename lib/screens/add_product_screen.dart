import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_widgets.dart';

class AddProductScreen extends StatefulWidget {
  final Function(Product) onSave;

  const AddProductScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _skuController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _stockController = TextEditingController(text: '10');
  final _thresholdController = TextEditingController(text: '5');
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedDepartment = 'Cricket';
  String _selectedCategory = 'Cricket Bats';
  bool _isActive = true;

  // Sample quick image URLs for demo
  final List<String> _sampleImages = [
    'https://images.unsplash.com/photo-1593341646782-e0b495cff86d?w=500&auto=format&fit=crop&q=60', // Cricket
    'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=500&auto=format&fit=crop&q=60', // Badminton
    'https://images.unsplash.com/photo-1614632537423-1e6c2e7e0aab?w=500&auto=format&fit=crop&q=60', // Football
    'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=500&auto=format&fit=crop&q=60', // Swimming
    'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=500&auto=format&fit=crop&q=60', // Dumbbells
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&auto=format&fit=crop&q=60', // Shoes
  ];

  @override
  void initState() {
    super.initState();
    _imageUrlController.text = _sampleImages[0];
    _skuController.text = 'CAP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  void _onDepartmentChanged(String? newDept) {
    if (newDept != null) {
      setState(() {
        _selectedDepartment = newDept;
        final availableCategories = StoreCategories.departmentCategories[newDept] ?? ['General'];
        _selectedCategory = availableCategories.first;
      });
    }
  }

  void _autoGenerateSku() {
    final prefix = _selectedDepartment.length >= 3
        ? _selectedDepartment.substring(0, 3).toUpperCase()
        : 'SPT';
    final randomPart = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    setState(() {
      _skuController.text = '$prefix-$randomPart';
    });
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0.0;
      final costPrice = double.tryParse(_costPriceController.text) ?? 0.0;
      final stock = int.tryParse(_stockController.text) ?? 0;
      final threshold = int.tryParse(_thresholdController.text) ?? 5;

      final newProduct = Product(
        id: 'CS-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        brand: _brandController.text.trim().isEmpty ? 'Captain Sports' : _brandController.text.trim(),
        department: _selectedDepartment,
        category: _selectedCategory,
        sellingPrice: sellingPrice,
        costPrice: costPrice,
        stockQuantity: stock,
        minStockThreshold: threshold,
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
        isActive: _isActive,
      );

      widget.onSave(newProduct);
      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = StoreCategories.departmentCategories[_selectedDepartment] ?? ['General'];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLightGrey,
      appBar: AppBar(
        title: const Text('Add New Sports Product'),
        actions: [
          TextButton.icon(
            onPressed: _submitProduct,
            icon: const Icon(Icons.check, color: AppTheme.accentRed),
            label: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Section 1: Product Classification (Black Card)
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.category_outlined, color: AppTheme.accentRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '1. Department & Classification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF282830), height: 24),

                  // Sport Department
                  const Text('Sport / Department *',
                      style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    dropdownColor: AppTheme.cardBlack,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sports, color: AppTheme.accentRed),
                    ),
                    items: StoreCategories.allDepartments.map((dept) {
                      return DropdownMenuItem(value: dept, child: Text(dept));
                    }).toList(),
                    onChanged: _onDepartmentChanged,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  const Text('Product Category *',
                      style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: categories.contains(_selectedCategory) ? _selectedCategory : categories.first,
                    dropdownColor: AppTheme.cardBlack,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.format_list_bulleted, color: AppTheme.accentRed),
                    ),
                    items: categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (cat) {
                      if (cat != null) setState(() => _selectedCategory = cat);
                    },
                  ),
                ],
              ),
            ),

            // Section 2: General Information (Black Card)
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.info_outline, color: AppTheme.accentRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '2. Product Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF282830), height: 24),

                  // Product Name
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                      hintText: 'e.g. SS Ton Elite English Willow Bat',
                      prefixIcon: Icon(Icons.sports_cricket, color: AppTheme.accentRed),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a product title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Brand & SKU in a Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _brandController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Brand *',
                            hintText: 'e.g. Yonex, Nike, SS',
                            prefixIcon: Icon(Icons.branding_watermark, color: AppTheme.accentRed),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Brand required';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _skuController,
                          style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                          decoration: InputDecoration(
                            labelText: 'SKU Code *',
                            prefixIcon: const Icon(Icons.qr_code, color: AppTheme.accentRed),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.auto_mode, color: AppTheme.accentRed, size: 20),
                              tooltip: 'Auto generate SKU',
                              onPressed: _autoGenerateSku,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'SKU required';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Product Description & Features',
                      hintText: 'Write material specs, warranty, size guidelines...',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),

            // Section 3: Pricing & Inventory Control (Black Card)
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.attach_money, color: AppTheme.accentRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '3. Pricing & Inventory Controls',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF282830), height: 24),

                  // Selling Price & Cost Price
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sellingPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Selling Price (Rs.) *',
                            hintText: '75000.00',
                            prefixText: 'LKR ',
                            prefixStyle: TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold),
                          ),
                          validator: (val) {
                            if (val == null || double.tryParse(val) == null) {
                              return 'Enter valid price';
                            }
                            return null;
                          },
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
                            hintText: '55000.00',
                            prefixText: 'LKR ',
                            prefixStyle: TextStyle(color: AppTheme.textMutedGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Initial Stock & Low Stock Threshold
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Initial Stock Qty *',
                            prefixIcon: Icon(Icons.inventory, color: AppTheme.accentRed),
                          ),
                          validator: (val) {
                            if (val == null || int.tryParse(val) == null) {
                              return 'Enter quantity';
                            }
                            return null;
                          },
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
                            hintText: '5',
                            prefixIcon: Icon(Icons.notifications_active_outlined, color: AppTheme.accentRed),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section 4: Image & Status (Black Card)
            CaptainBlackCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.photo_library_outlined, color: AppTheme.accentRed, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '4. Image & Visibility',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF282830), height: 24),

                  // Image URL input
                  TextFormField(
                    controller: _imageUrlController,
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Image Web URL',
                      prefixIcon: const Icon(Icons.link, color: AppTheme.accentRed),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _imageUrlController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick preset images
                  const Text('Or Select Preset Sports Demo Image:',
                      style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 12)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sampleImages.length,
                      separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                      itemBuilder: (ctx, idx) {
                        final img = _sampleImages[idx];
                        final isSelected = _imageUrlController.text == img;
                        return GestureDetector(
                          onTap: () => setState(() => _imageUrlController.text = img),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppTheme.accentRed : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(img, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Active Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppTheme.primaryRed,
                    title: const Text('Publish Immediately',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Make product visible on customer mobile app',
                        style: TextStyle(color: AppTheme.textMutedGrey, fontSize: 12)),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                ],
              ),
            ),

            // Save Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  CaptainPrimaryButton(
                    label: 'Publish Product to Catalog',
                    icon: Icons.cloud_upload_outlined,
                    onPressed: _submitProduct,
                  ),
                  const SizedBox(height: 10),
                  CaptainPrimaryButton(
                    label: 'Cancel & Discard',
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
