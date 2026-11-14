<?php

class xrowMetaDataOperator
{
    function operatorList()
    {
        return array(
            'metadata'
        );
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array(
            'metadata' => array(
                'node_id' => array(
                    'type' => 'int' ,
                    'required' => true ,
                    'default' => null
                )
            )
        );
    }

    function getPlaceholders($str)
    {
        $result = array();
        preg_match_all('/(?<=\[)([^\]]*?)(?=\])/',$str, $result);
        return $result[0];
    }

    function modify( $tpl, $operatorName, $operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        $ini= eZINI::instance('xrowmetadata.ini');
        $page_limit = $ini->variable( 'EditorInputSettings', 'MaxPageLimit' );
        $uri = eZURI::instance( eZSys::requestURI() );
        $viewParameters = $uri->UserParameters();
        // Any other user parameter (a filter, a tracking value) comes without
        // an offset: then the page is the first one.
        $page_offset = isset( $viewParameters['offset'] ) ? (int)$viewParameters['offset'] : 0;
        switch ( $operatorName )
        {
            case 'metadata':
            {
                if( isset( $namedParameters['node_id'] ) )
                {
                    $node = eZContentObjectTreeNode::fetch( $namedParameters['node_id'] );
                    if( $node instanceof eZContentObjectTreeNode )
                    {
                        $cur_parent = $node->fetchParent();
                        $replaceArray['name'] = $node->getName();
                        $replaceArray['count'] = $node->subTreeCount(array( 'IgnoreVisibility' => true ));
                        $replaceArray['count:localbusiness']= $node->subTreeCount(array( 'IgnoreVisibility' => true,
                                                                                         'ClassFilterType'=> 'include',
                                                                                         'ClassFilterArray'=> array('localbusiness')));
                        $path_array_temp = array_reverse(explode('/', $node->pathWithNames()));
                        $replaceArray['path'] = implode(' | ', $path_array_temp);
                        $replaceArray['parentname'] = $cur_parent->Name;
                        $page_count=ceil($replaceArray['count:localbusiness']/$page_limit);
                        $page_nr=($page_offset/$page_limit)+1;
                        $replaceArray['pagecount']=ezpI18n::tr( 'kernel/classes/datatypes', 'page' )." ".$page_nr."/".$page_count;

                        $operatorValue = xrowMetaDataFunctions::fetchByObject( $node->attribute( 'object' ) );
                        if($operatorValue !== false)
                        {
                            if(isset($operatorValue->title))
                            {
                                $operatorValue->title = $this->getReplaceValue( $operatorValue->title,$replaceArray );
                            }
                            if(isset($operatorValue->description))
                            {
                                $operatorValue->description = $this->getReplaceValue( $operatorValue->description,$replaceArray );
                            }
                        }
                    }
                    else
                    {
                        $operatorValue = false;
                    }
                }
                else
                {
                    $operatorValue = false;
                }
            }break;
        }
    }

    /**
     * getReplaceValue()
     *
     * @param string $operatorValue
     * @param array $replaceArray
     * @return string
     */
    protected function getReplaceValue($operatorValue,$replaceArray)
    {
        // The known placeholders ([name], [count], [path], [parentname], [count:localbusiness], [pagecount]) are
        // replaced; any other text in brackets ("kracker [dot] org") stays as the editor wrote it
        $search_value = (string)$operatorValue;
        foreach ( array_unique( $this->getPlaceholders( $search_value ) ) as $placeholder_value )
        {
            if ( array_key_exists( $placeholder_value, $replaceArray ) )
            {
                $search_value = str_replace( '[' . $placeholder_value . ']', (string)$replaceArray[$placeholder_value], $search_value );
            }
        }
        return $search_value;
    }
}
