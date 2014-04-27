<?php
    print_r($_SERVER['argv']);
    if(!mode) throw new Exception('No command to execute');
    switch(strtolower($mode)){
        case 'list':
            'sqlite3 ~/Library/Caches/com.apple.Safari/Cache.db "select cfurl_cache_response.request_key, cfurl_cache_blob_data.entry_ID from cfurl_cache_response, cfurl_cache_blob_data where cfurl_cache_blob_data.entry_ID = cfurl_cache_response.entry_ID and cfurl_cache_response.request_key like \'http://static.ak.fbcdn.net/rsrc.php%.js\'"'
            break;
        case 'get':
            'sqlite3 ~/Library/Caches/com.apple.Safari/Cache.db "select cfurl_cache_blob_data.receiver_data from cfurl_cache_response, cfurl_cache_blob_data where cfurl_cache_blob_data.entry_ID = cfurl_cache_response.entry_ID and cfurl_cache_response.request_key like \'http://static.ak.fbcdn.net/rsrc.php%.js\'"'
            break;
        case 'set'
            'sqlite3 ~/Library/Caches/com.apple.Safari/Cache.db "update cfurl_cache_blob_data set reciever_data = \'SOMETHING\'  where cfurl_cache_blob_data.entry_ID = 1"'
            break;
        default:
    }

?>