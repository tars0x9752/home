{ ... }:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # home-manager 22.05 以上ではデフォルトで flakes サポート有効
}
