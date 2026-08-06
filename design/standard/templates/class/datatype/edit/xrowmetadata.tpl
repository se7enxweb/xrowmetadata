{def $mt_og_object = false()}
{if and($attribute.data_int4, $attribute.data_int4|gt(0))}
    {set $mt_og_object = fetch('content','object',hash('id',$attribute.data_int4))}
{/if}

<div class="block" id="ezobjectrelation_browse_{$attribute.id}">
    <label>{'Default Open Graph image'|i18n( 'design/standard/class/datatype' )}:</label>
    <table class="list" cellspacing="0">
    <thead>
    <tr>
        <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
        <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
        <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
        <th>{'Published'|i18n( 'design/standard/content/datatype' )}</th>
    </tr>
    </thead>
    <tbody>
    <tr class="bglight">
    {if $mt_og_object}
        <td>{$mt_og_object.name|wash()}</td>
        <td>{$mt_og_object.class_name|wash()}</td>
        <td>{fetch(section, object, hash(section_id, $mt_og_object.section_id)).name|wash}</td>
        <td>{if $mt_og_object.status|ne(1)}{'No'|i18n( 'design/standard/content/datatype' )}{else}{'Yes'|i18n( 'design/standard/content/datatype' )}{/if}</td>
    {else}
        <td>--name--</td>
        <td>--class-name--</td>
        <td>--section-name--</td>
        <td>--published--</td>
    {/if}
    </tr>
    </tbody>
    </table>
    <input type="hidden" name="xrowmetadata_og_image_{$attribute.id}" value="{$attribute.data_int4|wash()}" />
    {if $mt_og_object}
        <input class="button ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_object]" value="{'Remove object'|i18n( 'design/standard/content/datatype' )}" />
    {else}
        <input class="button ezobject-relation-add-button" type="submit" name="CustomActionButton[{$attribute.id}_browse_object]" value="{'Add an existing object'|i18n( 'design/standard/content/datatype' )}" title="{'Browse to add an existing object'|i18n( 'design/standard/content/datatype' )}" />
    {/if}
</div>
