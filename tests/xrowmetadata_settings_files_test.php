<?php
/**
 * Every settings file of the extension is valid PHP: it opens its comment with <?php /* and closes it
 * with * / ?> (without the space), so php -l passes, a direct request to the file prints nothing, and
 * eZINI reads it as before. A file that never closed the comment was a parse error ("Unterminated
 * comment") on every PHP version. Reads the files only, without the kernel or a database.
 *
 *   php extension/xrowmetadata/tests/xrowmetadata_settings_files_test.php
 *
 *  SF-01 - every settings/*.ini.append.php and *.ini.php parses as PHP (token_get_all with TOKEN_PARSE)
 *  SF-02 - its last non-empty line closes the comment (* / ?>), so nothing after it is PHP code
 *  SF-03 - including it prints nothing
 *
 * Prints PASS/FAIL per check and a summary; the exit code is 1 on a failure.
 *
 * @license GNU General Public License v2.0 (or any later version)
 */

$failures = 0;
function sfCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

$root = dirname( __DIR__ );
$files = array();
$it = new RecursiveIteratorIterator( new RecursiveDirectoryIterator( $root . '/settings', FilesystemIterator::SKIP_DOTS ) );
foreach ( $it as $file )
    if ( preg_match( '/\.ini(\.append)?\.php$/', (string)$file ) )
        $files[] = substr( (string)$file, strlen( $root ) + 1 );
sort( $files );
sfCheck( count( $files ) > 0, count( $files ) . ' settings file(s) found' );

foreach ( $files as $path )
{
    $source = file_get_contents( $root . '/' . $path );

    // SF-01
    $error = null;
    set_error_handler( function ( $no, $message ) use ( &$error ) { $error = $message; return true; } );
    try
    {
        token_get_all( $source, TOKEN_PARSE );
    }
    catch ( ParseError $e )
    {
        $error = $e->getMessage();
    }
    restore_error_handler();
    sfCheck( $error === null, "SF-01 $path parses as PHP" . ( $error === null ? '' : " ($error)" ) );

    // SF-02
    $lines = preg_split( '/\R/', rtrim( $source ) );
    sfCheck( trim( end( $lines ) ) === '*/ ?>', "SF-02 $path ends with */ ?>" );

    // SF-03
    if ( $error === null )
    {
        ob_start();
        include $root . '/' . $path;
        $output = ob_get_clean();
        sfCheck( $output === '', "SF-03 $path prints nothing when included" );
    }
}

echo $failures ? "FAILED: $failures check(s)\n" : "PASS: every settings file is valid PHP\n";
exit( $failures ? 1 : 0 );
