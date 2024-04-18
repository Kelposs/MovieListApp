class Response<T> {
  final Status status;
  final T? data;
  final String? message;

  Response.completed(this.data) : status = Status.success, message = null;
  Response.error(this.message,{this.data}) : status = Status.error;
  Response.loading() : status = Status.loading, data = null, message = null;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { success, error, loading }