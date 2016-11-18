class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://github.com/laurentj/slimerjs/archive/0.10.1.tar.gz"
  sha256 "940c4459821610a399b967a48d109d45cfa546ec347c109bb88330e17f3a2979"
  head "https://github.com/laurentj/slimerjs.git"

  bottle :unneeded

  def install
    cd "src" do
      system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                    "defaults/", "chrome.manifest", "-x@package_exclude.lst"
      libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
    end
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats; <<-EOS.undent
    SlimerJS may need some configurations before using:
      https://docs.slimerjs.org/current/installation.html

    The configuration file is placed in:
      #{libexec}/application.ini
    EOS
  end

  test do
    if File.exist? "/Applications/Firefox.app/Contents/MacOS/firefox"
      (testpath/"test.js").write <<-EOS.undent
        console.log("hello");
        slimer.exit();
      EOS
      assert_match "hello", shell_output("#{bin}/slimerjs test.js", 0)
    else
      assert_match "Set it with the path to Firefox", shell_output("#{bin}/slimerjs test.js", 1)
    end
  end
end
