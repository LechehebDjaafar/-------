import 'package:flutter/material.dart';
import '../models/bin.dart';

class BinsListScreen extends StatefulWidget {
  final List<Bin> bins;
  const BinsListScreen({super.key, required this.bins});

  @override
  State<BinsListScreen> createState() => _BinsListScreenState();
}

class _BinsListScreenState extends State<BinsListScreen> {
  final Set<String> _selectedBins = {};
  bool _isSelectionMode = false;

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

  void _showBinDetails(Bin bin) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bin.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(bin.address),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${bin.fillLevel}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // تنفيذ عملية التعديل
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('تعديل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // تنفيذ عملية الحذف
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('حذف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.bins.length,
        itemBuilder: (context, index) {
          final bin = widget.bins[index];
          final isSelected = _selectedBins.contains(bin.id);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: isSelected ? 5 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: isSelected
                  ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                  : BorderSide.none,
            ),
            child: InkWell(
              onTap: () => _isSelectionMode
                  ? _toggleSelection(bin.id)
                  : _showBinDetails(bin),
              onLongPress: () => _toggleSelection(bin.id),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: bin.fillLevel > 80
                        ? [Colors.red[100]!, Colors.white]
                        : bin.fillLevel > 50
                            ? [Colors.orange[100]!, Colors.white]
                            : [Colors.green[100]!, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: bin.fillLevel > 80
                              ? Colors.red
                              : bin.fillLevel > 50
                                  ? Colors.orange
                                  : Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_rounded,
                            color: Colors.white),
                      ),
                      title: Text(
                        bin.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(bin.address),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: bin.fillLevel / 100,
                                  minHeight: 20,
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
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '${bin.fillLevel}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_isSelectionMode)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: isSelected ? Colors.white : Colors.grey[500],
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: () {
                // تنفيذ عملية على العناصر المحددة
                setState(() {
                  _selectedBins.clear();
                  _isSelectionMode = false;
                });
              },
              icon: const Icon(Icons.delete),
              label: Text('حذف (${_selectedBins.length})'),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }
}
