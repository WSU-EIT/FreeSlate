// ════════════════════════════════════════════════════════════════════════
// FreeSlate Documentation Generator
// Captures screenshots of every tweakable setting in the "Tune the kit"
// configurator, then assembles usermanual.md with inline base64 images.
//
// Usage:  dotnet run [-- <path-to-index.html>]
// Default: serves ../index.html on a local HTTP server, captures all 40
// tune-card screenshots, then generates ../usermanual.md.
// ════════════════════════════════════════════════════════════════════════
using System.Net;
using System.Text;
using Microsoft.Playwright;

// All 40 settings in display order, matching wsu-eit-showcase.js SPEC[]
var Settings = new SettingInfo[]
{
    // ── TYPE ──
    new("bodysize", "Type", "Body text size", "range",
        "Base reading size for all paragraph text. Controls the default font-size for body copy across the entire form.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/resize-text.html",
        "--wsu-eit-body-size", "1rem (16px)",
        "WCAG 1.4.4 Resize Text requires text to scale to 200% without loss of content. The kit uses rem units so browser zoom works natively. Setting this below 16px risks failing WCAG AA for users who haven't adjusted their browser defaults.",
        "Users with low vision rely on browser font-size settings. Using rem (relative to root) means this token respects those preferences. Never set body text below 15px — research shows 16px is the minimum comfortable reading size on screens."),
    new("line", "Type", "Reading line-height", "range",
        "Vertical space between lines of paragraph text. Affects readability of multi-line content blocks.",
        "https://www.w3schools.com/cssref/pr_dim_line-height.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/visual-presentation.html",
        "--wsu-eit-line", "1.55",
        "WCAG 1.4.12 Text Spacing requires that line-height can be set to at least 1.5x font size without loss of content. The kit's default of 1.55 already exceeds this. Reducing below 1.4 makes dense paragraphs harder to track for users with dyslexia or cognitive disabilities.",
        "Tight line-heights (below 1.3) cause lines to visually merge for users with tracking difficulties. The 1.5-1.6 range is the research-backed sweet spot for body copy. Headings can go tighter (1.1-1.2) because they're short."),
    new("bodyink", "Type", "Body text color", "choice",
        "The ink color for all body copy. All offered choices pass WCAG AA contrast on white backgrounds.",
        "https://www.w3schools.com/cssref/pr_text_color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html",
        "--wsu-eit-body", "#262626",
        "WCAG 1.4.3 Contrast (Minimum) requires 4.5:1 for normal text, 3:1 for large text. The default #262626 delivers ~13.5:1 against white — AAA level. Even the 'Soft gray' option (#3a3a3a) provides ~9:1, still AAA. Never use body text lighter than #595959 on white (fails AA).",
        "Pure black (#000000) on pure white (#ffffff) creates maximum contrast but can cause eye strain for extended reading ('halation' effect). The near-black #262626 softens this while still clearing AAA by a wide margin."),
    new("linksize", "Type", "Link text size", "range",
        "Minimum rendered size for hyperlinks. Links never shrink below this floor, ensuring they remain tappable and readable.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/target-size-enhanced.html",
        "--wsu-eit-link-size", "16px (1rem)",
        "Larger link text improves both readability and target size. WCAG 2.5.5 (Target Size Enhanced, AAA) recommends 44x44px touch targets. While this controls text size not hit area, larger text naturally creates larger clickable regions.",
        "Links at 14px or smaller become difficult to tap on mobile devices. The 16px floor ensures links are always at least as large as body text, maintaining visual hierarchy and touch accessibility."),
    new("linkweight", "Type", "Link weight", "choice",
        "Font weight of hyperlinks. Semibold (600) is the shipped default — makes links visually distinct from surrounding body text without needing color alone.",
        "https://www.w3schools.com/cssref/pr_font_weight.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html",
        "--wsu-eit-link-weight", "600 (Semibold)",
        "WCAG 1.4.1 Use of Color states links cannot be distinguished from surrounding text by color alone. The kit uses underline + weight to provide multiple visual cues. If you set weight to Regular (400), the underline becomes the sole non-color differentiator — ensure it remains visible.",
        "Semibold links create a subtle but scannable visual rhythm in paragraphs. Bold (700) draws more attention but can feel heavy in dense copy. Regular (400) relies entirely on the underline — fine if underlines are always present."),
    new("underline", "Type", "Link underline", "range",
        "Thickness of the underline beneath hyperlinks. This is the primary non-color indicator that text is a link.",
        "https://www.w3schools.com/cssref/css3_pr_text-decoration-thickness.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html",
        "--wsu-eit-underline", "1px",
        "WCAG 1.4.1 Use of Color: links must be identifiable without relying on color perception alone. The underline is the universal link affordance. Setting to 0 removes it — acceptable ONLY if link weight provides a 3:1 luminance contrast ratio against surrounding text (per WCAG technique G183).",
        "Removing underlines entirely is a common a11y mistake. The 1px default is subtle but clear. 2-3px creates a bolder 'highlighter' effect that some brands prefer. Thicker underlines can interfere with descenders (g, p, y) — use the offset setting to compensate."),
    new("underlineoffset", "Type", "Underline offset", "range",
        "Gap between link text baseline and the underline. Prevents the underline from clipping through descending letters like g, p, y.",
        "https://www.w3schools.com/cssref/css3_pr_text-underline-offset.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/text-spacing.html",
        "--wsu-eit-underline-offset", "0.18em",
        "While not directly a WCAG requirement, proper offset prevents the underline from making descenders unreadable. A too-large offset (>0.3em) can make the underline look disconnected from its text, confusing users about what's clickable.",
        "The em unit means offset scales with text size automatically. 0.18em works well for Montserrat; fonts with longer descenders may need more."),
    new("measure", "Type", "Paragraph width", "range",
        "Maximum line length (measure) for body text. Controls how wide paragraphs grow before wrapping. Expressed in 'ch' units (width of the '0' character).",
        "https://www.w3schools.com/cssref/pr_dim_max-width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/visual-presentation.html",
        "--wsu-eit-measure", "75ch",
        "WCAG 1.4.8 Visual Presentation (AAA) recommends no more than 80 characters per line. The default 75ch keeps text within this guideline. 'Off' removes the cap entirely — text runs full-width, often exceeding 120+ characters on wide screens, severely degrading readability.",
        "Research (Baymard Institute, NNGroup) consistently shows 50-75 characters per line is optimal for reading comprehension. Shorter lines (45-55ch) suit narrow columns; wider (80-90ch) suits data-heavy content. The 'ch' unit adapts to font changes automatically."),
    new("h1bar", "Type", "H1 crimson bar", "range",
        "Height of the signature crimson rule that appears beneath page titles (H1 headings). A distinctive WSU brand cue.",
        "https://www.w3schools.com/cssref/pr_border-bottom.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/info-and-relationships.html",
        "--wsu-eit-h1-bar", "4px",
        "The bar is decorative — it doesn't convey information. Screen readers skip it entirely (it's rendered via CSS ::after with no content). Setting to 0 removes the brand cue but has no accessibility impact. The bar's crimson color meets non-text contrast requirements (3:1+ against white).",
        "This mimics the heading treatment on wsu.edu and admission.wsu.edu. It signals 'you're on a WSU page' to sighted users. The thickness range (0-12px) stays proportional to heading text."),
    new("h1barstyle", "Type", "Bar length", "choice",
        "Whether the H1 crimson bar spans the full heading width or renders as a short 'tick' mark. The centered tick is the WSU callout heading style.",
        "https://www.w3schools.com/cssref/pr_dim_width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/meaningful-sequence.html",
        "--wsu-eit-h1-bar-width", "100% (Full underline)",
        "No direct a11y impact — purely decorative. The short tick (3.5rem) draws the eye to centered headings; the full underline creates clear visual separation between the heading and content below.",
        "Choose 'Full underline' for left-aligned headings (standard forms). Choose 'Short tick' for centered headings (landing pages, event pages) — it matches WSU's callout heading treatment."),
    new("headalign", "Type", "Heading alignment", "choice",
        "Text alignment for page headings. 'Centered' also centers the crimson bar, creating the WSU 'callout heading' look.",
        "https://www.w3schools.com/cssref/pr_text_text-align.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/visual-presentation.html",
        "--wsu-eit-head-align + --wsu-eit-h1-bar-mx", "left",
        "WCAG 1.4.8 recommends left-aligned text for LTR languages. Centered text is harder to track across multiple lines. For headings (typically 1-2 lines) centering is acceptable, but for multi-line headings, left alignment improves scanability for users with cognitive or visual disabilities.",
        "Left alignment suits form pages (users scan down a left edge). Centered alignment suits landing/event pages where the heading is a focal point."),
    new("h1weight", "Type", "H1 weight", "choice",
        "Font weight of the page title (H1). Controls how bold/heavy the main heading appears.",
        "https://www.w3schools.com/cssref/pr_font_weight.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/info-and-relationships.html",
        "--wsu-eit-h1-weight", "800 (Extrabold)",
        "Heavier weights make headings more visually distinct from body text, reinforcing the document hierarchy for sighted users. Screen readers announce heading level regardless of visual weight. If weight is too light (400), sighted users may not perceive the heading as a heading, creating a disconnect between visual and semantic structure.",
        "Extrabold (800) is the WSU brand standard for display text. Bold (700) is slightly subtler. Black (900) is the maximum available in Montserrat."),
    new("headcolor", "Type", "Heading color", "choice",
        "Color of H2/H3 section headings. Choose between near-black (matching body) or crimson (brand accent).",
        "https://www.w3schools.com/cssref/pr_text_color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html",
        "--wsu-eit-head-color", "var(--wsu-eit-body) (Black)",
        "Both options pass WCAG AA for large text (headings qualify as large text at >=18.7px bold). Crimson #A60F2D provides ~7.4:1 on white (AAA). The black option (#262626) provides ~13.5:1 (AAA). Both are safe choices.",
        "Crimson headings create a stronger brand presence but can feel heavy in forms with many sections. Black headings feel neutral and professional. Consider crimson for marketing pages (events, landing) and black for functional forms (applications, registrations)."),
    new("h2size", "Type", "H2 size", "range",
        "Font size of major section headings (H2). These divide the form into logical chunks.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/resize-text.html",
        "--wsu-eit-h2-size", "1.45rem (~23px)",
        "Heading sizes must maintain a clear hierarchy: H1 > H2 > H3 > body. If H2 is too close to body size, the document structure becomes unclear to sighted users. The rem unit ensures headings scale with browser zoom (WCAG 1.4.4).",
        "The range (1.2-1.85rem) keeps H2 visually distinct from both H1 above and H3 below. A modular scale (each level ~1.2x the next) creates natural rhythm."),
    new("h3size", "Type", "H3 size", "range",
        "Font size of sub-headings (H3). Auto-capped to stay below H2 — a sub-heading never visually outsizes its parent.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/info-and-relationships.html",
        "--wsu-eit-h3-size", "1.15rem (~18px)",
        "WCAG 1.3.1 requires that heading hierarchy is programmatically determinable. Visual sizing should match semantic level — if H3 looks bigger than H2, sighted users get a false hierarchy cue. The auto-cap enforces this.",
        "The dynamic maximum (always < H2) prevents configuration mistakes. If you shrink H2, H3 automatically shrinks to stay subordinate."),
    new("headline", "Type", "Heading line-height", "range",
        "Line spacing within multi-line headings. Tighter than body text because headings are short and benefit from compact vertical rhythm.",
        "https://www.w3schools.com/cssref/pr_dim_line-height.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/text-spacing.html",
        "--wsu-eit-head-line", "1.18",
        "WCAG 1.4.12 allows line-height override to 1.5x on all text. The kit's heading line-height is intentionally tight (display use) but will expand if a user applies a 1.5x override via browser extension — the layout doesn't break.",
        "Headings at 1.05 feel tight and modern (magazine style). At 1.4 they feel spacious and formal. The default 1.18 balances brand with readability."),
    new("headtrack", "Type", "Heading letter-spacing", "range",
        "Tracking (letter-spacing) on headings. Negative values tighten letters; positive values spread them apart.",
        "https://www.w3schools.com/cssref/pr_text_letter-spacing.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/text-spacing.html",
        "--wsu-eit-head-track", "0em (normal)",
        "WCAG 1.4.12 Text Spacing requires letter-spacing can be set to at least 0.12em without breaking layout. The kit respects user overrides. Negative tracking (tightening) can make text harder to read for users with dyslexia — use sparingly and only on large display headings.",
        "Tight tracking (-0.02em) creates a modern, dense feel. Positive tracking (+0.04em) reads more formal/editorial. Extreme values in either direction hurt legibility."),

    // ── SHAPE & DENSITY ──
    new("round", "Shape & density", "Corner radius", "range",
        "Border radius on inputs, buttons, callout boxes, and other interactive elements. Controls the overall geometric feel — sharp vs. soft.",
        "https://www.w3schools.com/cssref/css3_pr_border-radius.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-round", "6px",
        "No direct WCAG requirement for corner radius. However, extremely rounded inputs (>16px) can reduce the perceived clickable area, as users may not realize the corners are part of the input. The 0-24px range keeps all controls clearly identifiable as form elements.",
        "0px = sharp, institutional, 'government form' feel. 6px = subtle softness (the WSU default). 12-24px = friendly, modern, 'startup' feel. Match the rest of your institution's digital properties for consistency."),
    new("inputborder", "Shape & density", "Input border width", "range",
        "Thickness of the border around text fields, selects, and textareas. The sole visual boundary of form controls.",
        "https://www.w3schools.com/cssref/pr_border-width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-input-border", "1px",
        "WCAG 1.4.11 Non-text Contrast requires UI components to have at least 3:1 contrast against adjacent colors. The kit's border color (#767676) provides 4.5:1 against white. Setting border to 0 removes the visual boundary entirely — the field becomes invisible to users who rely on border cues, violating 1.4.11.",
        "1px is standard and clean. 2px adds weight and visibility (helpful for users with low vision). 3px is bold/decorative. Never set to 0 unless the field has a background fill that provides the required contrast."),
    new("inputbg", "Shape & density", "Field fill", "choice",
        "Background color inside text fields. 'Mist gray' adds a subtle tint that distinguishes inputs from the page background.",
        "https://www.w3schools.com/cssref/pr_background-color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-input-bg", "var(--wsu-eit-paper) (White)",
        "A filled background can serve as a secondary boundary cue, helping identify fields even if borders are thin. However, the fill color must maintain sufficient contrast with text typed into the field. Both options (white, mist gray) provide excellent contrast with dark text.",
        "White fields on a white page rely entirely on borders for identification. Mist-gray fields are self-evident even without a border — useful if you want a borderless modern look while maintaining a11y."),
    new("btnsize", "Shape & density", "Button size", "choice",
        "Padding inside primary action buttons (Submit, CTA links). Controls how much space surrounds the button label text.",
        "https://www.w3schools.com/cssref/pr_padding.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/target-size-enhanced.html",
        "--wsu-eit-btn-pad-y / --wsu-eit-btn-pad-x", "Standard (.75rem / 2rem)",
        "WCAG 2.5.5 Target Size (Enhanced, AAA) requires 44x44px minimum touch targets. All three sizes meet this for typical button text. 'Compact' may fall below 44px height with short labels on high-DPI screens — test on actual devices.",
        "Compact suits dense interfaces with many actions. Standard is the universal safe choice. Large suits hero CTAs where you want one dominant action (like 'Start application')."),
    new("btnborder", "Shape & density", "Button border", "range",
        "The border ringing buttons. Uses the same crimson as the button fill, creating a solid-looking button even at small sizes.",
        "https://www.w3schools.com/cssref/pr_border-width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-btn-border", "2px",
        "The border adds to the button's visual footprint and provides a crisp edge that helps it stand out from surrounding content. At 0px the button relies solely on its background fill — still accessible as long as the fill color contrasts with the page (crimson on white = 7.4:1).",
        "2px is the WSU default — provides a definitive edge. 0px creates a 'flat' modern button. 4px creates a thick frame effect."),
    new("btnweight", "Shape & density", "Button weight", "choice",
        "Font weight of button label text. Affects how prominent and readable the button's call-to-action text appears.",
        "https://www.w3schools.com/cssref/pr_font_weight.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html",
        "--wsu-eit-btn-weight", "600 (Semibold)",
        "White text on crimson buttons meets WCAG AA for large text at all offered weights. Heavier weights improve legibility at small sizes and are easier to read for users with low vision.",
        "Medium (500) feels light and modern. Semibold (600) is the shipped standard — clear without being heavy. Bold (700) adds extra emphasis."),
    new("btncase", "Shape & density", "Button text case", "choice",
        "Whether button labels render in normal sentence case or are transformed to UPPERCASE. Uppercase adds letter-spacing automatically for legibility.",
        "https://www.w3schools.com/cssref/pr_text_text-transform.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/reading-level.html",
        "--wsu-eit-btn-transform + --wsu-eit-btn-track", "none (Normal case)",
        "UPPERCASE text is harder to read because word shapes become uniform rectangles — readers lose the ascender/descender cues that speed recognition. For short button labels (2-4 words) this isn't a significant barrier, but avoid uppercase on buttons with long labels. Screen readers announce the text normally regardless of CSS text-transform.",
        "Normal case is friendlier and more readable. UPPERCASE reads as more formal/institutional. The kit automatically adds letter-spacing (0.06em) when uppercase is active to compensate for the density."),
    new("density", "Shape & density", "Field density", "choice",
        "A combined knob that adjusts input padding AND question-to-question spacing together. Prevents mismatched padding/gap combinations.",
        "https://www.w3schools.com/cssref/pr_padding.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/target-size-enhanced.html",
        "--wsu-eit-field-pad-y / --wsu-eit-field-pad-x / --wsu-eit-q-gap", "Standard (.7rem / .85rem / 1.5rem)",
        "Denser forms pack more questions per screen but reduce the whitespace that helps users parse field boundaries. WCAG 2.5.5 still applies — ensure inputs remain >=44px tall at 'Compact' density. The 'Roomy' option adds generous spacing that benefits users with motor disabilities (larger targets) and cognitive disabilities (clearer field separation).",
        "Compact suits long applications (many questions). Standard is the safe default. Roomy suits short forms or audiences that benefit from extra space (e.g., older adults, users with motor impairments)."),
    new("labelweight", "Shape & density", "Label weight", "choice",
        "Font weight of question labels (the text above each input). Controls visual prominence of field names.",
        "https://www.w3schools.com/cssref/pr_font_weight.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/labels-or-instructions.html",
        "--wsu-eit-label-weight", "600 (Semibold)",
        "WCAG 3.3.2 Labels or Instructions requires visible labels for all form inputs. Heavier label weights make labels more visually distinct from help text and placeholder text, reducing the chance users skip over them.",
        "Regular (400) creates a quiet, minimal aesthetic but can make labels blend into surrounding text. Semibold (600) clearly distinguishes labels. Bold (700) makes labels dominant in the visual hierarchy."),
    new("labelsize", "Shape & density", "Label size", "range",
        "Font size of question labels. Adjust relative to body text — labels should be prominent but not overwhelming.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/resize-text.html",
        "--wsu-eit-label-size", "0.95rem (~15px)",
        "Labels must be large enough to read comfortably. Below 0.85rem (~13.6px) labels become hard to read for users with mild vision impairment. The rem unit ensures labels scale with browser zoom.",
        "Labels slightly smaller than body text (0.95rem) create hierarchy without shouting. At 1.0rem they match body text exactly. At 1.1rem they dominate — useful for forms where field identification is critical."),
    new("textareah", "Shape & density", "Textarea height", "range",
        "Minimum height of multi-line text boxes (textareas). Sets the visual expectation of how much text is expected.",
        "https://www.w3schools.com/tags/att_textarea_rows.asp",
        "https://www.w3.org/WAI/WCAG21/Understanding/identify-input-purpose.html",
        "--wsu-eit-textarea-h", "7rem",
        "A generous default height signals 'write more than a sentence.' Too-small textareas (2.5rem = single line height) discourage responses and confuse the expectation. Users can always resize, but the initial height sets the psychological frame.",
        "Match height to expected response length: 2.5-4rem for short answers (1-2 sentences), 7rem for paragraphs (personal statements, essays), 10-12rem for long-form responses."),
    new("choicesize", "Shape & density", "Checkbox size", "range",
        "Size of radio buttons and checkboxes. Larger targets are easier to tap on touch devices.",
        "https://www.w3schools.com/cssref/pr_dim_width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/target-size-enhanced.html",
        "--wsu-eit-choice-size", "1.15rem (~18px)",
        "WCAG 2.5.5 requires 44x44px targets. While the visual checkbox may be 18px, the clickable label area around it typically meets the 44px requirement. Larger checkboxes (1.3-1.5rem) improve precision for users with motor impairments and are easier to see for users with low vision.",
        "Browser-default checkboxes are typically 13-16px. The kit enlarges them for touch accessibility. The range (1.0-1.5rem) keeps them proportional to their labels."),

    // ── BRAND CUES ──
    new("focus", "Brand cues", "Focus ring width", "range",
        "Width of the keyboard-focus outline that appears when users Tab to an interactive element. The primary indicator for keyboard navigation.",
        "https://www.w3schools.com/cssref/css3_pr_outline-width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/focus-visible.html",
        "--wsu-eit-focus", "3px",
        "WCAG 2.4.7 Focus Visible requires a visible focus indicator. WCAG 2.4.11 (2.2) Focus Not Obscured requires it not be hidden. WCAG 2.4.13 Focus Appearance (AAA) requires the indicator to be at least 2px thick and have 3:1 contrast. The kit's 3px crimson ring exceeds all requirements. Setting below 2px risks failing 2.4.13.",
        "Thicker rings (4-8px) are easier to spot but busier visually. 3px is the WSU default — visible without dominating. Users who need even more visible focus can use browser extensions to enhance it further."),
    new("focuscolor", "Brand cues", "Focus ring color", "choice",
        "Color of the keyboard-focus outline. All options provide sufficient contrast against the white page background.",
        "https://www.w3schools.com/cssref/css3_pr_outline-color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/focus-appearance.html",
        "--wsu-eit-focus-color", "var(--wsu-eit-brand) (Crimson)",
        "WCAG 2.4.13 Focus Appearance requires the focus indicator to have at least 3:1 contrast against adjacent colors. Crimson (#A60F2D) provides 7.4:1 against white. Black provides ~13.5:1. Secondary red (#CA1237) provides ~5.4:1. All pass comfortably.",
        "Crimson focus rings reinforce the WSU brand even during keyboard navigation. Black is higher contrast but less branded. Choose based on whether brand presence or maximum visibility is the priority."),
    new("focusoffset", "Brand cues", "Focus ring offset", "range",
        "Gap between the focused element and its focus ring. Prevents the ring from overlapping the element's content.",
        "https://www.w3schools.com/cssref/css3_pr_outline-offset.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/focus-visible.html",
        "--wsu-eit-focus-offset", "2px",
        "Offset creates visual separation between the control and its focus ring, making the ring more noticeable. At 0px the ring touches the element — still accessible but less visually distinct. Large offsets (>5px) can cause the ring to overlap adjacent elements, creating confusion about which element is focused.",
        "2px is the standard — enough separation to be clear without encroaching on neighbors. 0px for a tight, modern look. 3-5px for maximum visibility."),
    new("edge", "Brand cues", "Required-field edge", "range",
        "Width of the crimson left-edge hint on empty required fields. A non-text visual cue that a field still needs to be filled.",
        "https://www.w3schools.com/cssref/pr_border-left.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/error-identification.html",
        "--wsu-eit-edge-hint", "3px",
        "This is a SUPPLEMENTARY cue — it does NOT replace the required star (*) or aria-required='true'. WCAG 1.4.1 (Use of Color) means this red edge alone can't be the only indicator of 'required.' The kit provides: the edge (color), the star (symbol), and aria-required (programmatic). Removing the edge (0px) is safe because the other two indicators remain.",
        "The crimson edge creates a left-aligned visual 'lane' that draws the eye to incomplete fields. It appears only while the field is empty and vanishes once filled — a gentle, progressive hint rather than an error message."),
    new("star", "Brand cues", "Required star color", "choice",
        "Color of the asterisk (*) that marks required fields. Both options maintain sufficient contrast.",
        "https://www.w3schools.com/cssref/pr_text_color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/use-of-color.html",
        "--wsu-eit-star", "#ca1237 (Secondary red)",
        "The star is a non-text graphical object — WCAG 1.4.11 requires 3:1 contrast. Red #CA1237 on white = ~5.4:1, crimson #A60F2D = ~7.4:1, body ink #262626 = ~13.5:1. All pass. The 'Off' fallback renders the star in body ink color, making it blend with label text — still present, just less prominent.",
        "Red/crimson stars are the web convention for 'required' — users recognize them instantly. Body-ink stars are subtler and feel less alarming, but may be missed by users scanning quickly."),
    new("starsize", "Brand cues", "Required star size", "range",
        "Size of the required-field asterisk relative to its label text. Larger stars are more noticeable; smaller stars are more subtle.",
        "https://www.w3schools.com/cssref/pr_font_font-size.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-star-size", "1em (same as label)",
        "Larger stars (1.2-1.4em) are easier to perceive for users with low vision. However, very large stars can visually dominate the label text, drawing attention away from the field name itself.",
        "1em blends with the label text. 1.2em adds slight emphasis. 1.4em makes the star a strong visual signal — useful if your audience frequently misses required fields."),
    new("selection", "Brand cues", "Text selection", "choice",
        "Highlight color when a visitor selects (drags over) text on the page. A subtle brand touchpoint.",
        "https://www.w3schools.com/cssref/sel_selection.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html",
        "--wsu-eit-select-bg / --wsu-eit-select-fg", "Goldfinch (yellow highlight)",
        "Selected text must remain readable — the foreground/background combination must maintain sufficient contrast. Goldfinch (yellow bg, dark text) = excellent contrast. Crimson (red bg, white text) = good contrast. Gray (gray bg, dark text) = good contrast. All shipped options are safe.",
        "Goldfinch creates a highlighter-pen effect — warm, readable, brand-adjacent (it's an official WSU accent color). Crimson is strongly branded. Gray is neutral/institutional."),
    new("topbarrule", "Brand cues", "Topbar hairline", "range",
        "Height of the thin crimson rule across the very top of every page — the first thing a user's eye hits. A signature WSU brand element.",
        "https://www.w3schools.com/cssref/pr_border-top.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-topbar-rule", "4px",
        "Purely decorative — no accessibility impact. The rule sits above the dark topbar, so contrast is crimson-on-dark (not a text element, but still visually distinct). Setting to 0 removes this brand cue entirely.",
        "The hairline appears on wsu.edu and admission.wsu.edu. It's a subtle 'you're on a WSU page' signal. 4px is the default; up to 10px creates a bolder brand stripe."),

    // ── PAGE ──
    new("col", "Page", "Content width", "range",
        "Maximum width of the centered content column. Controls how much of the viewport the form occupies on wide screens.",
        "https://www.w3schools.com/cssref/pr_dim_max-width.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/reflow.html",
        "--wsu-eit-col", "75rem (1200px)",
        "WCAG 1.4.10 Reflow requires content to be usable at 320px width (no horizontal scrolling). The kit handles this via responsive design, not this token. This token only sets the MAXIMUM — on narrow screens, content always fills the viewport. 'Off' removes the max-width entirely, running content full-bleed on wide monitors (poor readability at 2560px+).",
        "1200px is the web standard for content width. Narrower (56rem = 896px) creates a focused reading experience. Wider (96rem = 1536px) uses more screen on ultrawide monitors but may push line lengths past comfortable limits (use with --wsu-eit-measure to constrain paragraphs independently)."),
    new("pagepad", "Page", "Content padding", "range",
        "Vertical breathing room (padding) above and below the content column. Creates whitespace between the topbar/footer and the form content.",
        "https://www.w3schools.com/cssref/pr_padding.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/visual-presentation.html",
        "--wsu-eit-page-pad", "2.5rem",
        "Generous padding helps users with cognitive disabilities by reducing visual clutter and creating clear content boundaries. Reducing to minimum (0.5rem) packs content tightly, which can feel overwhelming. No specific WCAG requirement, but it contributes to overall 'cognitive accessibility.'",
        "2.5rem gives the content room to breathe. Smaller values (0.5-1rem) suit embedded contexts where the form appears inside another page. Larger values (3-4rem) create a premium, spacious feel."),
    new("paper", "Page", "Content paper", "choice",
        "Background color of the content column itself — the 'paper' that form questions sit on.",
        "https://www.w3schools.com/cssref/pr_background-color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html",
        "--wsu-eit-paper", "#ffffff (White)",
        "The paper color is the surface that text sits on — it directly affects all contrast ratios. White (#ffffff) provides maximum contrast with dark text. Warm white (#fcfbf7) and Mist (#f7f7f7) both still provide AAA-level contrast with #262626 body text (ratios > 12:1). Never use a paper color darker than #f0f0f0 without rechecking all text contrast ratios.",
        "Pure white is clean and maximizes contrast. Warm white reduces eye strain for extended reading (less blue light reflection). Mist gray subtly distinguishes the content area from the page backdrop."),
    new("wash", "Page", "Page backdrop", "choice",
        "Background color of the area OUTSIDE the content column — the canvas that the content column sits on.",
        "https://www.w3schools.com/cssref/pr_background-color.php",
        "https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html",
        "--wsu-eit-wash", "#f5f5f5 (Light gray)",
        "The wash doesn't contain text directly, so text contrast requirements don't apply to it. However, the contrast between wash and paper helps users perceive the content column boundaries. Light gray (#f5f5f5) against white (#ffffff) is subtle; Cool gray (#eff0f1) is slightly more distinct. White-on-white ('Off') removes the column distinction entirely.",
        "A visible backdrop frames the content and signals 'this is the form area.' It's especially helpful on wide screens where the content column doesn't span the full viewport."),
};

var repoRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));
var indexPath = args.Length > 0 ? args[0] : Path.Combine(repoRoot, "index.html");

if (!File.Exists(indexPath))
{
    Console.Error.WriteLine($"index.html not found at: {indexPath}");
    return 1;
}

var screenshotDir = Path.Combine(Path.GetDirectoryName(indexPath)!, "docs-generator", "screenshots");
Directory.CreateDirectory(screenshotDir);

var outputPath = Path.Combine(repoRoot, "usermanual.md");

Console.WriteLine("======================================================");
Console.WriteLine("  FreeSlate Documentation Generator");
Console.WriteLine("======================================================");
Console.WriteLine($"  Index:       {indexPath}");
Console.WriteLine($"  Screenshots: {screenshotDir}");
Console.WriteLine($"  Output:      {outputPath}");
Console.WriteLine();

// Start a local HTTP server to serve the files
var port = 8799;
var serverRoot = Path.GetDirectoryName(indexPath)!;
using var server = new LocalHttpServer(serverRoot, port);
var baseUrl = $"http://localhost:{port}";
Console.WriteLine($"  Server:      {baseUrl}");
Console.WriteLine();

// Install Playwright browsers if needed
Console.WriteLine("[1/4] Ensuring Playwright browsers are installed...");
var pwExitCode = Microsoft.Playwright.Program.Main(["install", "chromium"]);
if (pwExitCode != 0)
    Console.WriteLine($"  Playwright install returned {pwExitCode}, continuing...");

Console.WriteLine("[2/4] Launching headless Chromium...");
using var playwright = await Playwright.CreateAsync();
await using var browser = await playwright.Chromium.LaunchAsync(new() { Headless = true });

Console.WriteLine("[3/4] Capturing screenshots of all 40 settings...");
Console.WriteLine();

var screenshots = new Dictionary<string, string>(); // id -> base64 png

// Navigate to the page and switch to Tune mode
var context = await browser.NewContextAsync(new()
{
    ViewportSize = new() { Width = 1400, Height = 900 }
});
var page = await context.NewPageAsync();
await page.GotoAsync($"{baseUrl}/index.html", new() { WaitUntil = WaitUntilState.NetworkIdle, Timeout = 30000 });
await page.WaitForTimeoutAsync(1500);

// Click "Tune the kit" tab
await page.ClickAsync("#railtab-tune");
await page.WaitForTimeoutAsync(800);

// Capture each tune-card
var tuneCards = await page.QuerySelectorAllAsync(".tune-card");
Console.WriteLine($"  Found {tuneCards.Count} tune-cards on the page.");

for (int i = 0; i < tuneCards.Count && i < Settings.Length; i++)
{
    var card = tuneCards[i];
    var setting = Settings[i];

    // Scroll the card into view
    await card.ScrollIntoViewIfNeededAsync();
    await page.WaitForTimeoutAsync(250);

    // Screenshot just this card
    var pngBytes = await card.ScreenshotAsync(new() { Type = ScreenshotType.Png });
    var b64 = Convert.ToBase64String(pngBytes);
    screenshots[setting.Id] = b64;

    // Also save to disk for debug/inspection
    var filePath = Path.Combine(screenshotDir, $"{setting.Id}.png");
    await File.WriteAllBytesAsync(filePath, pngBytes);

    Console.WriteLine($"  [{i + 1:D2}/{Settings.Length}] ok {setting.Name} ({pngBytes.Length / 1024}KB)");
}

// If we got fewer cards than settings, note it
if (tuneCards.Count < Settings.Length)
{
    Console.WriteLine($"\n  Note: Found {tuneCards.Count} cards but expected {Settings.Length}. Some screenshots may be missing.");
}

await context.CloseAsync();

Console.WriteLine();
Console.WriteLine("[4/4] Generating usermanual.md...");

// Generate the markdown
var md = GenerateMarkdown(Settings, screenshots);
await File.WriteAllTextAsync(outputPath, md, Encoding.UTF8);

Console.WriteLine();
Console.WriteLine($"  Written: {outputPath}");
Console.WriteLine($"  Size: {new FileInfo(outputPath).Length / 1024}KB");
Console.WriteLine();
Console.WriteLine("Done. Run this again after any deployment to regenerate screenshots.");

return 0;

// ═══════════════════════════════════════════════════════════
// Markdown generation
// ═══════════════════════════════════════════════════════════

static string GenerateMarkdown(SettingInfo[] settings, Dictionary<string, string> screenshots)
{
    var sb = new StringBuilder();

    sb.AppendLine("# FreeSlate User Manual — Tweakable Design Tokens");
    sb.AppendLine();
    sb.AppendLine("> **Auto-generated** by `docs-generator/Program.cs` — do not edit manually.");
    sb.AppendLine("> Re-run `cd docs-generator && dotnet run` after each deployment to refresh screenshots.");
    sb.AppendLine();
    sb.AppendLine("## What This Guide Covers");
    sb.AppendLine();
    sb.AppendLine("The FreeSlate kit exposes **41 design tokens** — CSS custom properties in `build.css` section `TOKENS` —");
    sb.AppendLine("that let you customize the look and feel of every Slate form page without touching any component code.");
    sb.AppendLine("Think of them as a character creator: move any slider, you still can't leave the WSU brand.");
    sb.AppendLine();
    sb.AppendLine("Each setting below includes:");
    sb.AppendLine("- **What it does** — the CSS property it controls");
    sb.AppendLine("- **Screenshot** — captured live from the configurator");
    sb.AppendLine("- **CSS token** — the custom property name to override in `build.css`");
    sb.AppendLine("- **Default value** — what ships out of the box");
    sb.AppendLine("- **Accessibility notes** — WCAG compliance and impact on assistive technology users");
    sb.AppendLine("- **Design guidance** — when/why you'd change it");
    sb.AppendLine("- **Reference links** — CSS spec and WCAG understanding docs");
    sb.AppendLine();
    sb.AppendLine("---");
    sb.AppendLine();
    sb.AppendLine("## Table of Contents");
    sb.AppendLine();

    string? lastGroup = null;
    int settingNum = 0;
    foreach (var s in settings)
    {
        if (s.Group != lastGroup)
        {
            sb.AppendLine($"### {s.Group}");
            lastGroup = s.Group;
        }
        settingNum++;
        sb.AppendLine($"- [{settingNum}. {s.Name}](#{s.Id})");
    }

    sb.AppendLine();
    sb.AppendLine("---");
    sb.AppendLine();

    // Generate each setting section
    lastGroup = null;
    settingNum = 0;
    foreach (var s in settings)
    {
        if (s.Group != lastGroup)
        {
            sb.AppendLine($"## {s.Group}");
            sb.AppendLine();
            lastGroup = s.Group;
        }

        settingNum++;
        sb.AppendLine($"<a id=\"{s.Id}\"></a>");
        sb.AppendLine($"### {settingNum}. {s.Name}");
        sb.AppendLine();

        // Screenshot
        if (screenshots.TryGetValue(s.Id, out var b64))
        {
            sb.AppendLine($"![{s.Name} configurator card](data:image/png;base64,{b64})");
            sb.AppendLine();
        }

        sb.AppendLine("| Property | Value |");
        sb.AppendLine("|----------|-------|");
        sb.AppendLine($"| **CSS Token** | `{s.CssToken}` |");
        sb.AppendLine($"| **Default** | `{s.DefaultValue}` |");
        sb.AppendLine($"| **Control type** | {s.Kind} |");
        sb.AppendLine($"| **Group** | {s.Group} |");
        sb.AppendLine();

        sb.AppendLine("#### What It Does");
        sb.AppendLine();
        sb.AppendLine(s.Description);
        sb.AppendLine();

        sb.AppendLine("#### Accessibility (a11y)");
        sb.AppendLine();
        sb.AppendLine(s.A11yNotes);
        sb.AppendLine();

        sb.AppendLine("#### Design Guidance");
        sb.AppendLine();
        sb.AppendLine(s.DesignGuidance);
        sb.AppendLine();

        sb.AppendLine("#### References");
        sb.AppendLine();
        sb.AppendLine($"- **CSS property:** [{s.CssReference}]({s.CssReference})");
        sb.AppendLine($"- **WCAG Understanding:** [{s.WcagReference}]({s.WcagReference})");
        sb.AppendLine();
        sb.AppendLine("---");
        sb.AppendLine();
    }

    // How to apply
    sb.AppendLine("## How to Apply Changes");
    sb.AppendLine();
    sb.AppendLine("1. Open the showcase (`index.html`) and click **Tune the kit** in the sidebar.");
    sb.AppendLine("2. Adjust sliders/choices — the live examples update instantly.");
    sb.AppendLine("3. Click **Copy override block** to get the CSS.");
    sb.AppendLine("4. Paste into `build.css` inside the `TOKENS` section (at the top of the `:root` block).");
    sb.AppendLine("5. Upload the updated `build.css` to Slate's shared files.");
    sb.AppendLine();
    sb.AppendLine("```css");
    sb.AppendLine("/* Example: paste overrides into build.css TOKENS */");
    sb.AppendLine(":root {");
    sb.AppendLine("  --wsu-eit-round: 12px;        /* softer corners */");
    sb.AppendLine("  --wsu-eit-body-size: 1.0625rem; /* 17px body text */");
    sb.AppendLine("  --wsu-eit-h1-bar: 6px;        /* thicker heading rule */");
    sb.AppendLine("}");
    sb.AppendLine("```");
    sb.AppendLine();
    sb.AppendLine("## Regenerating This Document");
    sb.AppendLine();
    sb.AppendLine("```bash");
    sb.AppendLine("cd docs-generator");
    sb.AppendLine("dotnet run");
    sb.AppendLine("```");
    sb.AppendLine();
    sb.AppendLine("This runs a headless Chromium browser, navigates to the showcase's Tune tab,");
    sb.AppendLine("captures each setting card, and assembles this file with inline base64 screenshots.");
    sb.AppendLine("Run it after every deployment to keep documentation screenshots accurate.");

    return sb.ToString();
}

// ═══════════════════════════════════════════════════════════
// Types
// ═══════════════════════════════════════════════════════════

record SettingInfo(
    string Id,
    string Group,
    string Name,
    string Kind,
    string Description,
    string CssReference,
    string WcagReference,
    string CssToken,
    string DefaultValue,
    string A11yNotes,
    string DesignGuidance
);

// ═══════════════════════════════════════════════════════════
// Minimal static file HTTP server
// ═══════════════════════════════════════════════════════════

sealed class LocalHttpServer : IDisposable
{
    private readonly HttpListener _listener;
    private readonly string _root;
    private readonly CancellationTokenSource _cts = new();

    public LocalHttpServer(string root, int port)
    {
        _root = Path.GetFullPath(root);
        _listener = new HttpListener();
        _listener.Prefixes.Add($"http://localhost:{port}/");
        _listener.Start();
        _ = Task.Run(ServeLoop);
    }

    private async Task ServeLoop()
    {
        while (!_cts.IsCancellationRequested)
        {
            try
            {
                var ctx = await _listener.GetContextAsync();
                _ = Task.Run(() => HandleRequest(ctx));
            }
            catch (ObjectDisposedException) { break; }
            catch (HttpListenerException) { break; }
        }
    }

    private void HandleRequest(HttpListenerContext ctx)
    {
        var urlPath = ctx.Request.Url?.AbsolutePath?.TrimStart('/') ?? "";
        if (string.IsNullOrEmpty(urlPath)) urlPath = "index.html";

        // Security: prevent path traversal
        var fullPath = Path.GetFullPath(Path.Combine(_root, urlPath));
        if (!fullPath.StartsWith(_root))
        {
            ctx.Response.StatusCode = 403;
            ctx.Response.Close();
            return;
        }

        if (!File.Exists(fullPath))
        {
            ctx.Response.StatusCode = 404;
            ctx.Response.Close();
            return;
        }

        var ext = Path.GetExtension(fullPath).ToLowerInvariant();
        ctx.Response.ContentType = ext switch
        {
            ".html" => "text/html; charset=utf-8",
            ".css"  => "text/css; charset=utf-8",
            ".js"   => "application/javascript; charset=utf-8",
            ".json" => "application/json; charset=utf-8",
            ".png"  => "image/png",
            ".jpg" or ".jpeg" => "image/jpeg",
            ".svg"  => "image/svg+xml",
            ".woff2" => "font/woff2",
            ".woff" => "font/woff",
            _ => "application/octet-stream"
        };

        try
        {
            var bytes = File.ReadAllBytes(fullPath);
            ctx.Response.ContentLength64 = bytes.Length;
            ctx.Response.OutputStream.Write(bytes, 0, bytes.Length);
        }
        catch { /* client disconnected */ }
        finally
        {
            ctx.Response.Close();
        }
    }

    public void Dispose()
    {
        _cts.Cancel();
        _listener.Stop();
        _listener.Close();
    }
}
