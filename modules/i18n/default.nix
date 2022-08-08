{ pkgs, lib, ... }:

# inputMethod (日本語入力のみ)
# 無変換と変換 で IME on/off
{
  i18n.inputMethod.enabled = "fcitx5";

  i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];

  # mozc の設定ファイル(バイナリ)
  # 無変換と変換 を IME on/off に割り当てている
  # 設定ファイルの詳細は下記を参照
  # https://github.com/google/mozc/blob/master/docs/configurations.md#configuration-files
  xdg.configFile."mozc/config1.db".source = ./mozc/config1.db;

  # NOTE: もし初めて switch する前にすでに ~/.mozc が存在する場合、xdg config home のほうではなく ~/.mozc が使われるためその場合は下記を使うこと
  # home.file.".mozc/config1.db".source = ./mozc/config1.db;

  # fcitx5 の設定ファイル
  # 上記の mozc で設定した IME on/off がちゃんと期待通り動くようにしてある & 余計な設定やキーバインドを外してある
  xdg.configFile."fcitx5/config".source = ./fcitx5/config;
  xdg.configFile."fcitx5/profile".source = ./fcitx5/profile;
}
