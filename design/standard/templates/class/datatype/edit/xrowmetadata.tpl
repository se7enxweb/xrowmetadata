<div class="block" id="ezobjectrelation_browse_{$attribute.id}">
    <label>{'Default Open Graph image'|i18n( 'design/standard/class/datatype' )}:</label>
    {if is_object($attribute.content)}
        {def $mt_og_object = $attribute.content}
        <input type="hidden" name="xrowmetadata_og_image_{$attribute.id}" value="{$mt_og_object.id|wash()}" />
        <table class="list" cellspacing="0">
            <tr>
                <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
                <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
                <th>{'Action'|i18n( 'design/standard/content/datatype' )}</th>
            </tr>
            <tr>
                <td>{$mt_og_object.name|wash()}</td>
                <td>{$mt_og_object.class_name|wash()}</td>
                <td>
                    <input class="button ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_object]" value="{'Remove object'|i18n( 'design/standard/content/datatype' )}" />
                </td>
            </tr>
        </table>
    {else}
        <input type="hidden" name="xrowmetadata_og_image_{$attribute.id}" value="" />
        <p class="ezobject-relation-no-relation">{'There are no related object.'|i18n( 'design/standard/content/datatype' )}</p>
        <input class="button ezobject-relation-add-button" type="submit" name="CustomActionButton[{$attribute.id}_browse_object]" value="{'Add an existing object'|i18n( 'design/standard/content/datatype' )}" title="{'Browse to add an existing object'|i18n( 'design/standard/content/datatype' )}" />
    {/if}
</div>
