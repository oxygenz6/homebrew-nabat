class DnscryptProxy2 < Formula
  desc "Flexible DNS proxy, with support for encrypted DNS protocols"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/refs/tags/2.1.4.tar.gz"
  sha256 "05f0a3e8c8f489caf95919e2a75a1ec4598edd3428d2b9dd357caba6adb2607d"
  license ""

  depends_on "go" => :build

  def install
    system "cd", "dnscrypt-proxy"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "false"
  end
end
