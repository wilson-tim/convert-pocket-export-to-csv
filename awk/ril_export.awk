# 05/03/2024  TW  Script to parse Pocket export html file

# $ awk -f ril_export.awk ril_export.html > ril_export.txt

# <li><a href="https://blog.gitbutler.com/git-worktrees/" time_added="1709623546" tags="git">https://blog.gitbutler.com/git-worktrees/</a></li>
# <li><a href="https://forum.obsidian.md/t/how-to-disable-line-wrapping-in-code-blocks/69900" time_added="1709582786" tags="note taking">How to disable line-wrapping in code blocks? - Help - Obsidian Forum</a></li>

BEGIN {
	print "time_added\ttitle\ttags\thref"
}

href=""
dt=""
tags=""
title=""

# href
match($0, /href="[^"]+"/) {
	href=substr($0, RSTART+6, RLENGTH-7);
}

# timestamp
match($0, /time_added="[0-9][^"]+"/) {
	dt=substr($0, RSTART+12, RLENGTH-13);
	gsub(dt, strftime("%Y-%m-%d %H:%M:%S", dt), dt);
}

# tags
match($0, /tags="[^"]+"/) {
	tags=substr($0, RSTART+6, RLENGTH-7);
}

# title
match($0, /">[^<]+<\/a/) {
	title=substr($0, RSTART+2, RLENGTH-5);
# There is a u200d (ZWJ) character between the question marks in the next line
	gsub(/\?‍\?/, "", title)
}

{
	if (href!="") {
		print dt "\t" title "\t" tags "\t" href
	}
}
