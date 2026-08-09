import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrHelper {
  /// Scan book cover.
  static Future<String?> scanBookCover() async {
    final ImagePicker picker = ImagePicker();
    
    // Request image from camera
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final TextRecognizer textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      // Return null or handle error accordingly
      return null;
    } finally {
      // Ensure the text recognizer is closed to free resources
      await textRecognizer.close();
    }
  }
}
