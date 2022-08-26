{ pkgs, ... }:

# this is for global ghc(i)

let
  haskellPackages = pkgs.haskellPackages;
in
{
  home = {
    packages = with haskellPackages; [
      ghc
      haskell-language-server
      hoogle # https://wiki.haskell.org/Hoogle
    ];

    # hoogle ghci integration
    # example> :hoogle <$>
    file.".ghci".text = ''
      :def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""
      :def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""
    '';
  };
}
