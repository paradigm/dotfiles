#!javascript

var prev_next_map = {
    prev: "(^<$|^(<<|«|←)|\\b(prev|previous|newer|précédente)\\b)",
    next: "(^>$|(>>|»|→)$|\\b(next|more|older|suivante)\\b)"
};

var follow_relation = function(rel, data) {
    var qry = "[rel='" + rel + "']";
    var elt = document.querySelector(qry);
    if (elt) {
        location.href = elt.href;
    } else {
        var str = data[rel];
        if (!str)
            return;
        re = RegExp(str, 'i');
        var links = document.getElementsByTagName("a");
        var i = links.length
        while (elt = links[--i]) {
            var uri = elt.href;
            var txt = elt.text;
            if (elt.title)
                txt = elt.title;
            var images = elt.getElementsByTagName("img");
            if (images.length > 0) {
                img = images[0];
                if (img.alt)
                    txt = img.alt;
            }
            if (re.test(txt) && uri.search(/#/) == -1) {
                location.href = uri;
                break;
            }
        }
    }
}

function inject_follow(rel) {
    var script = "(" + String(follow_relation) + ")(\"" + rel + "\"," + JSON.stringify(prev_next_map) + ");";
    var frames = tabs.current.allFrames;
    for (var i = 0; i < frames.length; i++) {
        frames[i].inject(script);
    }
}

function prev_page() {
    inject_follow('prev');
}

function next_page() {
    inject_follow('next');
}

bind("[[", prev_page);
bind("]]", next_page);

// vim: set ft=javascript:
