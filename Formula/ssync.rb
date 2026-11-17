class Ssync < Formula
  desc "Centralize AI agent skills in ~/.agents/skills"
  homepage "https://github.com/nickchef/ssync"
  url "https://github.com/nickchef/ssync/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "34fa64c0c517c5b5bf0ff794b47de94dda449e52e39711075f247cb707132492"
  head "https://github.com/nickchef/ssync.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssync version")
    ENV["HOME"] = testpath
    (testpath/".claude/skills/demo/SKILL.md").write "# demo"
    system bin/"ssync", "apply", "-y"
    assert_predicate testpath/".claude/skills", :symlink?
    assert_predicate testpath/".agents/skills/demo/SKILL.md", :exist?
  end
end
