class FriskyPaperclip < Formula
  desc "FR!sky Paperclip — the agent desk"
  homepage "https://clip.friskydev.com"
  url "https://raw.githubusercontent.com/FriskyDevelopments/homebrew-paperclip/main/cmd/paperclip"
  sha256 "d70a1d81142c9014ff4a639b628a6a50068a93f85d1d8acc067605ac36bc6e07"
  version "0.1.1"
  license :cannot_represent

  def install
    bin.install "paperclip"
  end

  def caveats
    <<~EOS
      Seat key arrives by Whop email (FRSKY-PC-…).
      Pay: https://whop.com/checkout/plan_4WRbqNWxmh5SG
      Run: paperclip
    EOS
  end

  test do
    assert_match "paperclip", shell_output("#{bin}/paperclip --version")
  end
end
