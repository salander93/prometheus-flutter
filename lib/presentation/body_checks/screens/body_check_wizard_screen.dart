import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/api/api_constants.dart';
import 'package:palestra/core/theme/app_colors.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/body_check_providers.dart';

// ──────────────────────────────────────────────────────────────
// Photo position enum
// ──────────────────────────────────────────────────────────────

enum _PhotoPosition {
  front('FRONT', 'Frontale'),
  back('BACK', 'Posteriore'),
  rightSide('RIGHT', 'Lato Destro'),
  leftSide('LEFT', 'Lato Sinistro');

  const _PhotoPosition(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

// ──────────────────────────────────────────────────────────────
// Photo entry — tracks file, bytes cache, and assigned position
// ──────────────────────────────────────────────────────────────

class _PhotoEntry {
  _PhotoEntry({
    required this.id,
    required this.file,
    required this.bytes,
  });

  final String id;
  final XFile file;
  Uint8List bytes;
  _PhotoPosition? position;
}

// ──────────────────────────────────────────────────────────────
// Wizard state
// ──────────────────────────────────────────────────────────────

class _WizardState {
  _WizardState({
    required this.selectedDate,
    this.weightKg,
    this.bodyFatPercent,
    this.notes,
  });

  final DateTime selectedDate;
  final double? weightKg;
  final double? bodyFatPercent;
  final String? notes;

  _WizardState copyWith({
    DateTime? selectedDate,
    Object? weightKg = _sentinel,
    Object? bodyFatPercent = _sentinel,
    Object? notes = _sentinel,
  }) {
    return _WizardState(
      selectedDate: selectedDate ?? this.selectedDate,
      weightKg: weightKg == _sentinel
          ? this.weightKg
          : weightKg as double?,
      bodyFatPercent: bodyFatPercent == _sentinel
          ? this.bodyFatPercent
          : bodyFatPercent as double?,
      notes: notes == _sentinel
          ? this.notes
          : notes as String?,
    );
  }

  String get autoTitle {
    final formatted = DateFormat(
      'd MMMM yyyy',
      'it',
    ).format(selectedDate);
    return 'Body Check $formatted';
  }

  String get dateString {
    final y = selectedDate.year.toString().padLeft(4, '0');
    final m = selectedDate.month.toString().padLeft(2, '0');
    final d = selectedDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

const _sentinel = Object();

// ──────────────────────────────────────────────────────────────
// Main wizard screen
// ──────────────────────────────────────────────────────────────

class BodyCheckWizardScreen extends ConsumerStatefulWidget {
  const BodyCheckWizardScreen({super.key});

  @override
  ConsumerState<BodyCheckWizardScreen> createState() =>
      _BodyCheckWizardScreenState();
}

class _BodyCheckWizardScreenState
    extends ConsumerState<BodyCheckWizardScreen>
    with TickerProviderStateMixin {
  static const _totalSteps = 2;
  static const _maxPhotos = 4;

  late final PageController _pageController;
  late final AnimationController _pulseController;

  int _currentStep = 0;
  bool _isSubmitting = false;
  int _idCounter = 0;

  // Step 1 controllers
  final _weightCtl = TextEditingController();
  final _bodyFatCtl = TextEditingController();
  final _notesCtl = TextEditingController();

  late _WizardState _wizard;
  final List<_PhotoEntry> _photos = [];
  String? _selectedPhotoId;

  @override
  void initState() {
    super.initState();
    _wizard = _WizardState(selectedDate: DateTime.now());
    _pageController = PageController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    _weightCtl.dispose();
    _bodyFatCtl.dispose();
    _notesCtl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────

  List<_PhotoEntry> get _unassigned =>
      _photos.where((p) => p.position == null).toList();

  _PhotoEntry? _photoForPosition(_PhotoPosition pos) {
    final matches = _photos.where((p) => p.position == pos);
    return matches.isEmpty ? null : matches.first;
  }

  bool get _hasSelectedPhoto => _selectedPhotoId != null;

  // ── Navigation ─────────────────────────────────────────────

  void _goNext() {
    if (_currentStep >= _totalSteps - 1) return;
    _syncState();
    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.pop();
    }
  }

  void _syncState() {
    _wizard = _wizard.copyWith(
      weightKg: _weightCtl.text.trim().isEmpty
          ? null
          : double.tryParse(_weightCtl.text.trim()),
      bodyFatPercent: _bodyFatCtl.text.trim().isEmpty
          ? null
          : double.tryParse(_bodyFatCtl.text.trim()),
      notes: _notesCtl.text.trim().isEmpty
          ? null
          : _notesCtl.text.trim(),
    );
  }

  // ── Date picker ────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _wizard.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: AppColors.primary,
                surface: AppColors.backgroundCard,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _wizard = _wizard.copyWith(selectedDate: picked);
      });
    }
  }

  // ── Photo picking ──────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    final remaining = _maxPhotos - _photos.length;
    if (remaining <= 0) {
      _showToast('Massimo $_maxPhotos foto consentite');
      return;
    }
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (files.isEmpty) return;

    final toAdd = files.take(remaining).toList();
    if (files.length > remaining) {
      _showToast('Solo $remaining foto aggiunte (max $_maxPhotos)');
    }

    final entries = <_PhotoEntry>[];
    for (final f in toAdd) {
      final bytes = await f.readAsBytes();
      entries.add(
        _PhotoEntry(
          id: '${_idCounter++}',
          file: f,
          bytes: bytes,
        ),
      );
    }
    setState(() => _photos.addAll(entries));
  }

  Future<void> _pickFromCamera() async {
    if (_photos.length >= _maxPhotos) {
      _showToast('Massimo $_maxPhotos foto consentite');
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      _photos.add(
        _PhotoEntry(
          id: '${_idCounter++}',
          file: file,
          bytes: bytes,
        ),
      );
    });
  }

  // ── Photo selection & assignment ───────────────────────────

  void _toggleSelectPhoto(String id) {
    setState(() {
      if (_selectedPhotoId == id) {
        _selectedPhotoId = null;
      } else {
        _selectedPhotoId = id;
      }
    });
  }

  void _removePhoto(String id) {
    setState(() {
      _photos.removeWhere((p) => p.id == id);
      if (_selectedPhotoId == id) _selectedPhotoId = null;
    });
  }

  Future<void> _assignToPosition(_PhotoPosition pos) async {
    if (_selectedPhotoId == null) return;

    final selectedPhoto = _photos.firstWhere(
      (p) => p.id == _selectedPhotoId,
    );

    // Try to find a reference photo from a previous body check
    // for this position
    Uint8List? referenceBytes;
    try {
      final bodyChecks =
          ref.read(bodyChecksProvider).valueOrNull ?? [];
      for (final check in bodyChecks) {
        final matchingPhotos = check.photos.where(
          (p) =>
              p.position.toUpperCase() ==
              pos.apiValue
                  .toUpperCase()
                  .replaceAll('_side', ''),
        );
        if (matchingPhotos.isNotEmpty) {
          final photoUrl = matchingPhotos.first.photo;
          final resolvedUrl = photoUrl.startsWith('http')
              ? photoUrl
              : '${ApiConstants.baseUrl}$photoUrl';
          final apiClient = ref.read(apiClientProvider);
          final response = await apiClient.dio.get<List<int>>(
            resolvedUrl,
            options: Options(responseType: ResponseType.bytes),
          );
          referenceBytes = Uint8List.fromList(response.data!);
          break;
        }
      }
    } catch (_) {
      // Silently fail — reference is optional
    }

    final result = await context.push<Uint8List>(
      '/body-checks/edit-photo',
      extra: <String, dynamic>{
        'imageBytes': selectedPhoto.bytes,
        'position': pos.apiValue,
        'positionLabel': pos.label,
        'referenceImageBytes': referenceBytes,
      },
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        // If slot already has a photo, unassign it first
        final existing = _photoForPosition(pos);
        if (existing != null) {
          existing.position = null;
        }

        // Assign selected photo with (potentially edited) bytes
        selectedPhoto
          ..bytes = result
          ..position = pos;
        _selectedPhotoId = null;
      });
    } else {
      // User cancelled — clear selection
      setState(() {
        _selectedPhotoId = null;
      });
    }
  }

  void _unassignPosition(_PhotoPosition pos) {
    setState(() {
      final entry = _photoForPosition(pos);
      if (entry != null) entry.position = null;
    });
  }

  // ── Submit ─────────────────────────────────────────────────

  Future<void> _submit() async {
    _syncState();

    final assigned =
        _photos.where((p) => p.position != null).toList();
    if (assigned.isEmpty) {
      _showToast('Assegna almeno una foto a una posizione');
      return;
    }
    if (_unassigned.isNotEmpty) {
      _showToast(
        'Hai foto non assegnate. '
        'Rimuovile o assegnale a una posizione',
      );
      return;
    }
    if (assigned.length < _maxPhotos) {
      _showToast(
        'Hai ${assigned.length} di $_maxPhotos posizioni — '
        'puoi aggiungere altre foto per un body check completo',
      );
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(bodyCheckRepositoryProvider);

      final bodyCheckId = await repo.createBodyCheck(
        title: _wizard.autoTitle,
        date: _wizard.dateString,
        notes: _wizard.notes,
        weightKg: _wizard.weightKg,
        bodyFatPercent: _wizard.bodyFatPercent,
      );

      for (final entry in assigned) {
        await repo.uploadPhoto(
          bodyCheckId: bodyCheckId,
          filePath: entry.file.path,
          position: entry.position!.apiValue,
          bytes: entry.bytes,
        );
      }

      if (!mounted) return;
      ref.invalidate(bodyChecksProvider);
      context.go('/body-checks/$bodyCheckId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  0,
                ),
                child: _TopBar(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onClose: () => context.pop(),
                ),
              ),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  children: [
                    _Step1MetricsPage(
                      wizard: _wizard,
                      weightCtl: _weightCtl,
                      bodyFatCtl: _bodyFatCtl,
                      notesCtl: _notesCtl,
                      onPickDate: _pickDate,
                    ),
                    _Step2PhotosPage(
                      photos: _photos,
                      selectedPhotoId: _selectedPhotoId,
                      pulseAnimation: _pulseController,
                      onPickGallery: _pickFromGallery,
                      onPickCamera: _pickFromCamera,
                      onToggleSelect: _toggleSelectPhoto,
                      onRemovePhoto: _removePhoto,
                      onAssignPosition: _assignToPosition,
                      onUnassignPosition: _unassignPosition,
                      photoForPosition: _photoForPosition,
                      hasSelectedPhoto: _hasSelectedPhoto,
                    ),
                  ],
                ),
              ),

              // Bottom nav
              _BottomNav(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                isSubmitting: _isSubmitting,
                onBack: _goBack,
                onNext: _goNext,
                onSubmit: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Top bar — progress bars + close
// ──────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.currentStep,
    required this.totalSteps,
    required this.onClose,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(totalSteps, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: i < totalSteps - 1 ? 4 : 0,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      height: 3,
                      decoration: BoxDecoration(
                        color: i <= currentStep
                            ? AppColors.primary
                            : const Color(0x33FFFFFF),
                        borderRadius:
                            BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0x33FFFFFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Step 1 — Body Metrics
// ──────────────────────────────────────────────────────────────

class _Step1MetricsPage extends StatelessWidget {
  const _Step1MetricsPage({
    required this.wizard,
    required this.weightCtl,
    required this.bodyFatCtl,
    required this.notesCtl,
    required this.onPickDate,
  });

  final _WizardState wizard;
  final TextEditingController weightCtl;
  final TextEditingController bodyFatCtl;
  final TextEditingController notesCtl;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat(
      'd MMMM yyyy',
      'it',
    ).format(wizard.selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nuovo Body Check',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Traccia i tuoi progressi',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 28),

          // Glassmorphic card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0x14FFFFFF),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data
                const _Label(text: 'Data'),
                const SizedBox(height: 8),
                _DateTile(
                  dateLabel: dateLabel,
                  onTap: onPickDate,
                ),
                const SizedBox(height: 20),

                // Peso + Body Fat row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const _Label(text: 'Peso (kg)'),
                          const SizedBox(height: 8),
                          _NumField(
                            controller: weightCtl,
                            hint: '70.5',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const _Label(
                            text: 'Body Fat %',
                          ),
                          const SizedBox(height: 8),
                          _NumField(
                            controller: bodyFatCtl,
                            hint: '15.0',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Note
                const _Label(text: 'Note'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: notesCtl,
                  maxLines: 3,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                  ),
                  decoration: _inputDecoration(
                    'Come ti senti?',
                  ),
                  textCapitalization:
                      TextCapitalization.sentences,
                ),
              ],
            ),
          ),

          // Auto-title preview
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0x14FFFFFF),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_fix_high_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Titolo generato automaticamente',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        wizard.autoTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Step 2 — Photo Upload & Assignment
// ──────────────────────────────────────────────────────────────

class _Step2PhotosPage extends StatelessWidget {
  const _Step2PhotosPage({
    required this.photos,
    required this.selectedPhotoId,
    required this.pulseAnimation,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onToggleSelect,
    required this.onRemovePhoto,
    required this.onAssignPosition,
    required this.onUnassignPosition,
    required this.photoForPosition,
    required this.hasSelectedPhoto,
  });

  final List<_PhotoEntry> photos;
  final String? selectedPhotoId;
  final Animation<double> pulseAnimation;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onRemovePhoto;
  final Future<void> Function(_PhotoPosition) onAssignPosition;
  final ValueChanged<_PhotoPosition> onUnassignPosition;
  final _PhotoEntry? Function(_PhotoPosition)
      photoForPosition;
  final bool hasSelectedPhoto;

  List<_PhotoEntry> get _unassigned =>
      photos.where((p) => p.position == null).toList();

  String get _photoSubtitle {
    if (photos.isEmpty) {
      return 'Seleziona fino a 4 foto, poi assegnale alle posizioni';
    }
    if (photos.length < 4) {
      return 'Hai selezionato ${photos.length}/4 foto — puoi aggiungerne altre';
    }
    return 'Tutte le foto selezionate — assegnale alle posizioni';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carica le foto',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            _photoSubtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),

          // Upload buttons — hidden when 4 photos already picked
          if (photos.length < 4) ...[
            Row(
              children: [
                Expanded(
                  child: _UploadBtn(
                    icon: Icons.photo_library_outlined,
                    label: 'Seleziona Foto',
                    onTap: onPickGallery,
                  ),
                ),
                const SizedBox(width: 12),
                _CameraBtn(onTap: onPickCamera),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'oppure scatta singolarmente',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0x1A4CAF50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0x334CAF50),
                ),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF4CAF50),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '4 foto selezionate',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Unassigned photos row
          if (_unassigned.isNotEmpty) ...[
            const _Label(text: 'Foto non assegnate'),
            const SizedBox(height: 8),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _unassigned.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final entry = _unassigned[i];
                  final isSelected =
                      entry.id == selectedPhotoId;
                  return _UnassignedThumb(
                    entry: entry,
                    isSelected: isSelected,
                    onTap: () =>
                        onToggleSelect(entry.id),
                    onRemove: () =>
                        onRemovePhoto(entry.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Instruction when photo selected
          if (hasSelectedPhoto) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0x1AFF6B35),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0x33FF6B35),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tocca una posizione per '
                      'assegnare la foto selezionata',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 2x2 Position grid
          GridView.count(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 4,
            children: _PhotoPosition.values.map((pos) {
              final photo = photoForPosition(pos);
              return _PositionSlot(
                position: pos,
                photo: photo,
                isPulsing: hasSelectedPhoto,
                pulseAnimation: pulseAnimation,
                onTap: () => unawaited(onAssignPosition(pos)),
                onUnassign: () =>
                    onUnassignPosition(pos),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Unassigned photo thumbnail
// ──────────────────────────────────────────────────────────────

class _UnassignedThumb extends StatelessWidget {
  const _UnassignedThumb({
    required this.entry,
    required this.isSelected,
    required this.onTap,
    required this.onRemove,
  });

  final _PhotoEntry entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        transform: isSelected
            ? (Matrix4.identity()
              ..scaleByDouble(1.1, 1.1, 1, 1))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : const Color(0x33FFFFFF),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x80FF6B35),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(9),
              child: Image.memory(
                entry.bytes,
                fit: BoxFit.cover,
              ),
            ),
            // Remove X
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Position slot (2x2 grid item)
// ──────────────────────────────────────────────────────────────

class _PositionSlot extends StatelessWidget {
  const _PositionSlot({
    required this.position,
    required this.isPulsing,
    required this.pulseAnimation,
    required this.onTap,
    required this.onUnassign,
    this.photo,
  });

  final _PhotoPosition position;
  final _PhotoEntry? photo;
  final bool isPulsing;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;
  final VoidCallback onUnassign;

  String? get _hint {
    switch (position) {
      case _PhotoPosition.rightSide:
        return 'Braccio DX visibile';
      case _PhotoPosition.leftSide:
        return 'Braccio SX visibile';
      case _PhotoPosition.front:
      case _PhotoPosition.back:
        return null;
    }
  }

  IconData get _icon {
    switch (position) {
      case _PhotoPosition.front:
        return Icons.person_outline_rounded;
      case _PhotoPosition.back:
        return Icons.person_outline_rounded;
      case _PhotoPosition.rightSide:
        return Icons.person_outline_rounded;
      case _PhotoPosition.leftSide:
        return Icons.person_outline_rounded;
    }
  }

  bool get _flipIcon =>
      position == _PhotoPosition.back;

  @override
  Widget build(BuildContext context) {
    if (photo != null) {
      return _buildFilled(context);
    }
    return _buildEmpty(context);
  }

  Widget _buildFilled(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.memory(
              photo!.bytes,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient + label
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Text(
                position.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Remove button
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onUnassign,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.black
                      .withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          final pulseValue =
              isPulsing ? pulseAnimation.value : 0.0;
          return CustomPaint(
            painter: _DashedBorderPainter(
              color: isPulsing
                  ? Color.lerp(
                      const Color(0x33FFFFFF),
                      AppColors.primary,
                      pulseValue,
                    )!
                  : const Color(0x33FFFFFF),
              strokeWidth: isPulsing ? 2 : 1,
              radius: 12,
            ),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: _flipIcon
                    ? (Matrix4.identity()
                      ..scaleByDouble(
                        -1,
                        1,
                        1,
                        1,
                      ))
                    : Matrix4.identity(),
                child: Icon(
                  _icon,
                  color: AppColors.textMuted,
                  size: 36,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                position.label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_hint != null) ...[
                const SizedBox(height: 4),
                Text(
                  _hint!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Dashed border painter
// ──────────────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashLength = 6.0;
    const gapLength = 4.0;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;

    var distance = 0.0;
    while (distance < totalLength) {
      final end = (distance + dashLength)
          .clamp(0.0, totalLength);
      final extractPath =
          metrics.extractPath(distance, end);
      canvas.drawPath(extractPath, paint);
      distance += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth;
}

// ──────────────────────────────────────────────────────────────
// Upload buttons
// ──────────────────────────────────────────────────────────────

class _UploadBtn extends StatelessWidget {
  const _UploadBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0x33FFFFFF),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraBtn extends StatelessWidget {
  const _CameraBtn({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0x33FFFFFF),
          ),
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Shared small widgets
// ──────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.dateLabel,
    required this.onTap,
  });

  final String dateLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0x33FFFFFF),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 10),
            Text(
              dateLabel,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumField extends StatelessWidget {
  const _NumField({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      style: const TextStyle(
        color: AppColors.textPrimary,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp('[0-9.]'),
        ),
      ],
      decoration: _inputDecoration(hint),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppColors.textMuted,
    ),
    filled: true,
    fillColor: const Color(0x1AFFFFFF),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 12,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0x33FFFFFF),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0x33FFFFFF),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: AppColors.primary,
      ),
    ),
  );
}

// ──────────────────────────────────────────────────────────────
// Bottom navigation
// ──────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentStep,
    required this.totalSteps,
    required this.isSubmitting,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final int currentStep;
  final int totalSteps;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  bool get _isLast => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x14FFFFFF),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0x33FFFFFF),
                ),
              ),
              child: Icon(
                currentStep == 0
                    ? Icons.close_rounded
                    : Icons.arrow_back_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Next / Submit
          Expanded(
            child: _isLast
                ? _submitButton()
                : _nextButton(),
          ),
        ],
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onNext,
          borderRadius: BorderRadius.circular(26),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Avanti',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: isSubmitting
            ? null
            : const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
        color: isSubmitting
            ? AppColors.textMuted
            : null,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSubmitting ? null : onSubmit,
          borderRadius: BorderRadius.circular(26),
          child: Center(
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Pubblica Body Check',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
