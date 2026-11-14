# Changelog

All notable changes to xrowmetadata from 1.4.30 on. Earlier releases are described on
<https://github.com/se7enxweb/xrowmetadata/releases>.

## 1.4.30 (2026-11-14)

- Updated: Pull request #14 (Marco-JAC) is merged: the settings files close their PHP comment (`<?php /* ... */ ?>`), so
  `php -l` passes and a direct request to one prints nothing. The files had already been closed in 1.4.27, so the
  merge changes no settings file; it records the contribution.
- Added: `tests/xrowmetadata_settings_files_test.php` (SF-01..03, no kernel or database): every settings file parses as
  PHP, ends with `*/ ?>` and prints nothing when included, so an unclosed comment cannot come back unnoticed (eZINI
  reads such a file all the same).

      php extension/xrowmetadata/tests/xrowmetadata_settings_files_test.php

- Updated: `ezinfo.php` and `extension.xml` state 1.4.30.

The same check was run over every se7enxweb extension of an Exponential 6 installation: no other settings file
leaves its comment open.
