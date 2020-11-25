class ChatMessage {
  String key;
  String pengirimId;
  String pesan;
  bool seen;
  String createdAt;
  String timeStamp;
  String namaPengirim;
  String receiverId;

  ChatMessage(
      {this.key,
      this.pengirimId,
      this.pesan,
      this.seen,
      this.createdAt,
      this.receiverId,
      this.namaPengirim,
      this.timeStamp});

  /*factory ChatMessage.fromJson(Map<dynamic, dynamic> json) => ChatMessage(
      key: json["key"],
      pengirimId: json["pengirim_id"],*/ //belum fix

}
