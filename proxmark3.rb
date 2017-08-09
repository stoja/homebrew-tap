class Proxmark3 < Formula
  desc "Proxmark3 client, flasher, HID flasher and firmware bundle"
  homepage "http://www.proxmark.org"
  url "https://github.com/stoja/proxmark3/archive/master.tar.gz"
  head "https://github.com/stoja/proxmark3.git"

  depends_on "automake" => :build
  depends_on "readline"
  depends_on "p7zip" => :build
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "pkg-config" => :build
  depends_on "wget"
  depends_on "chrisfu/tap/arm-none-eabi-gcc" => :build

  def install
    ENV.deparallelize

    system "make", "-C", "client/hid-flasher/"
    system "make", "all", "clean"
    system "make"
    bin.mkpath
    bin.install "client/flasher" => "proxmark3-flasher"
    bin.install "client/hid-flasher/flasher" => "proxmark3-hid-flasher"
    bin.install "client/proxmark3" => "proxmark3"
    bin.install "client/fpga_compress" => "fpga_compress"
    share.mkpath
    (share/"firmware").mkpath
    (share/"firmware").install "armsrc/obj/fullimage.elf" => "fullimage.elf"
    (share/"firmware").install "bootrom/obj/bootrom.elf" => "bootrom.elf"
    ohai "Install success! Upgrade devices on HID firmware with proxmark3-hid-flasher, or devices on more modern firmware with proxmark3-flasher."
    ohai "The latest bootloader and firmware binaries are ready and waiting in the current homebrew Cellar within share/firmware."
  end

  test do
    system "proxmark3", "-h"
  end
end
