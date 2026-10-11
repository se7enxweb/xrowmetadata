{* The license picker of the metadata edit forms (object edit, class edit, the adminui edit form).

   Parameters:
     picker_id      unique id of the picker in the page
     select_name    the name the chosen license id is posted as ('' = use inherited)
     selected       the chosen license id, '' for none
     inherited      the license that applies without a choice (array with id, name, source: class|installation), or false
     inherit_label  optional: the text of the "use inherited" option when nothing is inherited
     custom_target  optional: id of the element with the custom license fields; shown only for a custom license
     bootstrap      optional: true() for the Bootstrap classes of the adminui design

   The list is grouped (each license once, in its first group: public domain, non-free by type, content, copyleft,
   permissive, open source, free software); the group filter shows every license of a group, wherever it is listed.
   Retired licenses (deprecated, or retired by Creative Commons) are hidden until "Show retired licenses" is
   checked, except the chosen one. Without JavaScript every license is listed. *}
{if is_set( $bootstrap )|not}{def $bootstrap = false()}{/if}
{if is_set( $custom_target )|not}{def $custom_target = ''}{/if}
{if is_set( $inherit_label )|not}{def $inherit_label = 'Use inherited: none'|i18n( 'design/standard/class/datatype' )}{/if}
{def $lp_choices = xrowmetadata_license_choices( $selected )
     $lp_info = xrowmetadata_license_info( $selected )
     $lp_shown = cond( $lp_info, $lp_info, $inherited )
     $lp_input_class = cond( $bootstrap, 'form-control', 'box' )
     $lp_has_retired = false()}
{foreach $lp_choices as $lp_group}{foreach $lp_group.options as $lp_option}{if $lp_option.retired}{set $lp_has_retired = true()}{break}{/if}{/foreach}{if $lp_has_retired}{break}{/if}{/foreach}

<div class="xrowmetadata-license-picker" id="{$picker_id|wash()}"
     data-custom-target="{$custom_target|wash()}"
     data-count="{'%shown of %total licenses shown'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-terms-of="{'Terms of %name:'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-allowed="{'allowed'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-not-allowed="{'not allowed'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-required="{'required'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-not-required="{'not required'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-not-stated="{'not stated'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-read-terms="{'Read the license'|i18n( 'design/standard/class/datatype' )|wash()}"
     data-term-labels="{concat( 'Commercial use'|i18n( 'design/standard/class/datatype' ), '|', 'Derivatives'|i18n( 'design/standard/class/datatype' ), '|', 'Share-alike'|i18n( 'design/standard/class/datatype' ), '|', 'Attribution'|i18n( 'design/standard/class/datatype' ) )|wash()}">

    <p class="xrowmetadata-license-inherited{if $bootstrap} help-block{/if}">
    {if $inherited}
        {if eq( $inherited.source, 'class' )}
            {'Inherited from class: %name'|i18n( 'design/standard/class/datatype', '', hash( '%name', $inherited.name|wash() ) )}
        {else}
            {'Inherited from installation: %name'|i18n( 'design/standard/class/datatype', '', hash( '%name', $inherited.name|wash() ) )}
        {/if}
    {else}
        {'No license is inherited: without a choice here the page states no license.'|i18n( 'design/standard/class/datatype' )}
    {/if}
    </p>

    <div class="xrowmetadata-license-filter">
        <span class="xrowmetadata-license-filter-item xrowmetadata-license-filter-search">
            <label for="{$picker_id|wash()}-search">{'Search licenses'|i18n( 'design/standard/class/datatype' )}:</label>
            <input type="search" id="{$picker_id|wash()}-search" class="{$lp_input_class} xrowmetadata-license-search" autocomplete="off"
                   placeholder="{'Name or SPDX id, e.g. CC BY 4.0 or GPL-3.0'|i18n( 'design/standard/class/datatype' )|wash()}" />
        </span>
        <span class="xrowmetadata-license-filter-item">
            <label for="{$picker_id|wash()}-group">{'Group'|i18n( 'design/standard/class/datatype' )}:</label>
            <select id="{$picker_id|wash()}-group" class="{if $bootstrap}form-control {/if}xrowmetadata-license-group">
                <option value="">{'All groups'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="os">{'Open source'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="fs">{'Free software'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="cl">{'Copyleft'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="pm">{'Permissive'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="ct">{'Content (Creative Commons)'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="pd">{'Public domain'|i18n( 'design/standard/class/datatype' )}</option>
                <option value="nf">{'Non-free'|i18n( 'design/standard/class/datatype' )}</option>
            </select>
        </span>
        {if $lp_has_retired}
        <span class="xrowmetadata-license-filter-item{if $bootstrap} checkbox{/if}">
            <label><input type="checkbox" class="xrowmetadata-license-retired" /> {'Show retired licenses'|i18n( 'design/standard/class/datatype' )}</label>
        </span>
        {/if}
        <span class="xrowmetadata-license-count" aria-live="polite"></span>
    </div>

    <label class="xrowmetadata-license-select-label" for="{$picker_id|wash()}-select">{'License'|i18n( 'design/standard/class/datatype' )}:</label>
    <select name="{$select_name|wash()}" id="{$picker_id|wash()}-select" size="10" class="{if $bootstrap}form-control {/if}xrowmetadata-license-select">
        <option value="" class="xrowmetadata-license-inherit"{if $selected|eq('')} selected="selected"{/if}{if $inherited} data-t="{$inherited.terms_code|wash()}" data-u="{$inherited.url|wash()}" data-n="{$inherited.name|wash()}"{/if}>
            {if $inherited}{'Use inherited: %name'|i18n( 'design/standard/class/datatype', '', hash( '%name', $inherited.name|wash() ) )}{else}{$inherit_label|wash()}{/if}
        </option>
        {if and( $selected|ne(''), $lp_info|not )}
        <option value="{$selected|wash()}" selected="selected" data-k="1">{'%id (not in the license catalogue)'|i18n( 'design/standard/class/datatype', '', hash( '%id', $selected|wash() ) )}</option>
        {/if}
        {foreach $lp_choices as $lp_group}
        <optgroup label="{$lp_group.label|wash()}">
            {foreach $lp_group.options as $lp_option}<option value="{$lp_option.id|wash()}" data-g="{$lp_option.group_codes|wash()}" data-t="{$lp_option.terms_code|wash()}"{if $lp_option.url_short|ne('')} data-u="{$lp_option.url_short|wash()}"{/if}{if $lp_option.retired} data-r="1"{/if}{if $lp_option.custom} data-c="1"{/if}{if $lp_option.id|eq( $selected )} selected="selected"{/if}>{$lp_option.label|wash()}{if $lp_option.retired} - {'retired'|i18n( 'design/standard/class/datatype' )}{/if}</option>
            {/foreach}
        </optgroup>
        {/foreach}
    </select>

    {* The terms summary of the license that applies (the chosen one, else the inherited one). JavaScript keeps it current. *}
    <div class="xrowmetadata-license-summary{if $bootstrap} help-block{/if}">
    {if $lp_shown}
        <span class="xrowmetadata-license-summary-name">{'Terms of %name:'|i18n( 'design/standard/class/datatype', '', hash( '%name', $lp_shown.name|wash() ) )}</span>
        <ul class="xrowmetadata-license-terms">
        {foreach $lp_shown.terms_list as $lp_term}
            <li>{$lp_term.label|wash()}:
            {if eq( $lp_term.value, 'unknown' )}{'not stated'|i18n( 'design/standard/class/datatype' )}
            {elseif or( eq( $lp_term.key, 'commercial' ), eq( $lp_term.key, 'derivatives' ) )}{if eq( $lp_term.value, 'yes' )}{'allowed'|i18n( 'design/standard/class/datatype' )}{else}{'not allowed'|i18n( 'design/standard/class/datatype' )}{/if}
            {else}{if eq( $lp_term.value, 'yes' )}{'required'|i18n( 'design/standard/class/datatype' )}{else}{'not required'|i18n( 'design/standard/class/datatype' )}{/if}{/if}</li>
        {/foreach}
        </ul>
        {if $lp_shown.url|ne('')}<a class="xrowmetadata-license-url" href="{$lp_shown.url|wash()}" target="_blank" rel="noopener noreferrer license">{'Read the license'|i18n( 'design/standard/class/datatype' )}</a>{/if}
    {/if}
    </div>
</div>

{literal}
<style>
.xrowmetadata-license-picker { max-width: 48em; }
.xrowmetadata-license-filter { display: flex; flex-wrap: wrap; gap: 0.5em 1em; align-items: flex-end; margin: 0.25em 0 0.5em; }
.xrowmetadata-license-filter-item { display: inline-flex; flex-direction: column; min-width: 0; }
.xrowmetadata-license-filter-search { flex: 1 1 16em; }
.xrowmetadata-license-filter-item label { font-weight: normal; }
.xrowmetadata-license-select { width: 100%; max-width: 100%; height: auto; }
/* A list box, not a drop-down: no drop-down arrow of the design's select style */
select.xrowmetadata-license-select[size] { background-image: none; padding-right: 0.5em; }
.xrowmetadata-license-select option { white-space: normal; }
.xrowmetadata-license-terms { list-style: none; margin: 0.25em 0; padding: 0; display: flex; flex-wrap: wrap; gap: 0.25em 1.5em; }
.xrowmetadata-license-count { opacity: 0.8; }
</style>
<script>
(function () {
    if ( window.xrowMetaDataLicensePicker ) { return; }
    function norm( s ) { return String( s || '' ).toLowerCase().replace( /[\s\-_.,:;()\/]+/g, ' ' ).trim(); }
    function picker( root ) {
        if ( !root || root.getAttribute( 'data-ready' ) ) { return; }
        // The custom fields follow the picker in the form: wait for them
        if ( document.readyState === 'loading' ) {
            document.addEventListener( 'DOMContentLoaded', function () { picker( root ); } );
            return;
        }
        root.setAttribute( 'data-ready', '1' );
        var select = root.querySelector( '.xrowmetadata-license-select' ),
            search = root.querySelector( '.xrowmetadata-license-search' ),
            group = root.querySelector( '.xrowmetadata-license-group' ),
            retired = root.querySelector( '.xrowmetadata-license-retired' ),
            count = root.querySelector( '.xrowmetadata-license-count' ),
            summary = root.querySelector( '.xrowmetadata-license-summary' ),
            customId = root.getAttribute( 'data-custom-target' ),
            custom = customId ? document.getElementById( customId ) : null,
            head = [], groups = [], total = 0;
        if ( !select ) { return; }
        // A snapshot of the list: the options before the first group, then each group with its options
        Array.prototype.forEach.call( select.children, function ( child ) {
            if ( child.tagName === 'OPTGROUP' ) {
                var g = { el: child, options: Array.prototype.slice.call( child.children ) };
                g.options.forEach( function ( o ) { o._x = norm( o.text + ' ' + o.value ); } );
                total += g.options.length;
                groups.push( g );
            } else {
                head.push( child );
            }
        } );
        function filter() {
            var words = norm( search ? search.value : '' ).split( ' ' ).filter( Boolean ),
                wanted = group ? group.value : '',
                showRetired = retired ? retired.checked : false,
                current = select.value, shown = 0;
            groups.forEach( function ( g ) {
                var keep = g.options.filter( function ( o ) {
                    if ( o.value === current ) { return true; }
                    if ( o.getAttribute( 'data-r' ) && !showRetired ) { return false; }
                    if ( wanted && ( ' ' + ( o.getAttribute( 'data-g' ) || '' ) + ' ' ).indexOf( ' ' + wanted + ' ' ) < 0 ) { return false; }
                    for ( var i = 0; i < words.length; i++ ) { if ( o._x.indexOf( words[i] ) < 0 ) { return false; } }
                    return true;
                } );
                while ( g.el.firstChild ) { g.el.removeChild( g.el.firstChild ); }
                keep.forEach( function ( o ) { g.el.appendChild( o ); } );
                shown += keep.length;
                if ( keep.length && g.el.parentNode !== select ) { select.appendChild( g.el ); }
                if ( !keep.length && g.el.parentNode === select ) { select.removeChild( g.el ); }
            } );
            // Keep the groups in their order
            groups.forEach( function ( g ) { if ( g.el.parentNode === select ) { select.appendChild( g.el ); } } );
            head.forEach( function ( o ) { if ( o.parentNode !== select ) { select.insertBefore( o, select.firstChild ); } } );
            if ( select.value !== current ) { select.value = current; }
            if ( count ) {
                count.textContent = ( root.getAttribute( 'data-count' ) || '' ).replace( '%shown', shown ).replace( '%total', total );
            }
        }
        function word( key, v ) {
            if ( v === '-' ) { return root.getAttribute( 'data-not-stated' ); }
            if ( key < 2 ) { return root.getAttribute( v === '1' ? 'data-allowed' : 'data-not-allowed' ); }
            return root.getAttribute( v === '1' ? 'data-required' : 'data-not-required' );
        }
        function update() {
            var o = select.options[select.selectedIndex];
            if ( custom ) {
                var needs = !!( o && o.getAttribute( 'data-c' ) ),
                    filled = Array.prototype.some.call( custom.querySelectorAll( 'input, textarea' ), function ( f ) { return f.value !== ''; } );
                custom.hidden = !( needs || filled );
            }
            if ( !summary ) { return; }
            var names4 = ( root.getAttribute( 'data-term-labels' ) || '' ).split( '|' ),
                code = o ? o.getAttribute( 'data-t' ) : null;
            while ( summary.firstChild ) { summary.removeChild( summary.firstChild ); }
            if ( !o || !code || names4.length !== 4 ) { return; }
            var title = document.createElement( 'span' ),
                list = document.createElement( 'ul' );
            title.className = 'xrowmetadata-license-summary-name';
            title.textContent = ( root.getAttribute( 'data-terms-of' ) || '%name' ).replace( '%name', o.getAttribute( 'data-n' ) || o.text.replace( / - [^()]*$/, '' ) );
            list.className = 'xrowmetadata-license-terms';
            for ( var i = 0; i < 4; i++ ) {
                var li = document.createElement( 'li' );
                li.textContent = names4[i] + ': ' + word( i, code.charAt( i ) || '-' );
                list.appendChild( li );
            }
            summary.appendChild( title );
            summary.appendChild( list );
            var url = o.getAttribute( 'data-u' ) || '';
            if ( url === 's:' ) { url = 'https://spdx.org/licenses/' + o.value + '.html'; }
            else if ( url.indexOf( 'c:' ) === 0 ) { url = 'https://creativecommons.org/licenses/' + url.substring( 2 ); }
            if ( url && /^https?:\/\//i.test( url ) ) {
                var a = document.createElement( 'a' );
                a.className = 'xrowmetadata-license-url';
                a.href = url; a.target = '_blank'; a.rel = 'noopener noreferrer license';
                a.textContent = root.getAttribute( 'data-read-terms' );
                summary.appendChild( a );
            }
        }
        if ( search ) { search.addEventListener( 'input', filter ); }
        if ( group ) { group.addEventListener( 'change', filter ); }
        if ( retired ) { retired.addEventListener( 'change', filter ); }
        select.addEventListener( 'change', function () { update(); } );
        // Enter in the search field picks the first match instead of sending the form
        if ( search ) {
            search.addEventListener( 'keydown', function ( e ) {
                if ( e.key !== 'Enter' ) { return; }
                e.preventDefault();
                var first = select.querySelector( 'optgroup option' );
                if ( first ) { select.value = first.value; update(); select.focus(); }
            } );
        }
        update();
        filter();
    }
    window.xrowMetaDataLicensePicker = picker;
    function all() { Array.prototype.forEach.call( document.querySelectorAll( '.xrowmetadata-license-picker' ), picker ); }
    if ( document.readyState === 'loading' ) { document.addEventListener( 'DOMContentLoaded', all ); } else { all(); }
})();
</script>
{/literal}
<script>if ( window.xrowMetaDataLicensePicker ) {ldelim} window.xrowMetaDataLicensePicker( document.getElementById( '{$picker_id|wash( 'javascript' )}' ) ); {rdelim}</script>
{undef $lp_choices $lp_info $lp_shown $lp_input_class $lp_has_retired}
