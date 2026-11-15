# Version 1: quoting found during source review

Grease parsing passed after multiline case assignments were corrected. Source
review then found literal backslashes around the frontend command substitution
and an overescaped awk regular expression. No numerical or acceptance execution
of version 1 passed. Version 2 removes both quoting defects and keeps version 1
as the reviewed failed attempt. The exact pinned Grease parser checks version 2.
