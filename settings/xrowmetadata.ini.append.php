<?php /*

[EditorInputSettings]
MaxTitle=65
MaxDescription=150
MaxPageLimit=20

# If enabled, keywords will be hidden in the 'Other options' block
HideKeywords=disabled

[OpenGraph]
# The classes an editor may choose as the Open Graph image of an object,
# in the metadata attribute's edit form ("Choose image").
ImageClasses[]
ImageClasses[]=image

# Where the object browser starts: a node id or a node alias (content, media, users).
BrowseStartNode=media

# The attributes searched, in this order, for the picture of the chosen
# object. An ezimage attribute is shown in the image alias below; when none
# of these has content, the first ezimage attribute with content is used.
ImageAttributes[]
ImageAttributes[]=site_opengraph_image
ImageAttributes[]=image
ImageAttributes[]=site_logo
ImageAttributes[]=file

# The image alias printed as og:image and twitter:image (absolute URL),
# with its width and height. The alias is defined in this extension's
# image.ini.append.php. An alias that cannot be made falls back to original.
ImageAlias=opengraph

# The alias of the preview in the edit form.
ThumbnailAlias=small

# The scheme and host of og:image when the request has no host (a script).
# Empty: https:// and [SiteSettings] SiteURL.
SiteURL=

*/ ?>
