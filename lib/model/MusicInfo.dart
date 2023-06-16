

class MusicInfo {
  String title;
  int bitRate;
  int sampleRate;
  double duration;
  int size;
  String serialNumber;
  String albumName;
  String cover;

  MusicInfo({
    required this.title,
    required this.bitRate,
    required this.sampleRate,
    required this.duration,
    required this.size,
    required this.serialNumber,
    required this.albumName,
    required this.cover,
  });

  // 映射模型
  factory MusicInfo.fromJson(Map<String, dynamic> json) {
    return MusicInfo(
      title: json['title'],
      bitRate: json['bitRate'],
      sampleRate: json['sampleRate'],
      duration: json['duration'],
      size: json['size'],
      serialNumber: json['serialNumber'],
      albumName: json['albumName'],
      cover: json['cover'],
    );
  }

  // 创建映射
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'bitRate': bitRate,
      'sampleRate': sampleRate,
      'duration': duration,
      'size': size,
      'serialNumber': serialNumber,
      'albumName': albumName,
      'cover': cover,
    };
  }
}
