final class Env {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://brasilapi.com.br/api/');

  static const apiKey = String.fromEnvironment('apiKey');
  static const appId = String.fromEnvironment('appId');
  static const messagingSenderId = String.fromEnvironment('messagingSenderId');
  static const projectId = String.fromEnvironment('projectId');
  static const authDomain = String.fromEnvironment('authDomain');
  static const databaseURL = String.fromEnvironment('databaseURL');
  static const storageBucket = String.fromEnvironment('storageBucket');
  static const measurementId = String.fromEnvironment('measurementId');
}
