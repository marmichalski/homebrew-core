class Libxcomposite < Formula
  desc "X.Org: Client library for the Composite extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcomposite-0.4.5.tar.bz2"
  sha256 "b3218a2c15bab8035d16810df5b8251ffc7132ff3aa70651a1fba0bfe9634e8f"
  license "MIT"

  bottle do
    cellar :any
    sha256 "3b8b0780e6c95393d9a6d56739ecc501b183d462009544c45d89293850c2ccf6" => :catalina
    sha256 "5332e3ec89bac3372540513a9b54b3ba1d5f4bbe0dfe233d8297a4fbc6168d98" => :mojave
    sha256 "4571cc99283062d9f242fcad7bbabb32ea687974723eaa0289639d018393ff61" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libxfixes"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/extensions/Xcomposite.h"

      int main(int argc, char* argv[]) {
        Display *d = NULL;
        int s = DefaultScreen(d);
        Window root = RootWindow(d, s);
        XCompositeReleaseOverlayWindow(d, s);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lXcomposite", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
