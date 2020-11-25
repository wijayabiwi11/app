class NotificationModel {
  String portoKey;
  String updatedAt;
  String type;

  NotificationModel({
    this.portoKey,
  });

  NotificationModel.fromJson(String portoId, String updatedAt, String type) {
    portoKey = portoId;
    this.updatedAt = updatedAt;
    this.type = type;
  }

  Map<String, dynamic> toJson() => {
        "portoKey": portoKey == null ? null : portoKey,
      };
}
