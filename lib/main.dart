import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'models/bin.dart';
import 'screens/welcome_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/bins_list_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/app_localizations.dart';
import 'screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLanguage = 'ar';

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations(_currentLanguage);

    return Directionality(
      textDirection:
          _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: MaterialApp(
        title: translations.translate('appName'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            scrolledUnderElevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        initialRoute: '/onboarding',
        routes: {
          '/onboarding': (context) =>
              OnboardingScreen(translations: translations),
          '/home': (context) => HomePage(
                translations: translations,
                currentLanguage: _currentLanguage,
                onLanguageChanged: _changeLanguage,
              ),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final AppLocalizations translations;
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const HomePage({
    super.key,
    required this.translations,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(36.1671, 1.3337);
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;

  // تحديث قائمة السلات لتكون متغيرة
  final List<Bin> bins = [
    Bin(
      id: '1',
      name: 'سلة الشارع الرئيسي',
      latitude: 36.1671,
      longitude: 1.3337,
      fillLevel: 75,
      address: 'الشارع الرئيسي، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '2',
      name: 'سلة السوق المركزي',
      latitude: 36.1700,
      longitude: 1.3400,
      fillLevel: 45,
      address: 'السوق المركزي، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '3',
      name: 'سلة محطة الحافلات',
      latitude: 36.1655,
      longitude: 1.3352,
      fillLevel: 60,
      address: 'محطة الحافلات، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '4',
      name: 'سلة حي بن سونة',
      latitude: 36.1603,
      longitude: 1.3281,
      fillLevel: 80,
      address: 'حي بن سونة، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '5',
      name: 'سلة الحي الإداري',
      latitude: 36.1689,
      longitude: 1.3427,
      fillLevel: 55,
      address: 'الحي الإداري، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '6',
      name: 'سلة مستشفى الشلف',
      latitude: 36.1638,
      longitude: 1.3384,
      fillLevel: 70,
      address: 'مستشفى الشلف، الشلف',
      type: 'طبية',
    ),
    Bin(
      id: '7',
      name: 'سلة جامعة حسيبة بن بوعلي',
      latitude: 36.1625,
      longitude: 1.3412,
      fillLevel: 40,
      address: 'جامعة حسيبة بن بوعلي، الشلف',
      type: 'إعادة التدوير',
    ),
    Bin(
      id: '8',
      name: 'سلة حي الحرية',
      latitude: 36.1584,
      longitude: 1.3265,
      fillLevel: 50,
      address: 'حي الحرية، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '9',
      name: 'سلة حديقة الحرية',
      latitude: 36.1667,
      longitude: 1.3369,
      fillLevel: 65,
      address: 'حديقة الحرية، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '10',
      name: 'سلة شارع الإخوة بلحاج',
      latitude: 36.1642,
      longitude: 1.3308,
      fillLevel: 30,
      address: 'شارع الإخوة بلحاج، الشلف',
      type: 'عادية',
    ),
    Bin(
      id: '11',
      name: 'سلة الميناء القديم',
      latitude: 36.1695,
      longitude: 1.3453,
      fillLevel: 90,
      address: 'الميناء القديم، الشلف',
      type: 'عالية السعة',
    ),
    Bin(
      id: '12',
      name: 'سلة حي الشرفة',
      latitude: 36.1570,
      longitude: 1.3240,
      fillLevel: 75,
      address: 'حي الشرفة، الشلف',
      type: 'عادية',
    ),
  ];

  void _addNewBin(Bin newBin) {
    setState(() {
      bins.add(newBin);
    });
  }

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
                    BinsListScreen(
                      bins: bins,
                      translations: widget.translations,
                    ),
                    NotificationsScreen(
                      translations: widget.translations,
                    ),
                    SettingsScreen(
                      currentLanguage: widget.currentLanguage,
                      onLanguageChanged: widget.onLanguageChanged,
                    ),
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
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map_rounded),
              label: widget.translations.translate('map'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.delete_outline_rounded),
              selectedIcon: const Icon(Icons.delete_rounded),
              label: widget.translations.translate('bins'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined),
              selectedIcon: const Icon(Icons.notifications_rounded),
              label: widget.translations.translate('notifications'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: widget.translations.translate('settings'),
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
