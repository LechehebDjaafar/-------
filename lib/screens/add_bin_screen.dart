import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bin.dart';

class AddBinScreen extends StatefulWidget {
  final Function(Bin) onBinAdded;
  final Bin? initialBin; // إضافة للسماح بالتعديل

  const AddBinScreen({
    super.key,
    required this.onBinAdded,
    this.initialBin,
  });

  @override
  State<AddBinScreen> createState() => _AddBinScreenState();
}

class _AddBinScreenState extends State<AddBinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedType = 'عادية';
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.initialBin != null) {
      _nameController.text = widget.initialBin!.name;
      _addressController.text = widget.initialBin!.address;
      _selectedType = widget.initialBin!.type;
      _selectedLocation = LatLng(
        widget.initialBin!.latitude,
        widget.initialBin!.longitude,
      );
    }
  }

  final List<String> _binTypes = ['عادية', 'إعادة تدوير', 'نفايات خطرة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.initialBin != null ? 'تعديل السلة' : 'إضافة سلة جديدة'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم السلة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم السلة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال العنوان';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'نوع السلة',
                border: OutlineInputBorder(),
              ),
              items: _binTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 300, // زيادة ارتفاع الخريطة
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(36.1671, 1.3337),
                      zoom: 13,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    onTap: (latLng) {
                      setState(() {
                        _selectedLocation = latLng;
                      });
                    },
                    markers: _selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _selectedLocation!,
                            ),
                          }
                        : {},
                    zoomControlsEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                  if (_selectedLocation != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton.small(
                        onPressed: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(_selectedLocation!),
                          );
                        },
                        child: const Icon(Icons.center_focus_strong),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedLocation != null) {
                  final bin = Bin(
                    id: widget.initialBin?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text,
                    latitude: _selectedLocation!.latitude,
                    longitude: _selectedLocation!.longitude,
                    fillLevel: widget.initialBin?.fillLevel ?? 0,
                    address: _addressController.text,
                    type: _selectedType,
                  );
                  widget.onBinAdded(bin);
                  Navigator.pop(context);
                } else if (_selectedLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('الرجاء تحديد موقع السلة على الخريطة')),
                  );
                }
              },
              child: Text(
                  widget.initialBin != null ? 'حفظ التغييرات' : 'إضافة السلة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
