import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/bin.dart';
import 'screens/welcome_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/bins_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'سلة+',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(36.1671, 1.3337);
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;

  final List<Bin> bins = [
    Bin(
      id: '1',
      name: 'سلة الشارع الرئيسي',
      latitude: 36.1671,
      longitude: 1.3337,
      fillLevel: 75,
      address: 'الشارع الرئيسي، الشلف',
    ),
    Bin(
      id: '2',
      name: 'سلة السوق المركزي',
      latitude: 36.1700,
      longitude: 1.3400,
      fillLevel: 45,
      address: 'السوق المركزي، الشلف',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      setState(() => _isLoading = true);
      // محاكاة تحميل البيانات
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء تحميل الخريطة';
        _isLoading = false;
      });
    }
  }

  BitmapDescriptor _getBinIcon(int fillLevel) {
    if (fillLevel >= 80) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    } else if (fillLevel >= 50) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  Set<Marker> _createMarkers() {
    return bins.map((bin) {
      return Marker(
        markerId: MarkerId(bin.id),
        position: LatLng(bin.latitude, bin.longitude),
        icon: _getBinIcon(bin.fillLevel),
        infoWindow: InfoWindow(
          title: bin.name,
          snippet: 'نسبة الامتلاء: ${bin.fillLevel}%',
        ),
        onTap: () => _showBinDetails(bin),
      );
    }).toSet();
  }

  void _showBinDetails(Bin bin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bin.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العنوان: ${bin.address}'),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: bin.fillLevel / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                bin.fillLevel > 80
                    ? Colors.red
                    : bin.fillLevel > 50
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'نسبة الامتلاء: ${bin.fillLevel}%',
              style: TextStyle(
                color: bin.fillLevel > 80
                    ? Colors.red
                    : bin.fillLevel > 50
                        ? Colors.orange
                        : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _buildMapScreen(),
                    BinsListScreen(bins: bins),
                    const NotificationsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'الخريطة',
            ),
            NavigationDestination(
              icon: Icon(Icons.delete_outline_rounded),
              selectedIcon: Icon(Icons.delete_rounded),
              label: 'السلات',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'الإشعارات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Hero(
              tag: 'appLogo',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.delete_rounded, color: Colors.green),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'سلة+',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: _initializeMap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('سلة+')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeMap,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapScreen() {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (controller) {
            mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          markers: _createMarkers(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
