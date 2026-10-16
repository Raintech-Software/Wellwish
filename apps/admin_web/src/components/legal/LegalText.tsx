import { Typography } from "antd";
import type { ReactNode } from "react";

/**
 * The legal pages' text format (ARCHITECTURE §6.20), shown as the public page shows it: a line
 * starting with "# " is a heading, "- " a bullet, a blank line starts a new paragraph,
 * **words** are bold. Built as React elements, never as HTML.
 */
export const FORMAT_HELP =
  'Plain text. A line starting with "# " is a heading, "- " a bullet; a blank line starts a new paragraph; **words** are bold.';

export const LANGUAGE_NAMES: Record<string, string> = { en: "English", hi: "हिन्दी", or: "ଓଡ଼ିଆ" };

type Block = { kind: "h" | "p" | "ul"; items: string[] };

function blocks(text: string): Block[] {
  const out: Block[] = [];
  let paragraph: string[] = [];
  let bullets: string[] = [];
  const flush = () => {
    if (paragraph.length) out.push({ kind: "p", items: [paragraph.join(" ")] });
    if (bullets.length) out.push({ kind: "ul", items: bullets });
    paragraph = [];
    bullets = [];
  };
  for (const raw of text.replace(/\r\n?/g, "\n").split("\n")) {
    const line = raw.trim();
    if (!line) flush();
    else if (line.startsWith("# ")) {
      flush();
      out.push({ kind: "h", items: [line.slice(2).trim()] });
    } else if (line.startsWith("- ")) {
      if (paragraph.length) flush();
      bullets.push(line.slice(2).trim());
    } else {
      if (bullets.length) flush();
      paragraph.push(line);
    }
  }
  flush();
  return out;
}

function inline(text: string): ReactNode[] {
  return text.split(/(\*\*.+?\*\*)/g).map((part, i) =>
    part.startsWith("**") && part.endsWith("**") && part.length > 4 ? <strong key={i}>{part.slice(2, -2)}</strong> : part,
  );
}

export default function LegalText({ text, lang }: { text: string; lang?: string }) {
  return (
    <div lang={lang} style={{ lineHeight: 1.6 }}>
      {blocks(text).map((block, i) =>
        block.kind === "h" ? (
          <Typography.Title key={i} level={5} style={{ marginTop: 16 }}>
            {inline(block.items[0])}
          </Typography.Title>
        ) : block.kind === "ul" ? (
          <ul key={i} style={{ paddingLeft: 22 }}>
            {block.items.map((item, j) => (
              <li key={j}>{inline(item)}</li>
            ))}
          </ul>
        ) : (
          <p key={i}>{inline(block.items[0])}</p>
        ),
      )}
    </div>
  );
}
