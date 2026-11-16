# FreeSlate

Tools for making Slate (Technolutions) pages at Washington State University look and behave like the WSU Web Design System 2.x. Everything here is deterministic: no AI runs in any of these files, and every change the cleaner makes is listed with the rule that made it.

Build of 2026-11-16, source commit `a7d769e` on the `html-cleaner` branch.

## The files

| File | What it is | How to use it |
|---|---|---|
| `FreeSlate.html` | The whole tool in one self-contained page: the Slate HTML Cleaner, the bookmark builder, and all the documentation. | Download it and open it in any browser. Nothing you paste leaves the page. |
| `build.xslt` | Slate Branding Editor template, version 3.0.21. | Paste into the Branding Editor's `build.xslt`. |
| `build.css` | The stylesheet that goes with it. Slate serves it as `/shared/build.css`. | Paste into the Branding Editor's `build.css`. |
| `install.html` | The "WSU tools" bookmark with the standard settings. | Open it and drag the link to your bookmarks bar. |
| `source/` | The source: C# cleaner, tests, samples, the JavaScript port, the bookmark code, the build scripts, the evidence scripts and research notes. | Only needed to change or rebuild the tools. |

## FreeSlate.html

Paste HTML from a Slate editor's Source view into **Original**. The cleaned version appears at once, with a list of what was fixed and what needs a person to review. Copy the result back into Slate.

The cleaner removes inline styles, `<font>` tags, typed bullets, `<br><br>` stacks and similar leftovers so the design system's own styles apply. It never changes the words. A paragraph tag is added only where it fixes something; plain text and question labels are left alone.

Tabs: Three panes, Device check, Slate editor bookmark, About, XSLT & CSS, Troubleshooting, Learning path, Design guide, Documents. Start with **About**: it explains how the pieces fit together, first briefly and then in technical detail.

## build.xslt and build.css

`build.xslt` links `/shared/build.css?v=3.0.21` at the end of `<head>`, so it loads after Slate's own stylesheets. Deploy in this order:

1. Branding Editor, `build.css`: paste, **Save**, then **Publish Changes**.
2. Branding Editor, `build.xslt`: paste, **Save**, then **Publish Changes**.
3. View the source of a public page. It should show `WSU build.xslt 3.0.21` and `/shared/build.css?v=3.0.21`.

When `build.css` changes, raise `brandVersion` in `build.xslt` as well. Slate caches `/shared/` files for 24 hours, and published branding can take a while to reach a signed-in session. A hard refresh helps.

Every colour in `build.css` is written once, in a palette at the top of the file, under the name its official source gives it and with a link to that source: the WSU Web Design System's source palette and published stylesheet, Slate's own default, or the WSU Spine. Everything below the palette uses `var(--name)`; no colour value appears anywhere else. To use a new colour, add it to the palette with its source first. The evidence for each one, including live `*.wsu.edu` pages, is in the **XSLT & CSS** tab of `FreeSlate.html`.

## install.html (the WSU tools bookmark)

A bookmarklet for Slate's Edit Field dialog. It adds **Clean**, **Format**, **Pop-up** and **WSU look** buttons to the CKEditor toolbar, makes the editor taller, and adds a drag handle to resize it. It uses only Slate's own mechanisms and adds no script to saved content.

To change which buttons and rules it has, open `FreeSlate.html`, go to **Slate editor bookmark**, adjust the settings and save a new `install.html`. The bookmark is 60,858 characters, under Firefox's 65,536 limit.

## Building from source

The `source/` folder is the `tools/HtmlCleaner` folder of the working repository. Run these from inside it.

```
dotnet test tests/FreeSlate.HtmlCleaner.Tests        # 154 tests
bookmarklet/build.sh                                  # cleaner.js + editor.js -> wsu-editor-tools.min.js (terser 5.31.6)
python3 standalone/build.py <assets dir> <a Slate page rendered through build.xslt> <version>   # -> standalone/FreeSlate.html
```

The JavaScript cleaner (`standalone/cleaner.js`) must produce the same output as the C# reference (`src/FreeSlate.HtmlCleaner/SlateHtmlCleaner.cs`) byte for byte. `standalone/parity.html` checks this against all 31 samples, with default rules and with every rule on. `source/README.md` has the details.

The sample snippets in `source/samples/` are real Slate content with identifying details replaced: one staff name is removed and the tracking data inside one Outlook SafeLinks URL is zeroed.

## Related repositories

- `WSU-EIT/freeslate`: where the Slate branding lives.
- `WSU-EIT/freeai`: the accessibility scanners whose saved WSU pages are the evidence base.
- `wsuwebteam/web-design-system`: the WSU Web Design System source.

## Licence

MIT, the same as `WSU-EIT/freeslate`. Copyright (c) 2026 WSU Enrollment IT.
