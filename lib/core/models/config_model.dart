class ConfigModel {
  final String line;
  final String lineName;
  final String host;
  final String port;
  final String updateHost;
  final String updatePort;

  ConfigModel({
    required this.line,
    required this.lineName,
    required this.host,
    required this.port,
    required this.updateHost,
    required this.updatePort,
  });

  ConfigModel copyWith({
    String? line,
    String? lineName,
    String? host,
    String? port,
    String? updateHost,
    String? updatePort,
  }) {
    return ConfigModel(
        line: line ?? this.line,
        lineName: lineName ?? this.lineName,
        host: host ?? this.host,
        port: port ?? this.port,
        updateHost: updateHost ?? this.updateHost,
        updatePort: updatePort ?? this.updatePort,
    );
  }

  @override
  String toString() {
    return "$line || $lineName || $host || $port || $updateHost || $updatePort ";
  }
}
