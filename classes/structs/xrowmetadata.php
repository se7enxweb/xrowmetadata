<?php

class xrowMetaData extends ezcBaseStruct
{
    public $priority;
    public $change;
    public $title;
    public $keywords = array();
    public $description;
    public $sitemap_use;
    public $canonical_url;
    /**
     * The Open Graph image object id the page shows: the object's own image,
     * else the class default. Empty when there is none that can be shown.
     */
    public $og_image;
    /**
     * The Open Graph image object id stored in this attribute (the object's
     * own choice), whether or not that object can still be shown. This is
     * what is saved.
     */
    public $og_image_own;
    /**
     * Where og_image comes from: 'object', 'class' or ''.
     */
    public $og_image_source = '';
    /**
     * Kept for stored data only. The size printed for og:image is the size
     * of the image alias (og_image_info), not these values; the edit form no
     * longer offers them.
     */
    public $og_image_width;
    public $og_image_height;
    public $og_image_alt;
    public $og_image_type;

    /**
     * The picture of og_image (xrowMetaDataOpenGraphImage::info()), made when
     * a template first asks for it.
     */
    protected $ogImageInfo = null;

    public function __construct( $title = false, $keywords = array(), $description = false, $priority = false, $change = false, $sitemap_use = false, $canonical_url = false, $og_image = false, $og_image_width = false, $og_image_height = false, $og_image_alt = false, $og_image_type = false )
    {
        $this->title = $title;
        $this->keywords = $keywords;
        $this->description = $description;
        $this->canonical_url = $canonical_url;
        $this->sitemap_use = $sitemap_use;
        $this->og_image = $og_image;
        $this->og_image_own = $og_image;
        $this->og_image_source = ( $og_image !== false && $og_image !== '' && $og_image !== null ) ? 'object' : '';
        $this->og_image_width = $og_image_width;
        $this->og_image_height = $og_image_height;
        $this->og_image_alt = $og_image_alt;
        $this->og_image_type = $og_image_type;
        if ( empty( $priority ) )
        {
            $this->priority = null;
        }
        else
        {
            $this->priority = $priority;
        }
        if ( empty( $change ) )
        {
            $this->change = 'daily';
        }
        else
        {
            $this->change = $change;
        }
        if ( $sitemap_use === false )
        {
            $this->sitemap_use = '1';
        }
        elseif ( empty( $sitemap_use ) )
        {
            $this->sitemap_use = '0';
        }
        else
        {
            $this->sitemap_use = '1';
        }
    }

    function hasAttribute( $name )
    {
        return in_array( $name, $this->attributes(), true ) || in_array( $name, array( 'priority', 'change' ), true );
    }

    function attributes()
    {
        return array('title','description','keywords','sitemap_use','canonical_url','og_image','og_image_width','og_image_height','og_image_alt','og_image_type',
                     'og_image_own','og_image_source','og_image_info','og_image_object');
    }

    function attribute( $name )
    {
        switch ( $name )
        {
            case 'og_image_info':
                return $this->ogImageInfo();
            case 'og_image_object':
                return xrowMetaDataOpenGraphImage::usableObject( $this->og_image );
        }
        return $this->$name;
    }

    /**
     * The picture of og_image for the page head, or false.
     *
     * @return array|false
     */
    function ogImageInfo()
    {
        if ( $this->ogImageInfo === null )
        {
            $this->ogImageInfo = xrowMetaDataOpenGraphImage::info( $this->og_image );
        }
        return $this->ogImageInfo;
    }

    /**
     * The object's own Open Graph image id as stored, '' for none.
     */
    function storedOgImage()
    {
        $id = xrowMetaDataOpenGraphImage::objectID( $this->og_image_own );
        return $id > 0 ? (string) $id : '';
    }

    /**
     * @return xrowMetaData
     */
    static public function __set_state( array $array )
    {
        $meta = new xrowMetaData( $array['title'], $array['keywords'], $array['description'], $array['priority'], $array['change'], $array['sitemap_use'], $array['canonical_url'], $array['og_image'], $array['og_image_width'], $array['og_image_height'], $array['og_image_alt'], $array['og_image_type'] );
        if ( array_key_exists( 'og_image_own', $array ) )
        {
            $meta->og_image_own = $array['og_image_own'];
        }
        if ( isset( $array['og_image_source'] ) )
        {
            $meta->og_image_source = $array['og_image_source'];
        }
        return $meta;
    }
}
