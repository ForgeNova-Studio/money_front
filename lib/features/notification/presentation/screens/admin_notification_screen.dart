import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/notification/presentation/providers/notification_providers.dart';

/// 관리자 공지 작성 화면
class AdminNotificationScreen extends ConsumerStatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  ConsumerState<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState
    extends ConsumerState<AdminNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _targetUserController = TextEditingController();

  String _selectedType = 'NOTICE';
  bool _isLoading = false;
  bool _isFabExpanded = false;

  final List<Map<String, dynamic>> _notificationTypes = [
    {
      'value': 'NOTICE',
      'label': '공지',
      'icon': Icons.campaign_rounded,
      'color': Colors.orange
    },
    {
      'value': 'UPDATE',
      'label': '업데이트',
      'icon': Icons.system_update_rounded,
      'color': Colors.green
    },
    {
      'value': 'EVENT',
      'label': '이벤트',
      'icon': Icons.celebration_rounded,
      'color': Colors.purple
    },
    {
      'value': 'PERSONAL',
      'label': '개인',
      'icon': Icons.person_rounded,
      'color': Colors.blue
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _targetUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return DefaultLayout(
      title: '공지 작성',
      titleSpacing: 16,
      backgroundColor: appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      floatingActionButton: _buildExpandableFab(context, appColors),
      child: GestureDetector(
        onTap: () {
          // FAB 외부 탭 시 닫기
          if (_isFabExpanded) {
            setState(() => _isFabExpanded = false);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 관리자 배지
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.admin_panel_settings,
                          size: 16, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        '관리자 전용',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 알림 타입 선택
                Text(
                  '알림 유형',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _notificationTypes.map((type) {
                    final isSelected = _selectedType == type['value'];
                    final color = type['color'] as Color;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedType = type['value']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withValues(alpha: 0.15)
                              : appColors.backgroundGray,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? color : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              type['icon'] as IconData,
                              size: 18,
                              color:
                                  isSelected ? color : appColors.textTertiary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              type['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? color
                                    : appColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 제목 입력
                Text(
                  '제목',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: '알림 제목을 입력하세요',
                    filled: true,
                    fillColor: appColors.backgroundGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '제목을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 내용 입력
                Text(
                  '내용',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '알림 내용을 입력하세요',
                    filled: true,
                    fillColor: appColors.backgroundGray,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '내용을 입력해주세요';
                    }
                    return null;
                  },
                ),

                // 안내 문구
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    '우측 하단 버튼을 눌러 전송 대상을 선택하세요',
                    style: TextStyle(
                      fontSize: 13,
                      color: appColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 확장 가능한 FAB
  Widget _buildExpandableFab(BuildContext context, AppThemeColors appColors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 확장 메뉴 옵션들
        if (_isFabExpanded) ...[
          // 특정 사용자 전송
          _FabMenuItem(
            label: '특정 사용자',
            icon: Icons.person_rounded,
            color: Colors.blue,
            onTap: _isLoading
                ? null
                : () => _showTargetUserDialog(context, appColors),
          ),
          const SizedBox(height: 12),
          // 전체 사용자 전송
          _FabMenuItem(
            label: '전체 사용자',
            icon: Icons.groups_rounded,
            color: Colors.green,
            onTap: _isLoading ? null : () => _sendToAll(),
          ),
          const SizedBox(height: 16),
        ],

        // 메인 FAB
        FloatingActionButton(
          onPressed: _isLoading
              ? null
              : () => setState(() => _isFabExpanded = !_isFabExpanded),
          backgroundColor: _isLoading ? appColors.gray300 : appColors.primary,
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : AnimatedRotation(
                  turns: _isFabExpanded ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.send_rounded, color: Colors.white),
                ),
        ),
      ],
    );
  }

  /// 특정 사용자 선택 다이얼로그
  void _showTargetUserDialog(BuildContext context, AppThemeColors appColors) {
    setState(() => _isFabExpanded = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('특정 사용자에게 전송'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '전송할 사용자의 ID 또는 이메일을 입력하세요',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetUserController,
              decoration: InputDecoration(
                hintText: '사용자 ID 또는 이메일',
                filled: true,
                fillColor: appColors.backgroundGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendToUser(_targetUserController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('전송'),
          ),
        ],
      ),
    );
  }

  /// 전체 사용자에게 전송
  Future<void> _sendToAll() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isFabExpanded = false;
      _isLoading = true;
    });

    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.sendNotificationToAll(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        type: _selectedType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('전체 사용자에게 공지가 전송되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('전송 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 특정 사용자에게 전송
  Future<void> _sendToUser(String targetUserId) async {
    if (!_formKey.currentState!.validate()) return;
    if (targetUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사용자 ID를 입력해주세요'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.createNotification(
        targetUserId: targetUserId,
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        type: _selectedType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$targetUserId 님에게 알림이 전송되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        _targetUserController.clear();
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('전송 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// FAB 메뉴 아이템
class _FabMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _FabMenuItem({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}
