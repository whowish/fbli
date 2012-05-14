jQuery.default_text
=======================

This is a new default text plugin, which does not modify the value of an input.

Instead, it creates a clone of the input and places on the exact same location.
With this way, you won't have problems with default value being submitted.


How it works
------------------
A text input, which contains a default text is cloned (using jQuery.clone()).
Then, it is placed exactly behind the real textbox.
And then we make the real textbox transparent.

It is only when the real textbox is focused, it is made opaque.


Browser Compatibility
------------------
* MSIE 7.0
* Firefox/5.0 (Mozilla/5.0)
* Chrome/12.0.742.112 Safari/534.30 (Mozilla/5.0)
* iPhone Versionn/5.0.2 Mobile/8G4 Safari/6533.18.5 (Mozilla/5.0)


How to use it
-------------------
&lt;input type="text" id="test_textbox" class="test" style="color: green"&gt;

$('#test_textbox').default_text('this is default...');



License
------------------
Creative Commons 3.0



Contributors
-------------------
Tanin Na Nakorn
Sergiu Rata
Nilobol Ariyamongkollert