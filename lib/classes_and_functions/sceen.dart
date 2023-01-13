class ScreenManager {
  double width = 0;
  double height = 0;

  ScreenManager(List<double> size) {
    width = size[0];
    height = size[1];
  }
}

ScreenManager SM = ScreenManager([0, 0]);
