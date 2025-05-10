class Content {
  final String id;
  final String title;
  final String intro;
  final String desc;
  final String img;

  Content({
    required this.id,
    required this.title,
    required this.intro,
    required this.desc,
    required this.img,
  });

  factory Content.fromMap(String id, Map<String, dynamic> map) {
    return Content(
      id: id,
      title: map['title'] ?? '',
      intro: map['intro'] ?? '',
      desc: map['desc'] ?? '',
      img: map['img'] ?? '',
    );
  }
}
