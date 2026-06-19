import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // បង្កើតទិន្នន័យគំរូសម្រាប់ការណាត់ជួប (Mock Data)
  final List<Map<String, dynamic>> _pastAppointments = [
    {
      'title': 'Consultation with Dr. Alex',
      'date': 'June 12, 2026',
      'time': '10:00 AM',
      'icon': Icons.medical_services_outlined,
      'status': 'Completed',
      'statusColor': Colors.green,
    },
    {
      'title': 'Web Development Discussion',
      'date': 'May 28, 2026',
      'time': '02:30 PM',
      'icon': Icons.code_rounded,
      'status': 'Completed',
      'statusColor': Colors.green,
    },
    {
      'title': 'UX/UI Design Review',
      'date': 'May 15, 2026',
      'time': '09:00 AM',
      'status': 'Cancelled',
      'statusColor': Colors.red,
    },
  ];

  // ជំនួសមកវិញនូវបញ្ជី Upcoming បែបគំរូ (បច្ចុប្បន្នទុកឱ្យទទេដើម្បីបង្ហាញ Empty State)
  final List<Map<String, dynamic>> _upcomingAppointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Appointments', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ផ្នែកទី១: Upcoming Appointments
          _upcomingAppointments.isEmpty
              ? _buildEmptyState()
              : _buildAppointmentList(_upcomingAppointments, isDark),

          // ផ្នែកទី២: Past History
          _pastAppointments.isEmpty
              ? _buildEmptyState()
              : _buildAppointmentList(_pastAppointments, isDark),
        ],
      ),
    );
  }

  // Widget សម្រាប់បង្ហាញទម្រង់ទទេ (យកតាមឌីហ្សាញចាស់របស់អ្នក)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Scheduled Appointments',
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Widget សម្រាប់បង្កើត List បង្ហាញការណាត់ជួប
  Widget _buildAppointmentList(List<Map<String, dynamic>> items, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.02),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon តំណាងប្រភេទណាត់ជួប
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Icon(item['icon'] ?? Icons.event, color: Colors.deepPurple),
              ),
              const SizedBox(width: 14),
              
              // ព័ត៌មានលម្អិត
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          "${item['date']} • ${item['time']}",
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ស្ថានភាព Status (Completed / Cancelled)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: (item['statusColor'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    color: item['statusColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}