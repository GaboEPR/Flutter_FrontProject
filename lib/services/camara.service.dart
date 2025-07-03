import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();
  List<CameraDescription>? _cameras;
  CameraController? _controller;

  // Inicializar cámaras disponibles
  Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      print('Error inicializando cámaras: $e');
    }
  }

  // Obtener lista de cámaras
  List<CameraDescription>? get cameras => _cameras;

  // Inicializar controlador de cámara
  Future<CameraController?> initializeController({
    CameraDescription? camera,
    ResolutionPreset resolution = ResolutionPreset.high,
  }) async {
    try {
      if (_cameras == null || _cameras!.isEmpty) {
        await initializeCameras();
      }

      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No hay cámaras disponibles');
      }

      final selectedCamera = camera ?? _cameras!.first;

      _controller = CameraController(
        selectedCamera,
        resolution,
        enableAudio: false,
      );

      await _controller!.initialize();
      return _controller;
    } catch (e) {
      print('Error inicializando controlador: $e');
      return null;
    }
  }

  // Tomar foto con controlador
  Future<File?> takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw Exception('Controlador de cámara no inicializado');
      }

      final XFile picture = await _controller!.takePicture();
      return File(picture.path);
    } catch (e) {
      print('Error tomando foto: $e');
      return null;
    }
  }

  // Tomar foto usando Image Picker (Cámara)
  Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error seleccionando imagen de cámara: $e');
      return null;
    }
  }

  // Seleccionar imagen de galería
  Future<Uint8List?> pickImageBytesFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      if (image != null) {
        return await image.readAsBytes(); // Compatible en web y móvil
      }
      return null;
    } catch (e) {
      print('Error seleccionando imagen: $e');
      return null;
    }
  }

  // Mostrar opciones de selección de imagen
  Future<File?> showImageSourceDialog() async {
    // Este método debe ser implementado en el widget que lo use
    // porque necesita el BuildContext
    throw UnimplementedError('Debe implementarse en el widget');
  }

  // Guardar imagen en directorio de la app
  Future<File?> saveImageToAppDirectory(
    File sourceFile, {
    String? customName,
  }) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagesDir = path.join(appDir.path, 'images');

      // Crear directorio si no existe
      await Directory(imagesDir).create(recursive: true);

      // Generar nombre único si no se proporciona
      final String fileName =
          customName ?? 'animal_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final String newPath = path.join(imagesDir, fileName);

      // Copiar archivo
      final File newFile = await sourceFile.copy(newPath);
      return newFile;
    } catch (e) {
      print('Error guardando imagen: $e');
      return null;
    }
  }

  // Comprimir imagen
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    try {
      // Aquí podrías usar una librería como image para comprimir
      // Por simplicidad, retornamos el archivo original
      return imageFile;
    } catch (e) {
      print('Error comprimiendo imagen: $e');
      return null;
    }
  }

  // Obtener tamaño de archivo en MB
  double getFileSizeInMB(File file) {
    final int bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  // Validar tamaño de imagen
  bool isValidImageSize(File file, {double maxSizeMB = 5.0}) {
    return getFileSizeInMB(file) <= maxSizeMB;
  }

  // Limpiar recursos
  void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  // Verificar permisos de cámara
  Future<bool> hasCameraPermission() async {
    try {
      // Intentar inicializar las cámaras para verificar permisos
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Obtener información de la cámara
  Map<String, dynamic> getCameraInfo() {
    if (_cameras == null || _cameras!.isEmpty) {
      return {'available': false, 'count': 0};
    }

    return {
      'available': true,
      'count': _cameras!.length,
      'cameras':
          _cameras!
              .map(
                (camera) => {
                  'name': camera.name,
                  'lensDirection': camera.lensDirection.toString(),
                  'sensorOrientation': camera.sensorOrientation,
                },
              )
              .toList(),
    };
  }
}
