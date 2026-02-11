import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/router/route_names.dart';
import '../states/ocr_scan_state.dart';
import '../viewmodels/ocr_scan_view_model.dart';
import '../widgets/pending_receipt_list_item.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

/// OCR 영수증 스캔 화면
class OcrScanScreen extends ConsumerStatefulWidget {
  const OcrScanScreen({super.key});

  @override
  ConsumerState<OcrScanScreen> createState() => _OcrScanScreenState();
}

class _OcrScanScreenState extends ConsumerState<OcrScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickerOpen = false;

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 바로 갤러리 열기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImageFromGallery();
    });
  }

  Future<void> _pickImageFromGallery() async {
    if (_isPickerOpen) return;

    final state = ref.read(ocrScanViewModelProvider);
    if (state.isProcessing) return;

    _isPickerOpen = true;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final viewModel = ref.read(ocrScanViewModelProvider.notifier);
        await viewModel.processImage(File(image.path));
      } else {
        // 이미지 선택 취소 시 이전 화면으로 돌아가기
        if (mounted && !ref.read(ocrScanViewModelProvider).hasPendingReceipts) {
          context.pop();
        }
      }
    } finally {
      _isPickerOpen = false;
    }
  }

  void _handleBack() {
    // 뒤로 가기 시 상태 초기화
    ref.read(ocrScanViewModelProvider.notifier).reset();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ocrScanViewModelProvider);
    final viewModel = ref.read(ocrScanViewModelProvider.notifier);
    final numberFormat = NumberFormat('#,###');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        backgroundColor: context.appColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            '영수증 스캔',
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: context.appColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: context.appColors.textPrimary),
            onPressed: _handleBack,
          ),
          actions: [
            if (state.hasPendingReceipts)
              TextButton(
                onPressed: () => _showClearAllDialog(context, viewModel),
                child: Text(
                  '전체 삭제',
                  style: TextStyle(
                    color: context.appColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            // 메인 콘텐츠
            _buildMainContent(context, state, viewModel, numberFormat),

            // 처리 중 오버레이
            if (state.isProcessing) _buildProcessingOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    OcrScanState state,
    OcrScanViewModel viewModel,
    NumberFormat numberFormat,
  ) {
    if (!state.hasPendingReceipts && !state.isProcessing) {
      return _buildEmptyState(context, state);
    }

    return Column(
      children: [
        // 요약 헤더
        if (state.hasPendingReceipts)
          _buildSummaryHeader(
              context, state.count, state.totalAmount, numberFormat),

        // 에러 메시지
        if (state.hasError)
          _buildErrorMessage(context, state.error!, viewModel),

        // 대기 목록
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: state.pendingReceipts.length,
            itemBuilder: (context, index) {
              final receipt = state.pendingReceipts[index];
              return PendingReceiptListItem(
                receipt: receipt,
                onAmountChanged: (amount) {
                  viewModel.updatePendingReceipt(
                    id: receipt.id,
                    amount: amount,
                  );
                },
                onDateChanged: (date) {
                  viewModel.updatePendingReceipt(
                    id: receipt.id,
                    date: date,
                  );
                },
                onCategoryChanged: (category) {
                  viewModel.updatePendingReceipt(
                    id: receipt.id,
                    category: category,
                  );
                },
                onMemoChanged: (memo) {
                  viewModel.updatePendingReceipt(
                    id: receipt.id,
                    memo: memo,
                  );
                },
                onMerchantChanged: (merchant) {
                  viewModel.updatePendingReceipt(
                    id: receipt.id,
                    merchant: merchant,
                  );
                },
                onDelete: () {
                  viewModel.removePendingReceipt(receipt.id);
                },
              );
            },
          ),
        ),

        // 하단 버튼 영역
        if (state.hasPendingReceipts) _buildBottomButtons(context, ref, state),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, OcrScanState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.appColors.primaryPale,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 40,
                color: context.appColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              state.hasError ? '스캔 실패' : '영수증 스캔',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.hasError ? state.error! : '갤러리에서 영수증 사진을 선택하세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('갤러리에서 선택'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(
    BuildContext context,
    int count,
    int totalAmount,
    NumberFormat numberFormat,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: context.appColors.softGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '총 $count건',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textPrimary.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${numberFormat.format(totalAmount)}원',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: context.appColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '스캔 완료',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(
    BuildContext context,
    String error,
    OcrScanViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.appColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.appColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: context.appColors.error),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => viewModel.clearError(),
            color: context.appColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    WidgetRef ref,
    OcrScanState state,
  ) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 다른 영수증 추가 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: state.isSaving ? null : _pickImageFromGallery,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('다른 영수증 추가'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.appColors.primary,
                  side: BorderSide(color: context.appColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.isSaving
                    ? null
                    : () async {
                        final viewModel =
                            ref.read(ocrScanViewModelProvider.notifier);
                        final success =
                            await viewModel.saveAllPendingReceipts();

                        if (success && context.mounted) {
                          // 저장 후 홈 데이터 갱신
                          ref
                              .read(homeViewModelProvider.notifier)
                              .fetchMonthlyData(
                                DateTime.now(),
                                forceRefresh: true,
                              );

                          context.showToast('${state.count}건의 지출이 저장되었습니다');
                          context.go(RouteNames.home);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.isSaving
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        '모두 저장하기 (${state.count}건)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: context.appColors.primaryDark,
              ),
              const SizedBox(height: 12),
              Text(
                '영수증을 분석 중이에요',
                style: TextStyle(
                  color: context.appColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, OcrScanViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 삭제'),
        content: const Text('스캔한 모든 영수증을 삭제할까요?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              viewModel.reset();
              Navigator.pop(context);
            },
            child: Text(
              '삭제',
              style: TextStyle(color: context.appColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
