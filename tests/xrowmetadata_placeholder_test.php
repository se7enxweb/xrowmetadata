<?php
/**
 * The metadata() operator replaces the placeholders of a title or description ([name], [count], [path],
 * [parentname], [count:localbusiness], [pagecount]) and leaves every other text in square brackets as the editor
 * wrote it. Before 1.4.29 a known placeholder was never replaced (its result was dropped) and any other bracketed
 * text, such as "kracker [dot] org", emptied the whole title. Reads the operator class only, without the kernel or
 * a database.
 *
 *   php extension/xrowmetadata/tests/xrowmetadata_placeholder_test.php
 *
 *  XP-01 - a title without brackets stays as it is
 *  XP-02 - other text in brackets stays ("kracker [dot] org - Listen Live!")
 *  XP-03 - each known placeholder is replaced, twice in one title too
 *  XP-04 - known and unknown placeholders mixed: only the known ones change
 *  XP-05 - a placeholder without a value in the list stays as written; an empty title stays empty
 *
 * Prints PASS/FAIL per check and a summary; the exit code is 1 on a failure.
 *
 * @license GNU General Public License v2.0 (or any later version)
 */

$failures = 0;
function xpCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

require_once dirname( __DIR__ ) . '/autoloads/xrowmetadataoperator.php';
$operator = new xrowMetaDataOperator();
$replace = new ReflectionMethod( 'xrowMetaDataOperator', 'getReplaceValue' );
$replace->setAccessible( true );
$values = array( 'name' => 'Playlist', 'count' => 304, 'path' => 'Playlist | kracker.org', 'parentname' => 'kracker.org',
                 'count:localbusiness' => 7, 'pagecount' => 'page 2/5' );
$run = function ( $title ) use ( $replace, $operator, $values )
{
    return $replace->invoke( $operator, $title, $values );
};

xpCheck( $run( 'kracker.org - my hub' ) === 'kracker.org - my hub', 'XP-01 a title without brackets stays as it is' );
xpCheck( $run( 'kracker [dot] org - Listen Live!' ) === 'kracker [dot] org - Listen Live!', 'XP-02 other text in brackets stays' );
xpCheck( $run( '[name] ([count] items) - [name]' ) === 'Playlist (304 items) - Playlist'
         && $run( '[path]' ) === 'Playlist | kracker.org' && $run( 'in [parentname]' ) === 'in kracker.org'
         && $run( '[count:localbusiness] shops, [pagecount]' ) === '7 shops, page 2/5',
         'XP-03 each known placeholder is replaced, twice in one title too' );
xpCheck( $run( '[name] on kracker [dot] org' ) === 'Playlist on kracker [dot] org', 'XP-04 only the known placeholders change' );
xpCheck( $replace->invoke( $operator, '[name] and [count]', array( 'name' => 'A' ) ) === 'A and [count]' && $run( '' ) === '',
         'XP-05 a placeholder without a value stays; an empty title stays empty' );

echo $failures ? "\n$failures check(s) failed\n" : "\nAll checks passed\n";
exit( $failures ? 1 : 0 );
