import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:moamoa/core/validators/input_validator.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/router/route_names.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _nicknameController = TextEditingController();
  String _initialNickname = '';
  String? _nicknameError;
  bool _hasEditedNickname = false;

  @override
  void initState() {
    super.initState();
    final nickname = ref.read(authViewModelProvider).user?.nickname ?? '';
    _syncNickname(nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _syncNickname(String nickname) {
    _nicknameController.value = TextEditingValue(
      text: nickname,
      selection: TextSelection.collapsed(offset: nickname.length),
    );
    _initialNickname = nickname;
    _hasEditedNickname = false;
  }

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    final nickname = _nicknameController.text.trim();
    final nicknameError = InputValidator.getNicknameErrorMessage(nickname);

    setState(() {
      _nicknameError = nicknameError.isEmpty ? null : nicknameError;
    });

    if (nicknameError.isNotEmpty) {
      return;
    }

    if (nickname == _initialNickname) {
      context.pop();
      return;
    }

    try {
      await ref.read(authViewModelProvider.notifier).updateNickname(nickname);

      if (!mounted) return;

      context.showToast('닉네임이 변경되었습니다.');
      context.go(RouteNames.settings);
    } catch (e) {
      if (!mounted) return;
      context.showErrorToast(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      final nextNickname = next.user?.nickname;
      final previousNickname = previous?.user?.nickname;

      if (!_hasEditedNickname &&
          nextNickname != null &&
          nextNickname != previousNickname &&
          nextNickname != _nicknameController.text) {
        _syncNickname(nextNickname);
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultLayout(
        title: '프로필 수정',
        centerTitle: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '닉네임',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nicknameController,
                  enabled: !authState.isLoading,
                  maxLength: InputValidator.nicknameMaxLength,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState(() {
                      _hasEditedNickname = value.trim() != _initialNickname;
                      if (_nicknameError != null) {
                        _nicknameError = null;
                      }
                    });
                  },
                  onSubmitted: (_) => _handleSave(),
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력해주세요',
                    errorText: _nicknameError,
                    counterText: '',
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '2자 이상 10자 이하로 입력해주세요.',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: authState.isLoading ? null : _handleSave,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authState.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Text('저장'),
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
