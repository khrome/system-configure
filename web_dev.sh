base64.encode(){
    openssl base64 -in ${1} -out ${1}.b64
}

base64.decode(){
    openssl base64 --decode -in ${1} -out ${1}.bin
}

