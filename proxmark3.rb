class Proxmark3 < Formula
  desc "RRG/Iceman Proxmark3 client, CDC flasher and firmware bundle"
  homepage "http://www.proxmark.org/"
  head do
    if ENV.has_key?('HOMEBREW_TRAVIS_COMMIT')
      url "https://github.com/lucyxss/proxmark3.git", :branch => "#{ENV['HOMEBREW_TRAVIS_BRANCH']}", :revision => "#{ENV['HOMEBREW_TRAVIS_COMMIT']}"
    else
      url "https://github.com/lucyxss/proxmark3.git"
    end
  end

  depends_on "readline"
  depends_on "pkg-config" => :build
  depends_on "openssl@3" => :build
  depends_on "qt5" => :recommended
  depends_on "./arm-none-eabi-gcc" => :build

  option "with-blueshark", "Enable Blueshark (BT Addon) support"

  def install
    ENV.deparallelize

    if not ENV.has_key?('HOMEBREW_PROXMARK3_PLATFORM')
      ENV['HOMEBREW_PROXMARK3_PLATFORM'] = 'PM3RDV4'
    end

    system "make", "clean"
    if build.with? "blueshark"
      system "make", "all", "PLATFORM=#{ENV['HOMEBREW_PROXMARK3_PLATFORM']}", "PLATFORM_EXTRAS=BTADDON"
    else
      system "make", "all", "PLATFORM=#{ENV['HOMEBREW_PROXMARK3_PLATFORM']}"
    end

    system "make", "install", "PREFIX=#{prefix}", "PLATFORM=#{ENV['HOMEBREW_PROXMARK3_PLATFORM']}"

    ohai "Install success!"
    ohai "The latest bootloader and firmware binaries are ready and waiting in the current homebrew Cellar within share/firmware."
  end

  test do
    system "proxmark3", "-h"
  end
end
