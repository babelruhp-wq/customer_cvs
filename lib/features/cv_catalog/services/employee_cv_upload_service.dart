import 'package:dio/dio.dart';

import '../models/create_cv_request.dart';

/// خدمة رفع السيرة الذاتية من تطبيق الموظفين / Backoffice.
///
/// البيانات النصية تأتي من [CreateCvRequest]
/// وملف السيرة يتم إرساله كـ PDF عن طريق multipart/form-data.
class EmployeeCvUploadService {
  final Dio dio;
  final String createCvPath;

  EmployeeCvUploadService({
    required this.dio,
    required this.createCvPath,
  });

  // ==========================================================
  // CREATE CV
  // ==========================================================

  Future<void> createCv({
    required CreateCvRequest request,
    required MultipartFile cvFile,
  }) async {
    final formData = FormData.fromMap({
      ...request.toMap(),

      'CvFile': cvFile,
    });

    await dio.post(
      createCvPath,
      data: formData,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
      ),
    );
  }
}