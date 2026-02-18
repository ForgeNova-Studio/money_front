import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/notification/presentation/viewmodels/admin_notification_view_model.dart';
import 'package:moamoa/features/notification/presentation/widgets/admin_notification/admin_notification_action_fab.dart';
import 'package:moamoa/features/notification/presentation/widgets/admin_notification/admin_notification_form_fields.dart';
import 'package:moamoa/features/notification/presentation/widgets/admin_notification/admin_notification_type_selector.dart';
import 'package:moamoa/features/notification/presentation/widgets/admin_notification/admin_only_badge.dart';
import 'package:moamoa/features/notification/presentation/widgets/admin_notification/admin_target_email_dialog.dart';

/// 관리자 공지 작성 화면
///
/// 관리자가 새로운 공지사항이나 알림을 작성하고 발송하는 화면입니다.
///
/// ## 주요 기능
/// - 알림 제목, 내용 입력 및 유효성 검사
/// - 알림 유형 선택 (공지, 이벤트 등)
/// - 전체 사용자 공지 발송
/// - 특정 사용자(이메일) 개별 발송
/// - FAB 메뉴를 통한 발송 옵션 선택
class AdminNotificationScreen extends ConsumerStatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  ConsumerState<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

/// AdminNotificationScreen 상태 클래스
///
/// 폼 상태(Key), 텍스트 컨트롤러를 관리하고 ViewModel과 상호작용합니다.
class _AdminNotificationScreenState
    extends ConsumerState<AdminNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _targetEmailController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _targetEmailController.dispose();
    super.dispose();
  }

  Future<void> _submit({String? targetEmail}) async {
    if (!_formKey.currentState!.validate()) return;

    final result =
        await ref.read(adminNotificationViewModelProvider.notifier).submit(
              title: _titleController.text,
              message: _messageController.text,
              targetEmail: targetEmail,
            );

    if (!mounted) return;

    context.showToast(result.message);
    if (!result.isSuccess) return;

    if (targetEmail != null) {
      _targetEmailController.clear();
    }
    context.pop();
  }

  Future<void> _sendToSpecificUser(AppThemeColors appColors) async {
    final viewModel = ref.read(adminNotificationViewModelProvider.notifier);
    viewModel.collapseFab();

    final targetEmail = await showAdminTargetEmailDialog(
      context: context,
      appColors: appColors,
      emailController: _targetEmailController,
    );

    if (!mounted || targetEmail == null) return;
    await _submit(targetEmail: targetEmail);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final state = ref.watch(adminNotificationViewModelProvider);
    final viewModel = ref.read(adminNotificationViewModelProvider.notifier);

    return DefaultLayout(
      title: '공지 작성',
      titleSpacing: 16,
      backgroundColor: appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => context.pop(),
      ),
      floatingActionButton: AdminNotificationActionFab(
        appColors: appColors,
        isExpanded: state.isFabExpanded,
        isLoading: state.isSubmitting,
        onToggle: viewModel.toggleFab,
        onSendToSpecificUser: () => _sendToSpecificUser(appColors),
        onSendToAllUsers: _submit,
      ),
      child: GestureDetector(
        onTap: viewModel.collapseFab,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminOnlyBadge(),
                const SizedBox(height: 24),
                AdminNotificationTypeSelector(
                  appColors: appColors,
                  selectedType: state.selectedType,
                  onChanged: viewModel.selectType,
                ),
                const SizedBox(height: 24),
                AdminNotificationFormFields(
                  appColors: appColors,
                  titleController: _titleController,
                  messageController: _messageController,
                  titleValidator: viewModel.validateTitle,
                  messageValidator: viewModel.validateMessage,
                  titleMaxLength: AdminNotificationViewModel.titleMaxLength,
                  messageMaxLength: AdminNotificationViewModel.messageMaxLength,
                ),
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
}
