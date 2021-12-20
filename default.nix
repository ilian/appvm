{ pkgs ? import <nixpkgs> {}, ... }:
let
  virt-manager-without-menu = pkgs.virt-viewer.overrideAttrs(x: {
    patches = [
      ./patches/0001-Remove-menu-bar.patch
      ./patches/0002-Do-not-grab-keyboard-mouse.patch
      ./patches/0003-Use-name-of-appvm-applications-as-a-title.patch
      ./patches/0004-Use-title-application-name-as-subtitle.patch
    ];
  });
in with pkgs;

buildGoModule rec {
  pname = "appvm";
  version = "master";

  buildInputs = [ makeWrapper ];

  src = ./.;

  vendorSha256 = "sha256-8eU+Mf5dxL/bAMMShXvj8I1Kdd4ysBTWvgYIXwLStPI=";

  postFixup = ''
    wrapProgram $out/bin/appvm \
      --prefix PATH : "${lib.makeBinPath [ nix virt-manager-without-menu ]}"
  '';

  meta = {
    description = "Nix-based app VMs";
    homepage = "https://code.dumpstack.io/tools/${pname}";
    maintainers = [ lib.maintainers.dump_stack lib.maintainers.cab404 ];
    license = lib.licenses.gpl3;
  };
}
