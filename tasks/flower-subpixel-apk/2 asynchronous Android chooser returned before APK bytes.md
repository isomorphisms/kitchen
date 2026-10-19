# Version 2: Android document chooser is asynchronous

Version 2 addressed Cat Food's absent published package by looking under the real Cat Food runtime workspace and optionally requesting a user-selected Android document with `termux-storage-get`. Its CI used an unrealistically synchronous picker mock: the helper returned only after the fixture file was already copied.

The Termux:API `StorageGetAPI` receiver starts an `ACTION_OPEN_DOCUMENT` activity, while the separate activity receives the selection and writes the requested file later. The shell command may finish while the document picker remains open. Version 2 then immediately checks for a file, giving an incorrect `not materialized` failure, or might hash a partial copy.

References: https://github.com/termux/termux-api/blob/master/app/src/main/java/com/termux/api/apis/StorageGetAPI.java and `termux-api-package/scripts/termux-storage-get.in`.

**Version 3** waits for a complete match to the exact expected APK SHA-256, with a bounded file-picker interval. No file-path inference, no background task performed by ChatGPT, no automatic APK download, and no install before a full match. A delayed-copy fixture deliberately makes the chooser return before writing; a wrong-file fixture must finish blocked without opening the package installer. Version 2 was not served to the user and remains in the branch only as historical development evidence.
