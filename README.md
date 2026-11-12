# pkill -f kills more than you expect

A real Node.js server (`api-server.js`) and a second, unrelated Node.js script that happens to
share the same filename in a different folder. `pkill -f api-server.js` matches the full command
line of both background processes and kills them together, even though they have nothing to do
with each other. This repo reproduces that collision and shows three safer alternatives:
previewing matches with `pgrep -af` first, killing by a recorded pid, and anchoring the pattern to
one exact command line.

    docker build -t pkill-f-wrong-process .
    docker run --rm pkill-f-wrong-process
