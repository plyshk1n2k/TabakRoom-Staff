class ApiResponse<T> {
  final T? data;
  final String? error;

  ApiResponse.success(this.data) : error = null;
  ApiResponse.error(this.error) : data = null;

  bool get isSuccess => data != null;
}
