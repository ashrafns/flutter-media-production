import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ProductionCompanyApp());
}

class ProductionCompanyApp extends StatelessWidget {
  const ProductionCompanyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شركة الإنتاج الفني',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Arial',
        brightness: Brightness.light,
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

// شاشة البداية
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.purple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 120, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'شركة الإبداع',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'للإنتاج الفني والتصوير',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;
  late AnimationController _fabController;
  late AnimationController _pageController;
  late AnimationController _navBarController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Widget> _pages = const [
    HomePage(),
    ServicesPage(),
    GalleryPage(),
    ContactPage(),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _navBarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _updateAnimations();
    _pageController.forward();
  }

  void _updateAnimations() {
    final direction = _currentIndex > _previousIndex ? 1.0 : -1.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset(direction, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _pageController.dispose();
    _navBarController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) return;
    
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
    
    _pageController.reset();
    _navBarController.forward(from: 0);
    _updateAnimations();
    _pageController.forward();
    
    if (index == 3) {
      _fabController.reverse();
    } else {
      _fabController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: _currentIndex == 3
          ? null
          : ScaleTransition(
              scale: _fabController,
              child: FloatingActionButton.extended(
                onPressed: () => _onPageChanged(3),
                icon: const Icon(Icons.contact_support),
                label: const Text('اتصل بنا'),
                backgroundColor: Colors.amber,
                heroTag: 'contactFab',
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedNavBarWidget(
        icons: const [Icons.home_outlined, Icons.work_outline, Icons.photo_library_outlined, Icons.contact_mail_outlined],
        selectedIcons: const [Icons.home, Icons.work, Icons.photo_library, Icons.contact_mail],
        labels: const ['الرئيسية', 'الخدمات', 'الأعمال', 'اتصل بنا'],
        backgroundColor: Colors.deepPurple.shade900,
        iconColor: Colors.grey.shade400,
        selectedIconColor: Colors.amber,
        iconSize: 24.0,
        selectedIndex: _currentIndex,
        animationController: _navBarController,
        onIconTap: [
          () => _onPageChanged(0),
          () => _onPageChanged(1),
          () => _onPageChanged(2),
          () => _onPageChanged(3),
        ],
      ),
    );
  }
}

// الصفحة الرئيسية مع تحسينات
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _heroController;
  final List<String> _statistics = ['500+', '15+', '98%', '24/7'];
  final List<String> _statLabels = ['مشروع منجز', 'سنة خبرة', 'رضا العملاء', 'دعم فني'];
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;
  double _scrollProgress = 0.0;
  final List<String> _promoImages = ['عرض 1', 'عرض 2', 'عرض 3'];
  int _currentPromoIndex = 0;
  Timer? _promoTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      setState(() {
        _scrollProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
        _showBackToTop = currentScroll > 300;
      });
    });

    _startPromoTimer();
  }

  void _startPromoTimer() {
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentPromoIndex = (_currentPromoIndex + 1) % _promoImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    _promoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شركة الإبداع للإنتاج الفني'),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _scrollProgress,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade600),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'بحث',
          ),
          Badge(
            label: const Text('3'),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _showNotifications(context),
              tooltip: 'الإشعارات',
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showSettings(context);
                  break;
                case 'share':
                  _shareApp(context);
                  break;
                case 'favorites':
                  _showFavorites(context);
                  break;
                case 'about':
                  _showAboutDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'favorites',
                child: Row(
                  children: [
                    Icon(Icons.favorite, size: 20),
                    SizedBox(width: 12),
                    Text('المفضلة'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 12),
                    Text('الإعدادات'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 12),
                    Text('مشاركة التطبيق'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info, size: 20),
                    SizedBox(width: 12),
                    Text('عن التطبيق'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: Colors.deepPurple,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeroSection(),
                  _buildPromoSection(),
                  _buildStatisticsSection(),
                  const SizedBox(height: 20),
                  _buildQuickActionsSection(),
                  _buildServicesSection(),
                  _buildTestimonialsSection(),
                  _buildPartnersSection(),
                  _buildCallToActionSection(),
                  _buildFooterSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          if (_showBackToTop)
            Positioned(
              bottom: 80,
              left: 20,
              child: FloatingActionButton.small(
                heroTag: 'backToTop',
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.arrow_upward),
                tooltip: 'العودة للأعلى',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(16),
      child: PageView.builder(
        itemCount: _promoImages.length,
        controller: PageController(initialPage: _currentPromoIndex),
        onPageChanged: (index) {
          setState(() => _currentPromoIndex = index);
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض خاص ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'خصم يصل إلى 30%',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServiceDetailPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('تفاصيل'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              Icons.calendar_today,
              'حجز موعد',
              Colors.blue,
              () => _showBookingDialog(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              Icons.chat_bubble_outline,
              'دردشة مباشرة',
              Colors.green,
              () => _showChatDialog(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              Icons.calculate_outlined,
              'احسب السعر',
              Colors.orange,
              () => _showPriceCalculator(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartnersSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'شركاؤنا',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      'شريك ${index + 1}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.blue),
                onPressed: () {},
                iconSize: 32,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.purple),
                onPressed: () {},
                iconSize: 32,
              ),
              IconButton(
                icon: Icon(Icons.telegram, color: Colors.blue.shade700),
                onPressed: () {},
                iconSize: 32,
              ),
              IconButton(
                icon: Icon(Icons.phone, color: Colors.green.shade700),
                onPressed: () {},
                iconSize: 32,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 شركة الإبداع للإنتاج الفني. جميع الحقوق محفوظة.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('سياسة الخصوصية', style: TextStyle(fontSize: 12)),
              ),
              const Text('|'),
              TextButton(
                onPressed: () {},
                child: const Text('الشروط والأحكام', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFavorites(BuildContext context) {
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
            const Text(
              'المفضلة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.star),
                    ),
                    title: Text('خدمة مفضلة ${index + 1}'),
                    subtitle: const Text('تم الحفظ منذ يومين'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
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

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('حجز موعد'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'رقم الجوال',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('اختر التاريخ'),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حجز الموعد بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade700,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.support_agent, color: Colors.deepPurple),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دعم العملاء',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'متصل الآن',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildChatBubble('مرحباً! كيف يمكنني مساعدتك؟', true),
                    _buildChatBubble('أريد الاستفسار عن خدماتكم', false),
                    _buildChatBubble('بالتأكيد! نحن نقدم خدمات تصوير احترافية', true),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatBubble(String message, bool isBot) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey.shade200 : Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message),
      ),
    );
  }

  void _showPriceCalculator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.calculate, color: Colors.orange),
            SizedBox(width: 8),
            Text('حاسبة الأسعار'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'نوع الخدمة',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'conference', child: Text('تصوير مؤتمرات')),
                DropdownMenuItem(value: 'product', child: Text('تصوير منتجات')),
                DropdownMenuItem(value: 'video', child: Text('إنتاج فيديو')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'عدد الساعات',
                border: OutlineInputBorder(),
                suffixText: 'ساعة',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('التكلفة التقريبية:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('2,500 ريال', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('طلب عرض سعر مخصص'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.purple.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_animController.value),
                );
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: Curves.bounceOut,
                  )),
                  child: const Icon(Icons.camera_alt, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _heroController,
                  child: const Text(
                    'نحول أفكارك إلى واقع مرئي',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                  )),
                  child: const Text(
                    'احترافية • إبداع • جودة عالية',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _heroController,
                      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServiceDetailPage()),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('ابدأ مشروعك الآن'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.deepPurple.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 1000 + (index * 200)),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Column(
                  children: [
                    Text(
                      _statistics[index],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        shadows: [Shadow(color: Colors.amber.withOpacity(value), blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(_statLabels[index], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'خدماتنا المميزة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                label: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAnimatedServiceCard(Icons.videocam, 'تصوير المؤتمرات', 'تغطية احترافية لجميع المؤتمرات والفعاليات', 0),
          _buildAnimatedServiceCard(Icons.inventory, 'تصوير المنتجات', 'تصوير احترافي للمنتجات بجودة عالية', 100),
          _buildAnimatedServiceCard(Icons.edit, 'المونتاج والإخراج', 'مونتاج وإخراج فني عالي الجودة', 200),
          _buildAnimatedServiceCard(Icons.movie_creation, 'إنتاج الأفلام', 'إنتاج أفلام وثائقية وإعلانية', 300),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          const Text(
            'آراء عملائنا',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: 3,
              controller: PageController(viewportFraction: 0.85),
              itemBuilder: (context, index) {
                final testimonials = [
                  {'name': 'أحمد المالكي', 'comment': 'خدمة ممتازة واحترافية عالية'},
                  {'name': 'فاطمة السعيد', 'comment': 'تجربة رائعة وجودة مذهلة'},
                  {'name': 'محمد العتيبي', 'comment': 'أفضل شركة إنتاج تعاملت معها'},
                ];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildTestimonial(
                    testimonials[index]['name']!,
                    testimonials[index]['comment']!,
                    5,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade400, Colors.purple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.stars, size: 50, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'هل أنت مستعد لبدء مشروعك؟',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'احصل على استشارة مجانية الآن',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServiceDetailPage()),
              );
            },
            icon: const Icon(Icons.phone),
            label: const Text('اتصل بنا الآن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث البيانات بنجاح'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showNotifications(BuildContext context) {
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
            const Text(
              'الإشعارات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.local_offer, color: Colors.white),
              ),
              title: const Text('عرض خاص'),
              subtitle: const Text('احصل على خصم 20% على الباقة الذهبية'),
              trailing: const Text('الآن'),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.check_circle, color: Colors.white),
              ),
              title: const Text('تم إنجاز المشروع'),
              subtitle: const Text('مشروع التصوير الفوتوغرافي تم بنجاح'),
              trailing: const Text('منذ ساعة'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإعدادات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('الوضع الليلي'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('الإشعارات'),
              value: true,
              onChanged: (value) {},
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

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('مشاركة التطبيق...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'شركة الإبداع للإنتاج الفني',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.camera_alt, size: 50),
      children: [
        const Text('تطبيق متخصص في خدمات الإنتاج الفني والتصوير الاحترافي'),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن خدمة...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('بحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedServiceCard(IconData icon, String title, String description, int delay) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(100 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: child,
            ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServiceDetailPage()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.deepPurple, size: 32),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(description),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonial(String name, String comment, int rating) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(rating, (_) => const Icon(Icons.star, color: Colors.amber, size: 20)),
            ),
            const SizedBox(height: 12),
            Text('"$comment"', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// صفحة تفاصيل الخدمة
class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({super.key});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> with TickerProviderStateMixin {
  late AnimationController _animController;
  late TabController _tabController;
  int _selectedPackage = 0;
  bool _isFavorite = false;
  final double _rating = 4.5;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _animController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الخدمة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            color: _isFavorite ? Colors.red : null,
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorite ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'إضافة للمفضلة',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _showShareOptions(context);
            },
            tooltip: 'مشاركة',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'نظرة عامة'),
            Tab(text: 'الباقات'),
            Tab(text: 'التقييمات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPackagesTab(),
          _buildReviewsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'السعر يبدأ من',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '1500 ريال',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showBookingDialog(context),
                  icon: const Icon(Icons.book_online),
                  label: const Text('احجز الآن'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section
          FadeTransition(
            opacity: _animController,
            child: Hero(
              tag: 'service_hero',
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade700, Colors.purple.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam, size: 80, color: Colors.white),
                      const SizedBox(height: 16),
                      const Text(
                        'تصوير المؤتمرات والفعاليات',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, size: 18, color: Colors.black),
                            SizedBox(width: 4),
                            Text(
                              'احترافية وجودة عالية',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'وصف الخدمة',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'نقدم خدمات تصوير احترافية للمؤتمرات والفعاليات بأعلى جودة ممكنة. فريقنا المحترف يضمن توثيق كل لحظة مهمة في فعاليتك بأحدث المعدات والتقنيات.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                ),
                const SizedBox(height: 24),

                const Text(
                  'المميزات',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(Icons.high_quality, 'جودة تصوير 4K'),
                _buildFeatureItem(Icons.people, 'فريق محترف ومتخصص'),
                _buildFeatureItem(Icons.camera_alt, 'أحدث المعدات والتقنيات'),
                _buildFeatureItem(Icons.edit, 'مونتاج وإخراج احترافي'),
                _buildFeatureItem(Icons.access_time, 'تسليم سريع في الوقت المحدد'),
                _buildFeatureItem(Icons.support_agent, 'دعم فني متواصل'),
                
                const SizedBox(height: 24),

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              _rating.toString(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < _rating.floor() ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                            ),
                            const Text('من 150 تقييم'),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(5, 80),
                              _buildRatingBar(4, 15),
                              _buildRatingBar(3, 3),
                              _buildRatingBar(2, 1),
                              _buildRatingBar(1, 1),
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
        ],
      ),
    );
  }

  Widget _buildPackagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPackageCard(
            0,
            'الباقة الأساسية',
            '1500 ريال',
            [
              'تصوير 4 ساعات',
              'مصور واحد',
              'تسليم خام',
              'دعم فني',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 12),
          
          _buildPackageCard(
            1,
            'الباقة الفضية',
            '3000 ريال',
            [
              'تصوير 8 ساعات',
              'مصورين اثنين',
              'مونتاج احترافي',
              'تسليم سريع',
              'دعم فني مميز',
            ],
            Colors.grey,
          ),
          const SizedBox(height: 12),
          
          _buildPackageCard(
            2,
            'الباقة الذهبية',
            '5000 ريال',
            [
              'تصوير يوم كامل',
              'فريق كامل',
              'مونتاج وإخراج متقدم',
              'بث مباشر',
              'تسليم فوري',
              'دعم VIP',
            ],
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('عميل ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < 4 ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('منذ ${index + 1} أيام', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('خدمة ممتازة وفريق محترف جداً. أنصح بالتعامل معهم.'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBar(int stars, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars'),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          const SizedBox(width: 8),
          Text('$percentage%', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
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
            const Text(
              'مشاركة عبر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.message, 'رسالة', Colors.green),
                _buildShareOption(Icons.facebook, 'فيسبوك', Colors.blue),
                _buildShareOption(Icons.send, 'تليجرام', Colors.blue.shade700),
                _buildShareOption(Icons.link, 'نسخ الرابط', Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('مشاركة عبر $label')),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.deepPurple, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    int index,
    String title,
    String price,
    List<String> features,
    Color color,
  ) {
    bool isSelected = _selectedPackage == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: isSelected ? color : Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حجز الخدمة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'رقم الجوال',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'تاريخ الفعالية',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال طلب الحجز بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال الطلب'),
          ),
        ],
      ),
    );
  }
}

// صفحة الخدمات مع تحسينات
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خدماتنا'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildAnimatedServiceItem(Icons.event, 'تصوير المؤتمرات', Colors.blue, 0),
          _buildAnimatedServiceItem(Icons.shopping_bag, 'تصوير المنتجات', Colors.green, 100),
          _buildAnimatedServiceItem(Icons.camera, 'التصوير الفوتوغرافي', Colors.orange, 200),
          _buildAnimatedServiceItem(Icons.video_library, 'إنتاج الفيديو', Colors.red, 300),
          _buildAnimatedServiceItem(Icons.music_note, 'الإنتاج الصوتي', Colors.purple, 400),
          _buildAnimatedServiceItem(Icons.brush, 'التصميم الجرافيكي', Colors.teal, 500),
        ],
      ),
    );
  }

  Widget _buildAnimatedServiceItem(IconData icon, String title, Color color, int delay) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 60, color: color),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// صفحة معرض الأعمال
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معرض أعمالنا'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProjectCard('مؤتمر التكنولوجيا 2024', 'تغطية كاملة للمؤتمر', Icons.computer),
          _buildProjectCard('حملة إعلانية لمنتج جديد', 'إنتاج فيديو إعلاني', Icons.camera_roll),
          _buildProjectCard('تصوير منتجات الأزياء', 'جلسة تصوير احترافية', Icons.checkroom),
          _buildProjectCard('فيلم وثائقي', 'إنتاج فيلم وثائقي قصير', Icons.movie),
          _buildProjectCard('تغطية حفل زفاف', 'تصوير وإخراج احترافي', Icons.favorite),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 40, color: Colors.deepPurple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// صفحة التواصل
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتصل بنا'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.business, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'شركة الإبداع للإنتاج الفني',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildContactItem(Icons.phone, 'الهاتف', '+966 50 123 4567'),
            _buildContactItem(Icons.email, 'البريد الإلكتروني', 'info@creativepro.com'),
            _buildContactItem(Icons.location_on, 'العنوان', 'الرياض، المملكة العربية السعودية'),
            _buildContactItem(Icons.language, 'الموقع الإلكتروني', 'www.creativepro.com'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text('إرسال رسالة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}

// NavBar Widget
class NavBarWidget extends StatelessWidget {
  final List<IconData> icons;
  final List<String>? labels;
  final Color backgroundColor;
  final Color iconColor;
  final Color selectedIconColor;
  final List<VoidCallback>? onIconTap;
  final double iconSize;
  final int selectedIndex;

  const NavBarWidget({
    super.key,
    required this.icons,
    this.labels,
    required this.backgroundColor,
    required this.iconColor,
    required this.selectedIconColor,
    this.onIconTap,
    this.iconSize = 24.0,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: labels != null ? 80 : 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        minimum: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: icons.asMap().entries.map((entry) {
            int index = entry.key;
            IconData icon = entry.value;
            bool isSelected = selectedIndex == index;
            
            return Expanded(
              child: InkWell(
                onTap: onIconTap != null && index < onIconTap!.length
                    ? onIconTap![index]
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? selectedIconColor : iconColor,
                        size: isSelected ? iconSize + 2 : iconSize,
                      ),
                      if (labels != null) ...[
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            labels![index],
                            style: TextStyle(
                              color: isSelected ? selectedIconColor : iconColor,
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Wave Painter للخلفية المتحركة
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.7 + 30 * math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)),
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

// NavBar Widget المحسّن مع رسوم متحركة
class AnimatedNavBarWidget extends StatefulWidget {
  final List<IconData> icons;
  final List<IconData> selectedIcons;
  final List<String>? labels;
  final Color backgroundColor;
  final Color iconColor;
  final Color selectedIconColor;
  final List<VoidCallback>? onIconTap;
  final double iconSize;
  final int selectedIndex;
  final AnimationController animationController;

  const AnimatedNavBarWidget({
    super.key,
    required this.icons,
    required this.selectedIcons,
    this.labels,
    required this.backgroundColor,
    required this.iconColor,
    required this.selectedIconColor,
    this.onIconTap,
    this.iconSize = 24.0,
    this.selectedIndex = 0,
    required this.animationController,
  });

  @override
  State<AnimatedNavBarWidget> createState() => _AnimatedNavBarWidgetState();
}

class _AnimatedNavBarWidgetState extends State<AnimatedNavBarWidget> with TickerProviderStateMixin {
  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _iconControllers = List.generate(
      widget.icons.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _iconControllers[widget.selectedIndex].forward();
  }

  @override
  void didUpdateWidget(AnimatedNavBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _iconControllers[oldWidget.selectedIndex].reverse();
      _iconControllers[widget.selectedIndex].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.labels != null ? 65 : 60,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: SafeArea(
          minimum: EdgeInsets.zero,
          top: false,
          child: Stack(
            children: [
              // مؤشر الخلفية المتحرك
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: (MediaQuery.of(context).size.width / widget.icons.length) * widget.selectedIndex,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / widget.icons.length,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.selectedIconColor.withOpacity(0.2),
                        widget.selectedIconColor.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // الأيقونات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.icons.asMap().entries.map((entry) {
                  int index = entry.key;
                  IconData icon = entry.value;
                  IconData selectedIcon = widget.selectedIcons[index];
                  bool isSelected = widget.selectedIndex == index;
                  
                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onIconTap != null && index < widget.onIconTap!.length
                            ? widget.onIconTap![index]
                            : null,
                        splashColor: widget.selectedIconColor.withOpacity(0.3),
                        highlightColor: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // الأيقونة مع التأثيرات
                              SizedBox(
                                height: 28,
                                child: AnimatedBuilder(
                                  animation: _iconControllers[index],
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _scaleAnimations[index].value,
                                      child: TweenAnimationBuilder<double>(
                                        duration: const Duration(milliseconds: 250),
                                        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
                                        builder: (context, value, child) {
                                          return Icon(
                                            isSelected ? selectedIcon : icon,
                                            color: Color.lerp(
                                              widget.iconColor,
                                              widget.selectedIconColor,
                                              value,
                                            ),
                                            size: 21,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // النص
                              if (widget.labels != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 250),
                                    style: TextStyle(
                                      color: isSelected ? widget.selectedIconColor : widget.iconColor,
                                      fontSize: 8.5,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      height: 1.0,
                                    ),
                                    child: Text(
                                      widget.labels![index],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// إضافة انتقالات مخصصة للصفحات
class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;

  CustomPageRoute({required this.page, this.direction = AxisDirection.right})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Offset begin;
            switch (direction) {
              case AxisDirection.up:
                begin = const Offset(0.0, 1.0);
                break;
              case AxisDirection.down:
                begin = const Offset(0.0, -1.0);
                break;
              case AxisDirection.left:
                begin = const Offset(-1.0, 0.0);
                break;
              case AxisDirection.right:
                begin = const Offset(1.0, 0.0);
                break;
            }
            
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            
            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeIn),
            );

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}