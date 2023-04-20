class DnscryptProxy2 < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.info"
  url "https://github.com/DNSCrypt/dnscrypt-proxy/archive/2.1.4.tar.gz"
  sha256 "05f0a3e8c8f489caf95919e2a75a1ec4598edd3428d2b9dd357caba6adb2607d"
  license "ISC"
  head "https://github.com/DNSCrypt/dnscrypt-proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    cd "dnscrypt-proxy" do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             sbin / "dnscrypt-proxy2"
      pkgshare.install Dir["example*"]
      etc.install pkgshare / "example-dnscrypt-proxy.toml" => "dnscrypt-proxy2.toml"
    end
  end

  def caveats
    <<~EOS
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      balancing traffic across a set of resolvers. If you would like to
      change these settings, you will have to edit the configuration file:
        #{etc}/dnscrypt-proxy2.toml

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

        sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

       resolver.dnscrypt.info
    EOS
  end

  service do
    run [opt_sbin / "dnscrypt-proxy2", "-config", etc / "dnscrypt-proxy2.toml"]
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dnscrypt-proxy2 --version")

    config = "-config #{etc}/dnscrypt-proxy2.toml"
    output = shell_output("#{sbin}/dnscrypt-proxy2 #{config} -list 2>&1")
    assert_match "Source [public-resolvers] loaded", output
  end
end
