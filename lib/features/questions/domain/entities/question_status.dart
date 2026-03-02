/// Soru durumu enum'u.
///
/// Backend: `core.models.QuestionStatus` — TextChoices
enum QuestionStatus {
  reviewing('reviewing', 'İnceleniyor'),
  repPending('rep_pending', 'Temsilci Onayında'),
  repApproved('rep_approved', 'Temsilci Onayladı'),
  repRejected('rep_rejected', 'Temsilci Reddetti'),
  repBypassed('rep_bypassed', 'Hoca Cevapladı (Bypass)'),
  forwarded('forwarded', 'Yönlendirildi'),
  answered('answered', 'Cevaplandı'),
  closed('closed', 'Kapatıldı');

  final String value;
  final String displayName;

  const QuestionStatus(this.value, this.displayName);

  static QuestionStatus fromValue(String value) {
    return QuestionStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => QuestionStatus.reviewing,
    );
  }
}

/// Temsilci onay durumu.
///
/// Backend: `accounts.constants.RepApprovalStatus`
enum RepStatus {
  pending('pending', 'Beklemede'),
  approved('approved', 'Onaylandı'),
  rejected('rejected', 'Reddedildi'),
  notRequired('not_required', 'Gerekli Değil');

  final String value;
  final String displayName;

  const RepStatus(this.value, this.displayName);

  static RepStatus fromValue(String? value) {
    if (value == null) return RepStatus.notRequired;
    return RepStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => RepStatus.notRequired,
    );
  }
}
