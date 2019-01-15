var beautify = require('js-beautify').js, fs = require('fs');
fs.readFile('../../bin/h5/Root.max.ugly.js', 'utf8', function(err, data){
    if(err) {
        console.error(err);
        return;
    }
    var formatted = beautify(data, { indent_size: 2, space_in_empty_paren: true });
    fs.writeFile('../../bin/h5/Root.max.ugly.js', formatted, function(err) {
        if (err) {
            throw err;
        }
    });
});