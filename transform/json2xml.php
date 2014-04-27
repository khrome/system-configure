<?php
    // Abbey's totally naive json2xml converter
    // if the first argument after the script is a single line, we'll treat it as a filename
    if(strpos($argv[1], "\n") === false){
        $input = file_get_contents($argv[1]);
    }else{ //otherwise we assume JSON is being passed in
        $input = $argv[1];
    }
    try{
        $array = json_decode($input);
    }catch(Exception $ex){
        echo('Decoding error('.$ex->getMessage().')!');
    }
    // recursively traverse the object/array/primitives tree and output XML
    function dumpXML($node){
        $result = '';
        if(is_array($node)){
            $result .= '<array>';
            foreach($node as $name => $childNode){
                $result .= '<item>'.dumpXML($childNode).'</item>';
            }
            $result .= '</array>';
        }else if(is_object($node)){
            $result .= '<class>';
            foreach($node as $name => $childNode){
                $result .= '<item name="'.$name.'">'.dumpXML($childNode).'</item>';
            }
            $result .= '</class>';
        }else{
            $result .= $node;
        }
        return $result;
    }
    //dump it
    echo(dumpXML($array));
?>