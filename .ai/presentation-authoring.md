# Presentation authoring

This module turns the September 2026 review of Ondřej Mottl's SSoQE and SPROuT presentations into reusable authoring guidance. Its purpose is to produce a coherent, visually inspected teaching deck that needs little routine human polishing. Follow [Quarto guidance](quarto-style.md) for implementation and rendering, [branding](branding.md) for the current SSoQE visual identity, and the [presentation reviewer](agents/presentation-reviewer.md) for independent review.

## Applicability and authorship

- Establish the author and requested style before using the personal guidance below. Apply it to Ondřej Mottl's presentations or when the user explicitly requests his style. An existing user clarification is sufficient; do not ask again.
- Other SSoQE teachers use different approaches. Preserve their established style and stated preferences. Repository ownership, a commit by an organizer, the shared logo, and a template credit are not sufficient evidence of slide authorship.
- Check substantive slide credits and content, and inspect source history when attribution or recent rewriting is unclear. Exclude empty template decks, copied source materials, and teaching examples belonging to other authors from the personal reference set.
- A deck the user identifies as an unsatisfactory agent draft is a comparison, not a style authority. Prefer the user's accepted references and retained sequences; examine earlier source revisions read-only if needed. Do not switch branches or restore old files for this purpose.
- The guidelines below concern delivery, representation, voice, and visual rhythm. They do not prescribe a dataset, method, example, language, session duration, or course sequence. Examples illustrate transferable moves and are not mandatory lesson content.
- Isolated technical, metadata, spelling, and link fixes retain their narrow scope. Do not redesign an otherwise accepted deck to satisfy this guide.

## Core brief

Build a presentation Ondřej can teach through. Give substantial space to meaningful images, real examples, and demonstrations. Use a direct, informal voice, with humour grounded in difficulties participants recognise. Develop explanations through successive views and purposeful reveals. Bring participants' own experience into the room and let them try manageable tasks frequently. Preserve the rhythm between visual explanation, technical detail, discussion, and practice.

The signature comes from these choices working together. Adding emojis, matching the palette, or shortening all text will not by itself recreate it. A technically correct slide may still need a different representation or a better place in the teaching sequence.

## Efficient preparation and implementation

1. Read the target deck, relevant exercises, local instructions, actual render entry point, and any supplied task or issue. Identify the audience, intended outcomes, prerequisites, and scope from existing materials and the user's request. Preserve accepted content and learning objectives unless the task calls for changing them.
2. Calibrate against a small set of verified references. Usually two or three short sequences suffice: an explanation, a demonstration, and an activity. Inspect their rendered appearance and meaningful reveal states as well as their source. Prefer the target deck's accepted sequences; use other available authored decks when needed. SPROuT is a style reference, not a required checkout or dependency. Do not repeat a workspace-wide audit for every lesson.
3. In working notes, make a compact sequence plan: teaching purpose, what is visible first, what the speaker explains, what changes on the next reveal or slide, what participants do, and the required asset or output. For substantial work, use the repository's existing planning location when one exists. Keep agent planning and review notes out of participant-facing slides.
4. Choose or verify the central visuals early. Their shape, labels, and content determine the composition. Reuse suitable assets already present, then source a useful missing visual with documented reuse terms. Keep a short asset record so searches, provenance checks, and downloads are not repeatedly performed.
5. For a new deck or major redesign, implement a representative sequence with an image-led explanation, a technical example when relevant, and an activity. Render and inspect it yourself before extending its choices across the deck. This is an internal calibration step, not a new approval gate.
6. Complete the authorized work, inspect the full deck, correct credible problems, and obtain the independent review required by Quarto guidance. Recheck changed slides and their surrounding sequences after fixes. Continue autonomously through routine wording, layout, asset, and reveal corrections; do not hand those decisions back as a polishing checklist.

Use existing context and reasonable implementation choices. Ask only when a material uncertainty cannot be resolved from the repository or the conversation, such as disputed authorship or an unresolved change to lesson scope. Missing optional information is not a reason to suspend independent work. Planning and rendering do not authorize Git or GitHub mutations.

## Revising an established lesson

- Treat the strongest accepted version of the lesson itself as the primary content baseline. Inspect the target repository's history before rebuilding from a related course, a generic template, or an agent-written plan. A separately linked deck may be a content or style reference without being the lesson the user wants restored.
- Preserve effective explanations, examples, jokes, activities, and visual sequences unless they conflict with the requested scope. When only one segment is being replaced, revise that segment and its transitions rather than redesigning the complete lesson by default.
- Advanced participants may justify faster pacing, but not the removal of a concise conceptual bridge that gives later code meaning. Compress a strong foundation sequence when necessary instead of assuming technical confidence makes it redundant.
- Keep the lesson's example world coherent across explanation, demonstration, and exercises. When the user changes the central dataset or case study, update participant tasks, hidden setup, speaker notes, outputs, and debriefs together; do not leave retired examples as a parallel storyline.
- Use the target author's accepted current decks to calibrate title, section, and exercise slides. Reuse established classes and composition before inventing a new visual treatment for the same slide role.

## Write for live teaching

- Give each slide a clear teaching purpose. Decide what the audience needs to see and what the presenter will explain aloud. Keep the visible content sufficient to understand the example, question, and action without writing a transcript of the lecture.
- Use short explanations, familiar language, and direct address. Questions about participants' own research and first-person statements of an actual teaching preference fit the voice. Do not invent personal experiences, opinions, or anecdotes on the author's behalf.
- Let headings take the form the content needs: a plain topic, a function name, a question, a brief conversational transition, or an emphatic statement. Preserve effective existing headings. Do not force every title into a claim, command, slogan, or clever narrative formula.
- Humour should recognise a real frustration or illuminate an idea. A familiar coding mishap, a fitting meme, or an exaggerated expression can make difficulty approachable. Keep the joke directed at the situation, not participants' ability. Do not sanitize accepted informal wording merely to sound professional, and do not manufacture a joke for every slide.
- Use emojis and emphatic punctuation as occasional cues or expressive accents. They cannot substitute for a missing illustration, explanation, or activity. Preserve technical precision and accessibility.
- Use summaries and checklists when they help participants retrieve or act on what they learned. Avoid adding a generic takeaway sentence or boxed moral to every slide. Read neighbouring slides together for repeated phrasing and repetitive explanation-plus-conclusion layouts.
- Fix typos, ambiguous instructions, and factual errors. Informality is a voice choice, not a reason to preserve accidental mistakes.

## Make the explanation visible

Choose the representation that lets participants recognise, inspect, compare, or predict the important thing. A real screenshot, scientific figure, drawn explanation, short code example, or physical activity may carry more meaning than additional prose.

| Teaching need | Useful authoring move | Inspect before moving on |
|---|---|---|
| Recognise a software control or state | Show the real interface, then crop or highlight the relevant part; pair it with a short action | The target control and its context are readable at the presentation viewport |
| Understand an unfamiliar relationship | Make a concrete comparison and show the correspondence explicitly | Participants can name what each part represents and where the comparison stops working |
| Understand a structure or process | Show an accessible overview, then add or focus detail in successive views | The changing element is clear and the audience remains oriented |
| Understand a code change | Keep the example stable, change the relevant lines, and show the resulting output or behaviour | Visible code and output agree; the reason for the change is observable |
| Recognise a common difficulty | Use a relevant real example, illustration, or meme and invite recognition | The visual contributes to the concept rather than merely decorating the topic |
| Consider a decision in one's own work | Ask for a choice, explanation, comparison, or small artifact | Participants have enough context to respond and know what to do next |

### Visual material and composition

- Use substantial, purposeful visual material. The reference decks mix Scriberia-style explanations, community artwork, scientific figures, photographs, package mascots, screenshots, and memes. Preserve the useful character of a selected asset rather than redrawing everything into one uniform illustration system.
- When introducing an R package, prefer its official hex logo or another official package mark, when one exists and reuse is permitted. Link the mark or adjacent package name to the official documentation. The logo should create recognition and visual breathing room, not sit as a small ornament beside a dense API summary.
- An image may occupy most of the canvas with only a short heading and attribution. Two images or a visual and a small amount of text often make a comparison clearer. Avoid shrinking meaningful artwork to a decorative thumbnail beside a large prose block.
- Reuse appropriate existing media and verify source, creator, licence, and attribution before adding or republishing it. Appearance in an older deck is evidence of style, not proof of permission. Choose another suitable asset if reuse cannot be established; do not leave the central visual as an unresolved placeholder at handoff.
- Preserve figure meaning, labels, scales, units, and relevant context when cropping or emphasizing. Explain unfamiliar mappings and reference marks before asking participants to interpret them. Introduce necessary complexity gradually without distorting the evidence.
- Use scientific photographs, data, and figures when they are the substance of the explanation. Decorative imagery is optional. Never invent a scientific result or present a generated image as observed evidence.
- Prefer a flat canvas with one clear focal relationship. Common compositions are a large visual, a comparison in two columns, code with output, an oversized section title, or a distinct activity slide. Use the repository's existing classes and components before adding custom layout code.
- Use boxes for a purpose: an activity prompt, a quotation, a necessary warning, or an occasional focal statement. Avoid filling a deck with repeated cards, badges, panels, and decorative framing. Functional tabsets for alternative software workflows remain appropriate when already supported and usable.
- Vary density according to purpose. A sparse question, a dense reference figure, and a code example can all belong in the same deck. Do not impose fixed counts of bullets, pictures, words, or emojis. If content will not fit legibly, reconsider the representation, sequence, or distribution between slides and exercise materials before reducing type size.

### Brand and emphasis

- Preserve the current SSoQE brand and the repository's documented deviations. The personal style transfers across palettes and fonts; historical SSoQE and SPROuT typography and colours are not instructions to replace the current identity.
- Use editable theme sources to identify intended typography. A fallback font, missing web font, broken image, or export clipping in an old PDF is not a style preference. Check the intended HTML view and any deliberately produced alternate format.
- Highlight selected words or short phrases within sentences to direct attention to a relationship. Keep colour meanings stable within the explanation and pair them with words, labels, position, or other cues so colour is not the only carrier of meaning.
- Distinguish major sections and activities using the established full-background and typography conventions. Preserve whitespace, hierarchy, and readable contrast. Large headings and saturated section slides should mark a real change in the session.
- Keep image attribution, resource links, and slide navigation usable but subordinate to the teaching content. Retain helpful access to slides, code, or exercises without reproducing obsolete personal or course information from references.

## Build sequences and reveals deliberately

- Treat related slides as a teaching sequence. Repeated headings and nearly identical examples can preserve orientation while one important element changes. Do not deduplicate them automatically or compress them into a crowded summary.
- Define the initial state, the purpose of each reveal, and the final state. The first visible state must give the audience something meaningful to inspect, consider, or do. Avoid accidentally empty slides created by hiding every element in fragments.
- Reveal a counterpart when making a comparison, an answer after a real opportunity to respond, or the consequence after showing a change. Progressive code highlighting and auto-animation are useful when they make the change easier to follow.
- Keep related elements spatially stable where practical. A new fragment must not crowd a prompt, move the key comparison unexpectedly, or reveal the answer before the audience can consider the question.
- Use animations to show a process when motion matters. Use a static view when it communicates the relationship adequately. Repetition, movement, and sequential bullets need a teaching purpose; adding more fragments is not a substitute for choosing a better visual.
- Plan how the audience regains the larger context after a detailed sequence. Use an overview, a familiar representation, a brief recap, or an integrated task when helpful; do not enforce a recap after every concept.

## Demonstration, practice, and participation

- Preserve the connection between introducing a concept, demonstrating it, and letting participants try it. Place manageable tasks near the skill they practise, then combine established skills in a larger exercise when appropriate.
- Give distinct new practices their own short activity and debrief when combining them would obscure what participants are learning or what failed. Mirror that separation in the participant materials instead of presenting one long undifferentiated exercise.
- Anchor discussion in a real question, participant experience, a decision, or evidence on the slide. Invite prediction, comparison, explanation, or improvement rather than adding a token question whose answer is already displayed.
- Give activity slides concise instructions: who works together when relevant, what they do, what they produce or check, and the time available if timing is part of the lesson. Use the established exercise styling and timer where suitable. Choose feasible durations from the task and session; do not copy timings mechanically from another deck.
- Preserve social forms of learning where they fit: comparing approaches, discussing with a neighbour, peer review, group debriefs, or movement around the room. Provide an equivalent participation option when a physical activity would exclude someone.
- When participants create an artifact, make the destination and next step clear. Follow the lesson's existing collaboration tools. Posting a group result, commenting on a peer's work, and testing another person's project are examples, not requirements to introduce a new service.
- Ensure discussion links, exercise files, starter data, and instructions actually exist and are usable. Checking them is part of preparing the activity; posting, sending messages, changing permissions, or creating external resources still requires the applicable authorization.
- Keep tasks proportionate to what has been taught. State the observable success condition without turning every small exercise into a long compliance checklist. Have an expected outcome or instructor explanation available for substantive exercises and prediction questions.

## Code and software demonstrations

- Show the actual code and relevant output when they explain the mechanism. Start with a readable example and introduce additional complexity intentionally. Retain useful intermediate objects and visible transformations so participants can follow what changed.
- Pair an unfamiliar interface with a readable screenshot or demonstration context. For example, explaining an environment panel benefits from showing that panel. Describing its contents in bullets alone may lose the visual orientation present in the reference decks.
- Use short before/after examples or successive versions when the difference is the lesson. Keep names, inputs, and layout stable enough to make the change visible; introduce a new dataset only when it serves the requested learning goal.
- Put lengthy exercise instructions and supporting implementation in the established handout or code materials, while leaving enough of the mechanism and task on the slide to teach from. Respect the requested balance: some authored decks deliberately teach primarily through code.
- Use [R conventions](r-style.md) and the repository's existing project helpers. Do not hide the concept being taught inside an opaque helper or replace visible code with a polished diagram that no longer explains the operation.
- Verify code/output consistency and substantive exercise outcomes through focused execution using the documented environment. Clearly label intentionally failing examples and show how the failure is interpreted or resolved. Distinguish literal output from illustrative mockups.

### Ondřej's teaching-code preferences

Apply these choices to Ondřej Mottl's decks and associated participant materials unless a repository documents a deliberate exception:

- Use `set.seed(900723)` when an example needs a conventional arbitrary seed. Keep a scientifically required, externally specified, or compatibility-critical seed when changing it would alter the task's contract.
- In `{purrr}` teaching code, use the formula shorthand with `.x`, such as `map(values, ~ transform(.x))`, rather than the native anonymous-function syntax `\(x)`. Introduce additional placeholders only when the functional genuinely has more inputs.
- Put hidden data construction and slide-specific preparation in a secret or non-displayed code block on the slide that consumes it. Reserve the deck-wide setup block for packages, options, and objects that are genuinely shared across the presentation.
- When slide code or a locally generated figure needs brand colours, fonts, or custom plotting parameters, read them from the repository's editable JSON theme sources. Do not duplicate palette values or visual constants in the QMD. Continue to regenerate tracked SCSS and plotting-theme products through the repository generator.
- When participants create a project artifact, teach the real destination and the next action. Prefer established scaffolding helpers when they clarify the workflow, and show paired artifacts together when one is meant to verify or support the other.

## Concrete reference moves

These examples preserve the reasoning behind the reviewed decks. Adapt the move to the current lesson; do not transplant the named topic, asset, or exact wording by default.

| Observed move | Transferable principle |
|---|---|
| A chess move and its written record appear beside a file change and a commit | Make the parts of an analogy correspond visibly, then return to the technical representation |
| A complete RStudio screenshot is followed by readable crops of individual panels | Establish orientation before focusing attention on one part of an interface |
| A project tree grows across successive slides with the same heading | Retain context while adding one meaningful layer of structure |
| Code is altered and its output or dependency consequences are shown | Let participants see what a change does and why it matters |
| A reproducibility meme leads to a question about participants' own research | Use recognition and humour to open a substantive discussion |
| Participants position themselves on a spectrum and explain their choices | Make differing experiences visible and use them as material for discussion |
| A small operation is practised immediately and later combined with others | Build capability through short cycles and then integrate it |
| Large FAIR initials anchor successive slides with highlighted explanatory phrases | Use a stable visual anchor and selective emphasis to organise a sequence |

## Finish the polishing before handoff

Apply the full rendered inspection and independent-review requirements in [Quarto guidance](quarto-style.md). Source review and automated overflow checks do not establish visual or stylistic success. Use the checks below during authoring and pass the chosen reference sequences and authorship decision to the reviewer.

| Check | Signs that another pass is needed | Useful correction |
|---|---|---|
| Live teaching | Slides read like a transcript; every point has an explanatory paragraph and a moral | Retain the necessary visible evidence and move appropriate delivery detail to notes or the established companion material |
| Visual explanation | Long stretches describe things participants could inspect; screenshots and figures are tiny | Give the actual representation enough space and use shorter supporting text |
| Voice | Generic motivational phrasing, invented personal opinions, or emojis standing in for personality | Use direct language and a relevant question, example, or accepted expression |
| Rhythm | Many neighbouring slides repeat the same two columns or explanation-plus-takeaway box | Reconsider the teaching purpose and vary representation, scale, or participant action where useful |
| Progression | Similar slides were merged; new diagrams appear without orientation; answers appear immediately | Restore the meaningful sequence and inspect every materially different reveal state |
| Participation | Activities lack a concrete action, usable materials, feasible timing, or a way to judge the result | Complete the activity and its expected outcome using the lesson's established workflow |
| Detail | Small text, dense code, excessive highlighting, or an oversized image with unreadable internal labels | Recompose, split, focus, or move supporting detail; check the final rendered slide |
| Fidelity | A draft, another author's deck, or a font/export failure is treated as a reference | Recheck authorship, accepted references, and editable theme sources |

Resolve credible findings and inspect the final result before presenting it to the user. Report remaining limitations honestly, including missing assets, unverified execution, or unavailable visual or independent review. Human review is for judgment about the finished teaching material; it should not be the first check for routine layout, wording, reveal, or exercise problems. Do not claim that style is an exact match or that personal preference has been fully captured merely because checks passed.
