import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palestra/core/error/app_error.dart';
import 'package:palestra/core/error/error_handler.dart';
import 'package:palestra/data/models/user_model.dart';
import 'package:palestra/presentation/auth/providers/auth_providers.dart';
import 'package:palestra/presentation/shared/providers/user_providers.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _heightController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _isUploadingPhoto = false;
  UserModel? _initialUser;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _heightController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _populateFromUser(UserModel user) {
    if (_initialUser != null) return;
    _initialUser = user;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _heightController.text =
        user.height != null ? user.height!.toInt().toString() : '';
    _phoneController.text = user.phone ?? '';
    _bioController.text = user.bio ?? '';

    if (user.birthDate != null) {
      try {
        _selectedBirthDate = DateTime.parse(user.birthDate!);
      } catch (_) {
        _selectedBirthDate = null;
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _selectedBirthDate ?? DateTime(now.year - 25);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: now,
      locale: const Locale('it', 'IT'),
      helpText: 'Seleziona data di nascita',
      cancelText: 'Annulla',
      confirmText: 'Conferma',
    );

    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (image == null || !mounted) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.uploadPhoto(image.path);
      ref.invalidate(currentUserProvider);
    } on AppError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.userMessage)),
        );
      }
    } catch (e, st) {
      if (mounted) {
        final appError = ErrorHandler.handle(e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appError.userMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<void> _removePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rimuovi Foto'),
        content: const Text(
          'Sei sicuro di voler rimuovere la foto profilo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Rimuovi'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.deletePhoto();
      ref.invalidate(currentUserProvider);
    } on AppError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.userMessage)),
        );
      }
    } catch (e, st) {
      if (mounted) {
        final appError = ErrorHandler.handle(e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appError.userMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  void _showPhotoOptions(UserModel user) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Scatta una foto'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Scegli dalla galleria'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (user.photo != null)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Rimuovi foto',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _removePhoto();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final data = <String, dynamic>{
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      final heightText = _heightController.text.trim();
      if (heightText.isNotEmpty) {
        data['height'] = double.parse(heightText);
      } else {
        data['height'] = null;
      }

      if (_selectedBirthDate != null) {
        data['birth_date'] =
            DateFormat('yyyy-MM-dd').format(_selectedBirthDate!);
      }

      await ref.read(userRepositoryProvider).updateProfile(data);
      ref.invalidate(currentUserProvider);

      if (mounted) {
        context.pop();
      }
    } on AppError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.userMessage)),
        );
      }
    } catch (e, st) {
      if (mounted) {
        final appError = ErrorHandler.handle(e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appError.userMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Profilo'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Salva'),
            ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          _populateFromUser(user);
          return _EditBody(
            user: user,
            formKey: _formKey,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            heightController: _heightController,
            phoneController: _phoneController,
            bioController: _bioController,
            selectedBirthDate: _selectedBirthDate,
            isUploadingPhoto: _isUploadingPhoto,
            isLoading: _isLoading,
            onPhotoTap: () => _showPhotoOptions(user),
            onPickDate: _pickDate,
            onSave: _save,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 8),
              Text('Errore: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(currentUserProvider),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit body — extracted to keep build method clean
// ---------------------------------------------------------------------------

class _EditBody extends StatelessWidget {
  const _EditBody({
    required this.user,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.heightController,
    required this.phoneController,
    required this.bioController,
    required this.selectedBirthDate,
    required this.isUploadingPhoto,
    required this.isLoading,
    required this.onPhotoTap,
    required this.onPickDate,
    required this.onSave,
  });

  final UserModel user;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController heightController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final DateTime? selectedBirthDate;
  final bool isUploadingPhoto;
  final bool isLoading;
  final VoidCallback onPhotoTap;
  final VoidCallback onPickDate;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final initials = _initials(user);

    final birthDateLabel = selectedBirthDate != null
        ? DateFormat('dd MMMM yyyy', 'it_IT').format(selectedBirthDate!)
        : 'Seleziona data';

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Photo section ──────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: onPhotoTap,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: user.photo != null
                            ? CachedNetworkImageProvider(user.photo!)
                            : null,
                        child: user.photo == null
                            ? Text(
                                initials,
                                style: textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      if (isUploadingPhoto)
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          color: colorScheme.primary,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onPhotoTap,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onPhotoTap,
                  child: const Text('Cambia Foto'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Form fields ────────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informazioni Personali',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nome
                  TextFormField(
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Inserisci il nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Cognome
                  TextFormField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Cognome',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Inserisci il cognome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Data di nascita
                  InkWell(
                    onTap: onPickDate,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data di Nascita',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        suffixIcon: Icon(Icons.chevron_right),
                      ),
                      child: Text(
                        birthDateLabel,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Altezza
                  TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Altezza',
                      prefixIcon: Icon(Icons.height),
                      suffixText: 'cm',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed < 50 || parsed > 250) {
                        return 'Altezza non valida (50–250 cm)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Telefono
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Telefono',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bio
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: Icon(Icons.info_outline),
                      alignLabelWithHint: true,
                    ),
                    maxLength: 300,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Save button ────────────────────────────────────────────────
          FilledButton(
            onPressed: isLoading ? null : onSave,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Salva Modifiche'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _initials(UserModel u) {
    final first = u.firstName.isNotEmpty ? u.firstName[0] : '';
    final last = u.lastName.isNotEmpty ? u.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }
}
