import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrecap/ui/constants/constants.dart';
import '../../../../data/repositories/local_storage_service.dart';
import '../../../../domain/entities/user.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String? userId;
  String? userFirstName;
  String? userLastName;
  String? userProfileImg;
  int _currentIndex = 1; // For bottom navigation, 1 represents "Minijuegos"

  // Added state variables
  String _currentTab = 'Creados';
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  // Sample data - replace with your actual data structure
  final Map<String, List<ActivityItem>> _activities = {
    'Creados': [
      ActivityItem('Quiz de Derecho Penal', 'quiz'),
      ActivityItem('Flashcard de Derecho Civil', 'flashcard'),
      ActivityItem('Gaps de Derecho Procesal', 'gaps'),
      ActivityItem('Quiz de Derecho Penal', 'quiz'),
    ],
    'Favoritos': [],
    'Historial': [],
  };

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    LocalStorageService localStorageService = LocalStorageService();
    User? user = await localStorageService.getCurrentUser();

    if (user != null) {
      setState(() {
        userId = user.id;
        userFirstName = user.firstName;
        userLastName = user.lastName;
        userProfileImg = user.profileImg;
      });
    } else {
      print('No se encontró el usuario.');
    }
  }

  List<ActivityItem> _getFilteredActivities() {
    List<ActivityItem> activities = _activities[_currentTab] ?? [];

    return activities.where((activity) {
      bool matchesSearch = activity.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = _selectedCategory == 'Todos' || activity.category == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        )
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: kPrimary,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mis actividades",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.logout,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    List<ActivityItem> filteredActivities = _getFilteredActivities();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        _buildTabs(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${filteredActivities.length} actividades'),
              DropdownButton<String>(
                value: _selectedCategory,
                items: ['Todos', 'Quiz', 'Flashcard', 'Gaps', 'Linker']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              final activity = filteredActivities[index];
              return ListTile(
                leading: Icon(Icons.play_circle_outline),
                title: Text(activity.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: ['Creados', 'Favoritos', 'Historial'].map((tab) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentTab = tab;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentTab == tab ? kPrimary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _currentTab == tab ? kPrimary : Colors.grey,
                    fontWeight: _currentTab == tab ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}

class ActivityItem {
  final String title;
  final String category;

  ActivityItem(this.title, this.category);
}