enum CvCatalogType {
  recruitment,
  serviceTransfer,
}

extension CvCatalogTypeX on CvCatalogType {
  bool get isRecruitment => this == CvCatalogType.recruitment;

  bool get isServiceTransfer =>
      this == CvCatalogType.serviceTransfer;

  String get title => isRecruitment ? 'الاستقدام' : 'نقل الخدمات';
}
