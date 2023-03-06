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
    echo "const should = require('chai').should();\n\ndefine('${1}', ()=>{\n   define('performs a simple test suite', ()=>{\n        it('works as expected', ()=>{\n            //test here\n        }\n    })\n})" > test/test.js
    touch "${1}.js"
    npm install --save-dev mocha
    npm install --save-dev chai
    echo $(cat package.json | jq '.scripts."lint"="./node_modules/.bin/eslint *.js src/*.js test/*.js"' --unbuffered) > package.json
    echo $(cat package.json | jq '.scripts."test"="./node_modules/.bin/mocha"' --unbuffered) > package.json
    #container support
    mkdir containers
    echo "FROM node:18\n\n# Install app dependencies\nCOPY package*.json ./\nRUN npm install\n\n# Bundle app source\nCOPY . .\n\n# run test\nCMD [ \"npm\", \"run\", \"test\" ]" > containers/test.dockerfile
    echo "FROM node:18\n\n# Install app dependencies\nCOPY package*.json ./\nRUN npm install\n\n# Bundle app source\nCOPY . .\n\n# run test\nCMD [ \"npm\", \"run\", \"test\" ]" > containers/development.dockerfile
    echo "FROM node:18\n\n# Install app dependencies\nCOPY package*.json ./\nRUN npm ci --only=production\n\n# Bundle app source\nCOPY . .\n\n# run test\nCMD [ \"npm\", \"run\", \"test\" ]" > containers/production.dockerfile
    echo $(cat package.json | jq ".scripts.\"container-test\"=\"docker build . -t  ${1} -f ./containers/test.dockerfile; docker logs --follow \\\"\$(docker run -d ${1})\\\"\"" --unbuffered) > package.json
    git init
    #atom .
    nova .
}

npm.type-support(){
    mkdir src #type workflow requires src
    touch src/.gitkeep
    echo $(cat package.json | jq ".scripts.\"lint\"=\"./node_modules/.bin/eslint *.js src/*.js test/*.js\"" --unbuffered) > package.json
    
    #type support
    npm install --save-dev jsdoc@3.6.3
    npm install --save-dev tsd-jsdoc
    mkdir types #type workflow requires src
    touch types/.gitkeep
    echo $(cat package.json | jq ".scripts.\"generate-types\"=\"./node_modules/.bin/jsdoc -t node_modules/tsd-jsdoc/dist -r src/. -d types\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".scripts.\"generate-typescript-root\"=\"cat ./types/types.d.ts > .d.ts\"" --unbuffered) > package.json
    
    #type-documentation support
    npm install --save-dev jsdoc-to-markdown
    mkdir docs
    touch docs/.gitkeep
    echo $(cat package.json | jq ".scripts.\"generate-docs\"=\"for i in src/*.js; do ./node_modules/.bin/jsdoc2md \\\"\${i}\\\" > \\\"docs/$(basename ${i%.js}).md\\\"; done\"" --unbuffered) > package.json
    
    
    #triggers support
    npm install --save-dev pre-commit
    echo $(cat package.json | jq ".\"precommit.colors\"=true" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[0]=\"lint\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[1]=\"test\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[2]=\"container-test\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[3]=\"generate-types\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[4]=\"generate-typescript-root\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[5]=\"generate-docs\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".\"precommit\"[6]=\"add-generated-files-to-commit\"" --unbuffered) > package.json
    echo $(cat package.json | jq ".scripts.\"add-generated-files-to-commit\"=\"git add docs/*.md; git add types/*.ts; git add .d.ts\"" --unbuffered) > package.json
    
    #conventional commit support
    npm install --save-dev @commitlint/{config-conventional,cli}
    npm install husky --save-dev
    npx husky install
    npx husky add .husky/commit-msg  'npx --no -- commitlint --edit ${1}'
    
    #prettify
    #echo $(cat package.json | jq "." --unbuffered) > package.json
    
    
}

npm.src(){ #this builds modern, typed UMDs
    
}
