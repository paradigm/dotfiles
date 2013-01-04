/**
 * Copyright (c) 2009 by Eric Van Dewoestine
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 *
 * Plugin which translates the current page.
 *
 * Usage:
 *   :translate <source_lang> [<target_lang>]
 * Ex.:
 *   :translate de
 *
 * zh en Chinese-simp to English
 * zh zt Chinese-simp to Chinese-trad
 * zt en Chinese-trad to English
 * zt zh Chinese-trad to Chinese-simp
 * en zh English to Chinese-simp
 * en zt English to Chinese-trad
 * en nl English to Dutch
 * en fr English to French
 * en de English to German
 * en el English to Greek
 * en it English to Italian
 * en ja English to Japanese
 * en ko English to Korean
 * en pt English to Portuguese
 * en ru English to Russian
 * en es English to Spanish
 * nl en Dutch to English
 * nl fr Dutch to French
 * fr nl French to Dutch
 * fr en French to English
 * fr de French to German
 * fr el French to Greek
 * fr it French to Italian
 * fr pt French to Portuguese
 * fr es French to Spanish
 * de en German to English
 * de fr German to French
 * el en Greek to English
 * el fr Greek to French
 * it en Italian to English
 * it fr Italian to French
 * ja en Japanese to English
 * ko en Korean to English
 * pt en Portuguese to English
 * pt fr Portuguese to French
 * ru en Russian to English
 * es en Spanish to English
 * es fr Spanish to French
 *
 * @version 0.1
 */
function Translate() {
  URL_RE = new RegExp("http://babelfish.yahoo.com/.*?trurl=([^&]*).*");
  return {
    translate: function(url, sl, tl){
      if (URL_RE.test(url)){
        url = url.match(URL_RE)[1];
      }
      window.content.document.location =
        "http://babelfish.yahoo.com/translate_url?" +
        "trurl=" + url + "&lp=" + sl + "_" + tl;
    }
  };
}

var translate = Translate();

commands.add(["translate"],
  "Translate the current page.",
  function(args) {
    // TODO
    //   - determine default target lang from user's browser
    var target = args.length > 1 ? args[1] : "en";
    translate.translate(window.content.document.location.href, args[0], target);
  }, {argCount: 2}
);
