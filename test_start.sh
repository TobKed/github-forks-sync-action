#!/bin/sh
# Asserts start.sh turns the force/tags inputs into the right git push flags.
# Uses a stub `git` on PATH, so no token and no network are needed.
set -e

here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/bin"

cat > "$tmp/bin/git" <<'STUB'
#!/bin/sh
echo "git $*" >> "$GIT_LOG"
# `clone` must leave behind the directory start.sh cds into
[ "$1" = "clone" ] && mkdir -p "$(basename "$2" .git)"
exit 0
STUB
chmod +x "$tmp/bin/git"

# Prints the push command start.sh would run for the given env.
push_cmd() {
    GIT_LOG="$tmp/log"; export GIT_LOG; : > "$GIT_LOG"
    (
        cd "$tmp"
        PATH="$tmp/bin:$PATH" \
        INPUT_GITHUB_TOKEN=dummy \
        INPUT_UPSTREAM_REPOSITORY=owner/repo \
        env "$@" sh "$here/start.sh" > /dev/null
    )
    grep '^git push' "$GIT_LOG"
}

assert_has() {
    case "$1" in
        *"$2"*) ;;
        *) echo "FAIL: expected '$2' in: $1" >&2; exit 1 ;;
    esac
}

assert_lacks() {
    case "$1" in
        *"$2"*) echo "FAIL: unexpected '$2' in: $1" >&2; exit 1 ;;
    esac
}

out=$(push_cmd)
assert_lacks "$out" "--force"
assert_lacks "$out" "--tags"

out=$(push_cmd INPUT_FORCE=true INPUT_TAGS=true)
assert_has "$out" "--force"
assert_has "$out" "--follow-tags --tags"

# A non-"true" value must be inert. These used to be *executed* as commands,
# so INPUT_FORCE=yes ran `yes` and hung the job forever.
for value in yes 1 True false ''; do
    out=$(push_cmd "INPUT_FORCE=$value" "INPUT_TAGS=$value")
    assert_lacks "$out" "--force"
    assert_lacks "$out" "--tags"
done

echo "start.sh flag handling: OK"
