######################
# Nodejs Macros      #
######################

protolus.serve(){
    sudo PROTOLUS_ENVIRONMENT=${PROTOLUS_ENVIRONMENT} node application.js
}

npm.create(){
    mkdir "${1}"
    cd "${1}"
    echo "{\"name\":\"${1}\",\"version\":\"0.0.1\", \"main\":\"${1}.js\"}" > package.json
    touch README.md
    mkdir test
    touch test/test.js
    touch "${1}.js"
    npm install --save-dev mocha
    npm install --save-dev chai
    atom .
}
