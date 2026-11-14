class Ssync < Formula
  desc "Move AI agent skills into ~/.agents/skills and symlink them back"
  homepage "https://github.com/nickchef/ssync"
  url "https://github.com/nickchef/ssync/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6ec0bb77fc61e6a9d5d8dc2589e210c9370caa27c7c35fd167b61515d5cb198f"
  head "https://github.com/nickchef/ssync.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssync version")
    ENV["HOME"] = testpath
    (testpath/".claude/skills/demo/SKILL.md").write "# demo"
    system bin/"ssync", "apply", "-y"
    assert_predicate testpath/".claude/skills/demo", :symlink?
    assert_predicate testpath/".agents/skills/demo/SKILL.md", :exist?
  end
end
