find . -name *.php       -exec svn propset svn:eol-style LF {} \;
find . -name *.inc        -exec svn propset svn:eol-style LF {} \;
find . -name *.java       -exec svn propset svn:eol-style LF {} \;
find . -name *.xml        -exec svn propset svn:eol-style LF {} \;
find . -name *.properties -exec svn propset svn:eol-style LF {} \;
find . -name *.htaccess   -exec svn propset svn:eol-style LF {} \;
find . -name *.html       -exec svn propset svn:eol-style LF {} \;
find . -name *.tld        -exec svn propset svn:eol-style LF {} \;
find . -name *.dtd        -exec svn propset svn:eol-style LF {} \;
find . -name *.txt        -exec svn propset svn:eol-style LF {} \;
find . -name *.apt        -exec svn propset svn:eol-style LF {} \;
find . -name *.fml        -exec svn propset svn:eol-style LF {} \;
find . -name *.ftl        -exec svn propset svn:eol-style LF {} \;

find . -name *.java -exec svn propset svn:keywords "Date Author Id Revision HeadURL" {} \;
find . -name *.xml  -exec svn propset svn:keywords "Date Author Id Revision HeadURL" {} \;