library fluent;

class PathHelper {
  static List<String> extractPath(String path) {
    return path.split("/");
  }
}
