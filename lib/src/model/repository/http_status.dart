class HttpStatus {
  final bool status;

  HttpStatus({this.status});

  factory HttpStatus.fromJson(Map<String, dynamic> json) {
    return HttpStatus(status: json['status']);
  }
}