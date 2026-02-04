import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/viewmodels/shortcuts_guide_view_model.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/widgets/step_intro.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/widgets/step_select_cards.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/widgets/step_install_shortcut.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/widgets/step_setup_automation.dart';

class ShortcutsGuideScreen extends ConsumerStatefulWidget {
  const ShortcutsGuideScreen({super.key});

  @override
  ConsumerState<ShortcutsGuideScreen> createState() =>
      _ShortcutsGuideScreenState();
}

class _ShortcutsGuideScreenState extends ConsumerState<ShortcutsGuideScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepChanged(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shortcutsGuideViewModelProvider);
    final viewModel = ref.read(shortcutsGuideViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    // Listen to step changes and sync PageView
    ref.listen<ShortcutsGuideState>(
      shortcutsGuideViewModelProvider,
      (previous, next) {
        if (previous?.currentStep != next.currentStep) {
          _onStepChanged(next.currentStep);
        }
      },
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => _showExitDialog(context),
        ),
        title: Text(
          '자동 가계부 설정',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _ProgressBar(
              currentStep: state.currentStep,
              totalSteps: state.totalSteps,
            ),

            // Step content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  viewModel.goToStep(index);
                },
                children: const [
                  StepIntro(),
                  StepSelectCards(),
                  StepInstallShortcut(),
                  StepSetupAutomation(),
                ],
              ),
            ),

            // Navigation buttons
            _NavigationButtons(
              state: state,
              onPrevious: () => viewModel.previousStep(),
              onNext: () {
                if (state.isLastStep) {
                  viewModel.completeSetup();
                  context.pop();
                } else {
                  viewModel.nextStep();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('설정 취소'),
        content: const Text('설정을 중단하시겠습니까?\n나중에 설정 > 자동 가계부에서 다시 설정할 수 있어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('계속 설정'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }
}

class _ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressBar({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              return Expanded(
                child: Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted || isCurrent
                              ? context.appColors.primary
                              : context.appColors.gray200,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? context.appColors.primary
                            : isCurrent
                                ? context.appColors.primary
                                : context.appColors.gray200,
                        border: isCurrent
                            ? Border.all(
                                color: context.appColors.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : context.appColors.textTertiary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? context.appColors.primary
                              : context.appColors.gray200,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          // Step labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepLabel(context, '소개', 0, currentStep),
              _stepLabel(context, '카드 선택', 1, currentStep),
              _stepLabel(context, '단축어 설치', 2, currentStep),
              _stepLabel(context, '자동화 설정', 3, currentStep),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepLabel(
      BuildContext context, String label, int step, int currentStep) {
    final isCurrent = step == currentStep;
    final isCompleted = step < currentStep;
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        color: isCompleted || isCurrent
            ? context.appColors.primary
            : context.appColors.textTertiary,
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final ShortcutsGuideState state;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _NavigationButtons({
    required this.state,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          if (!state.isFirstStep)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: context.appColors.gray300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '이전',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ),
            ),
          if (!state.isFirstStep) const SizedBox(width: 12),

          // Next button
          Expanded(
            flex: state.isFirstStep ? 1 : 2,
            child: ElevatedButton(
              onPressed: state.canProceedToNext ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: context.appColors.gray200,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                state.isLastStep ? '완료' : '다음',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
