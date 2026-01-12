import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import '../viewmodels/ocr_view_model.dart';
import '../../domain/entities/receipt_data.dart';

/// OCR 테스트 화면
class OcrTestScreen extends ConsumerStatefulWidget {
  const OcrTestScreen({super.key});

  @override
  ConsumerState<OcrTestScreen> createState() => _OcrTestScreenState();
}

class _OcrTestScreenState extends ConsumerState<OcrTestScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final viewModel = ref.read(ocrViewModelProvider.notifier);
    final state = ref.read(ocrViewModelProvider);

    if (state.isLoading) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await viewModel.processImage(File(image.path));
    }
  }

  Future<void> _pickFromCamera() async {
    final viewModel = ref.read(ocrViewModelProvider.notifier);
    final state = ref.read(ocrViewModelProvider);

    if (state.isLoading) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await viewModel.processImage(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ocrViewModelProvider);
    final viewModel = ref.read(ocrViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: context.appColors.backgroundAccentTint,
      appBar: AppBar(
        title: const Text('영수증 스캔'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: context.appColors.textPrimary,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
        titleTextStyle: TextStyle(
          color: context.appColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              viewModel.reset();
              setState(() {
                _selectedImage = null;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(context),
          // [Layer 1] 메인 콘텐츠
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildHeader(context),
                ),
                const SizedBox(height: 16),

                // 1. 이미지 미리보기 (고정 높이)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildPreviewCard(context),
                ),

                // 2. 버튼 영역 (고정)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          label: '갤러리',
                          icon: Icons.photo_library,
                          isPrimary: false,
                          onTap: state.isLoading ? null : _pickImage,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          label: '카메라',
                          icon: Icons.camera_alt,
                          isPrimary: true,
                          onTap: state.isLoading ? null : _pickFromCamera,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. 에러 메시지 (고정)
                if (state.hasError)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                            state.error!,
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
                  ),

                // 4. 결과 리스트 (Expanded 적용: 남은 공간 전부 차지 + 스크롤)
                Expanded(
                  child: state.hasData
                      ? ListView.separated(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          itemCount: state.data.length,
                          separatorBuilder: (ctx, idx) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = state.data[index];
                            return _buildReceiptCard(context, item, index);
                          },
                        )
                      : _buildEmptyState(context),
                ),
              ],
            ),
          ),

          // [Layer 2] 로딩 오버레이
          if (state.isLoading)
            Container(
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
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradientReverse,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.document_scanner_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '영수증 자동 입력',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '사진을 올리면 지출 항목을 바로 정리해줘요.',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: Container(
        key: ValueKey(_selectedImage?.path ?? 'empty'),
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 52,
                      color: context.appColors.gray300,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '영수증 사진을 선택하세요',
                      style: TextStyle(
                        color: context.appColors.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? context.appColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: context.appColors.border),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary
                  ? Colors.white
                  : context.appColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isPrimary
                    ? Colors.white
                    : context.appColors.textSecondary,
              ),
            ),
            if (isDisabled) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isPrimary
                      ? Colors.white70
                      : context.appColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: context.appColors.primaryPale,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: context.appColors.primaryDark,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '영수증을 스캔하면\n분석 결과가 여기에 표시됩니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(
    BuildContext context,
    ReceiptData item,
    int index,
  ) {
    final amount = item.amount ?? 0;
    final dateText = item.date != null
        ? DateFormat('yyyy.MM.dd').format(item.date!)
        : '날짜 미상';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.displayName ?? '알 수 없음',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: context.appColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${_formatMoney(amount)}원',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: context.appColors.expense,
                ),
              ),
            ],
          ),
          if (item.merchant != null && item.merchant != item.displayName)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.merchant!,
                style: TextStyle(
                  fontSize: 12,
                  color: context.appColors.textTertiary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: context.appColors.gray400,
              ),
              const SizedBox(width: 6),
              Text(
                dateText,
                style: TextStyle(
                  fontSize: 12,
                  color: context.appColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: context.appColors.primaryPale,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item.category?.displayName ?? '기타',
                  style: TextStyle(
                    fontSize: 11,
                    color: context.appColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.appColors.backgroundAccentTint,
                context.appColors.backgroundLight,
              ],
            ),
          ),
        ),
        Positioned(
          top: -40,
          right: -20,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: context.appColors.primaryLight.withOpacity(0.45),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: context.appColors.primaryPale.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}
