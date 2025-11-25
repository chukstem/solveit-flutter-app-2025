import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:solveit/core/injections/auth.dart';
import 'package:solveit/core/widgets/buttons.dart';
import 'package:solveit/features/market/domain/models/requests/requests.dart';
import 'package:solveit/features/market/presentation/viewmodel/market_viewmodel.dart';
import 'package:solveit/utils/extensions.dart';
import 'package:solveit/utils/theme/theme_extensions.dart';
import 'package:solveit/utils/theme/widgets/textfields/htext_fields.dart';

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({super.key});

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _costController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isLoading = false;
  String? _selectedTagId;
  String? _images;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _costController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final viewModel = context.read<MarketViewModel>();

      final schoolId = userStateManager.state.token.user?.schoolId ?? 0;
      final studentId = userStateManager.state.token.user?.id ?? 0;
      final userId = userStateManager.state.token.user?.id ?? 0;

      viewModel.createProductRequest = CreateProductRequest(
        schoolId: schoolId,
        marketProductTagId: int.parse(_selectedTagId!),
        studentId: studentId,
        userId: userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        images: _images ?? '',
        amount: _amountController.text.trim(),
        cost: _costController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        comment: _commentController.text.trim(),
        active: true,
      );

      final success = await viewModel.createProduct();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        viewModel.getAllMarketElements(); // Refresh the products list
      } else {
        context.showError('Failed to create product: ${viewModel.state.errorMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MarketViewModel>();

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Product",
                style: context.titleLarge,
              ),
              SizedBox(height: 20.h),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTagId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: viewModel.marketTags?.data.map((tag) {
                  return DropdownMenuItem(
                    value: tag.id.toString(),
                    child: Text(tag.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTagId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              HTextField(
                controller: _titleController,
                title: "Product Title",
                hint: "Enter product title",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              HTextField(
                controller: _descriptionController,
                title: "Description",
                hint: "Enter product description",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: HTextField(
                      controller: _amountController,
                      title: "Amount",
                      hint: "Enter amount",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: HTextField(
                      controller: _costController,
                      title: "Cost",
                      hint: "Enter cost",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              HTextField(
                controller: _locationController,
                title: "Location",
                hint: "Enter product location",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: HTextField(
                      controller: _phoneController,
                      title: "Phone",
                      hint: "Enter phone number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: HTextField(
                      controller: _whatsappController,
                      title: "WhatsApp",
                      hint: "Enter WhatsApp number",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              HTextField(
                controller: _commentController,
                title: "Additional Comments",
                hint: "Enter any additional comments",
              ),
              SizedBox(height: 25.h),

              HFilledButton(
                text: "Create Product",
                onPressed: _submitForm,
                loading: _isLoading,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
