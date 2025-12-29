import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
      appBar: AppBar(
        title: const Text('OCR 테스트'),
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
          // [Layer 1] 메인 콘텐츠
          SafeArea(
            child: Column(
              children: [
                // 1. 이미지 미리보기 (고정 높이)
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.contain)
                      : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('이미지를 선택해주세요'),
                      ],
                    ),
                  ),
                ),

                // 2. 버튼 영역 (고정)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading ? null : _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('갤러리'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading ? null : _pickFromCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('카메라'),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. 에러 메시지 (고정)
                if (state.hasError)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => viewModel.clearError(),
                          color: Colors.red[700],
                        ),
                      ],
                    ),
                  ),

                // 4. 결과 리스트 (Expanded 적용: 남은 공간 전부 차지 + 스크롤)
                Expanded(
                  child: state.hasData
                      ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.data.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.data[index];
                      return _buildReceiptCard(item, index);
                    },
                  )
                      : const Center(
                    child: Text(
                      '영수증 이미지를 선택하면\n분석 결과가 여기에 표시됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // [Layer 2] 로딩 오버레이
          if (state.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(ReceiptData item, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.displayName ?? "알 수 없음",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${_formatMoney(item.amount ?? 0)}원",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
            if (item.merchant != null && item.merchant != item.displayName)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item.merchant!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  item.date?.toString().split(' ')[0] ?? "날짜 미상",
                  style: const TextStyle(fontSize: 13),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.category?.displayName ?? "기타",
                    style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMoney(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}