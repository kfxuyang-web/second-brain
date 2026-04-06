# Ingest to Second Brain

Save content to your second brain. Just say "save this to my second brain" followed by the content or link.

## Examples

- "Save this tweet to my second brain: [tweet content]"
- "Save this link to my second brain: https://example.com/article"
- "Save this screenshot to my second brain"
- "Save this voice memo to my second brain"
- "Save this meeting notes to my second brain"

## What happens

1. Determine content type (tweet, article, image, voice, file, chat, task)
2. Save raw file to raw/ directory first
3. Process and extract key information
4. Classify using PARA (Projects/Areas/Resources/Archives)
5. Write to wiki/ directory
6. Update index and log
7. Create cross-links to related content

## Content types supported

| Type | Examples |
|------|----------|
| Tweet | Twitter posts, Weibo, short thoughts |
| Article | Blog posts, news, web pages |
| Image | Screenshots, photos with EXIF extraction |
| Voice | Audio recordings with transcription |
| File | PDF, Word, Excel, text documents |
| Chat | Meeting notes, chat logs |
| Task | Schedules, TODOs with deadlines |

## PARA Classification

The AI automatically classifies content into:

- **Projects**: Active projects with goals and deadlines
- **Areas**: Ongoing responsibilities without deadlines
- **Resources**: Topics you're interested in but not acting on
- **Archives**: Completed or abandoned items

## Simple voice messages

Voice messages under 5 seconds that are just confirmations (like "ok", "good") are not stored - they're just replied to directly.
