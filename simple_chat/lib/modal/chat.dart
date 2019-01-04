
class ChatModal {

  String GUID_UNF;
  String delivery_datetime;
  String error;
  String message;
  String message_datetime;
  String photo;
  String read_datetime;
  int status_1c;
  int from_1c;
  int status_app;
  int target;
  int task;

  ChatModal({
    this.task,
    this.delivery_datetime,
    this.error,
    this.from_1c,
    this.GUID_UNF,
    this.message,
    this.message_datetime,
    this.photo,
    this.read_datetime,
    this.status_1c,
    this.status_app,
    this.target
  });

  ChatModal.fromFields(Map<String,dynamic> fields) {
    //fields.forEach((key, value) => print("$key=$value"));
    delivery_datetime = fields["delivery_datetime"].toString();
    error = fields["error"].toString();
    GUID_UNF = fields["GUID_UNF"].toString();
    message = fields["message"].toString();
    message_datetime = fields["message_datetime"].toString();
    photo = fields["photo"].toString();
    read_datetime = fields["read_datetime"].toString();
    status_1c = int.tryParse(fields["status_1c"]);
    status_app = int.tryParse(fields["status_app"]);
    from_1c = int.tryParse(fields["from_1c"]);
    target = int.tryParse(fields["target"]);
    task =  int.tryParse(fields["task"]);
  }
}



