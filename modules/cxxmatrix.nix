{ pkgs, ... }:

# https://github.com/akinomyoga/cxxmatrix

with pkgs;
let
  cxxmatrix = stdenv.mkDerivation {
    name = "cxxmatrix";
    src = fetchFromGitHub {
      "owner" = "akinomyoga";
      "repo" = "cxxmatrix";
      "rev" = "f338ed434e3f759e9be9dd8e0212e9e4a895d2a9";
      "sha256" = "XS9ms/sqBSQ5fzZvXNnC+HYvrK0T2EzgC/WdBhz9QOs=";
    };

    buildPhase = ''
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      export PREFIX="$out"
      make install
    '';
  };
in
{
  home.packages = [ cxxmatrix ];

  programs.bash.initExtra = ''
    # NOTE: wezterm で背景透明にしてると結構カクつく. xterm のほうが滑らかに動くので xterm に走らせる.
    alias cxxmatrix='xterm -e cxxmatrix --preserve-background'
  '';
}
