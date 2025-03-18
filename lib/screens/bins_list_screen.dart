import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bin.dart';
import 'add_bin_screen.dart';

class BinsListScreen extends StatefulWidget {
  final List<Bin> bins;
  const BinsListScreen({super.key, required this.bins});

  @override
  State<BinsListScreen> createState() => _BinsListScreenState();
}

class _BinsListScreenState extends State<BinsListScreen> {
  final Set<String> _selectedBins = {};
  bool _isSelectionMode = false;

  // إضافة متغيرات جديدة
  String _searchQuery = '';
  String _selectedType = 'الكل';
  final List<String> _binTypes = [
    'الكل',
    'عادية',
    'إعادة تدوير',
    'نفايات خطرة'
  ];

  // إضافة دالة للفلترة
  List<Bin> get _filteredBins => widget.bins.where((bin) {
        final matchesSearch =
            bin.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                bin.address.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesType =
            _selectedType == 'الكل' || bin.type == _selectedType;
        return matchesSearch && matchesType;
      }).toList();

  void _toggleSelection(String binId) {
    setState(() {
      if (_selectedBins.contains(binId)) {
        _selectedBins.remove(binId);
      } else {
        _selectedBins.add(binId);
      }
      _isSelectionMode = _selectedBins.isNotEmpty;
    });
  }

  void _deleteBin(Bin bin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه السلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.bins.removeWhere((b) => b.id == bin.id);
              });
              Navigator.pop(context); // إغلاق مربع الحوار
              Navigator.pop(context); // إغلاق تفاصيل السلة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف السلة بنجاح')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editBin(Bin bin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBinScreen(
          initialBin: bin,
          onBinAdded: (updatedBin) {
            setState(() {
              final index = widget.bins.indexWhere((b) => b.id == bin.id);
              if (index != -1) {
                widget.bins[index] = updatedBin;
              }
            });
            Navigator.pop(context); // إغلاق تفاصيل السلة
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث السلة بنجاح')),
            );
          },
        ),
      ),
    );
  }

  void _showBinDetails(Bin bin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with bin info
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: bin.fillLevel > 80
                                      ? Colors.red
                                      : bin.fillLevel > 50
                                          ? Colors.orange
                                          : Colors.green,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(Icons.delete_outline,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bin.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      bin.type,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Fill level indicator
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'نسبة الامتلاء: ${bin.fillLevel}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: bin.fillLevel / 100,
                                      minHeight: 25,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        bin.fillLevel > 80
                                            ? Colors.red
                                            : bin.fillLevel > 50
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    child: Text(
                                      '${bin.fillLevel}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Location info
                          const Text(
                            'الموقع',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(bin.address)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target:
                                            LatLng(bin.latitude, bin.longitude),
                                        zoom: 15,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId: MarkerId(bin.id),
                                          position: LatLng(
                                              bin.latitude, bin.longitude),
                                        ),
                                      },
                                      liteModeEnabled: true,
                                      zoomControlsEnabled: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editBin(bin);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('تعديل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _deleteBin(bin),
                      icon: const Icon(Icons.delete),
                      label: const Text('حذف'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // إضافة شريط البحث والفلترة
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _binTypes.map((type) {
                      final isSelected = type == _selectedType;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(type),
                          onSelected: (selected) {
                            setState(() => _selectedType = type);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // تحديث ListView لاستخدام القائمة المفلترة
          Expanded(
            child: _filteredBins.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'لا توجد سلات'
                          : 'لا توجد نتائج للبحث',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBins.length,
                    itemBuilder: (context, index) {
                      final bin = _filteredBins[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () => _showBinDetails(bin),
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: bin.fillLevel > 80
                                            ? Colors.red[100]
                                            : bin.fillLevel > 50
                                                ? Colors.orange[100]
                                                : Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: bin.fillLevel > 80
                                            ? Colors.red
                                            : bin.fillLevel > 50
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bin.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            bin.address,
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bin.fillLevel > 80
                                            ? Colors.red
                                            : bin.fillLevel > 50
                                                ? Colors.orange
                                                : Colors.green,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${bin.fillLevel}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.bins.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBinScreen(
                      onBinAdded: (newBin) {
                        setState(() {
                          widget.bins.add(newBin);
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
