"""The legal pages' text format (ARCHITECTURE §6.20): plain text, no HTML.

- a line starting with `# ` is a heading;
- lines starting with `- ` make a bulleted list;
- a blank line starts a new paragraph (other lines of a paragraph are joined);
- `**words**` are bold.

Everything is escaped before the bold is added, so a page can never carry HTML or a script.
"""

import re
from dataclasses import dataclass

from django.utils.html import escape
from django.utils.safestring import SafeString, mark_safe

_BOLD = re.compile(r"\*\*(.+?)\*\*")


@dataclass(frozen=True)
class Block:
    kind: str  # "h" (heading), "p" (paragraph) or "ul" (list)
    items: tuple[SafeString, ...]  # one item for "h" and "p"


def inline(text: str) -> SafeString:
    return mark_safe(_BOLD.sub(r"<strong>\1</strong>", escape(text)))  # noqa: S308 (escaped first)


def clean(text: str) -> str:
    """Same line endings everywhere, no trailing spaces, no blank lines at the ends."""
    lines = [line.rstrip() for line in text.replace("\r\n", "\n").replace("\r", "\n").split("\n")]
    return "\n".join(lines).strip("\n")


def blocks(text: str) -> list[Block]:
    out: list[Block] = []
    paragraph: list[str] = []
    bullets: list[str] = []

    def flush() -> None:
        if paragraph:
            out.append(Block("p", (inline(" ".join(paragraph)),)))
            paragraph.clear()
        if bullets:
            out.append(Block("ul", tuple(inline(b) for b in bullets)))
            bullets.clear()

    for raw in clean(text).split("\n"):
        line = raw.strip()
        if not line:
            flush()
        elif line.startswith("# "):
            flush()
            out.append(Block("h", (inline(line[2:].strip()),)))
        elif line.startswith("- "):
            if paragraph:
                flush()
            bullets.append(line[2:].strip())
        else:
            if bullets:
                flush()
            paragraph.append(line)
    flush()
    return out
