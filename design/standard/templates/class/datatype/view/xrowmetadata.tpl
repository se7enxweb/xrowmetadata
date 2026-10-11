<div class="block">
    <label>{'Default Open Graph image'|i18n( 'design/standard/class/datatype' )}:</label>
    {if $class_attribute.content}
        <p>{$class_attribute.content.name|wash()}</p>
    {else}
        <p><i>{'There are no related object.'|i18n( 'design/standard/content/datatype' )}</i></p>
    {/if}
</div>

<div class="block">
    <label>{'Allow a per-object Open Graph image'|i18n( 'design/standard/class/datatype' )}:</label>
    <p>{if $class_attribute.data_int3|ne(1)}{'Yes'|i18n( 'design/standard/class/datatype' )}{else}{'No, set by the class'|i18n( 'design/standard/class/datatype' )}{/if}</p>
</div>
