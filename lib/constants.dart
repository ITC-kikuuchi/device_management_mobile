/**
 * デバイスの種類を管理する定数
 */
class DeviceId {
  static const pc = 1;
  static const ios = 2;
  static const android = 3;
  static const windows = 4;
}

/**
 * レスポンスのステータスコードを管理する定数
 */
class HttpStatusCode {
  static const ok = 200;
  static const unauthorized = 401;
  static const forbidden = 403;
  static const not_found = 404;
  static const internal_server_error = 500;
}