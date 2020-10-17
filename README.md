# Magic Numbers

Magic numbers is a file investigation technique where a rogue file may be named .txt or .zip but in fact is another filetype. Read more about [Filename mangling - Wikipedia](https://en.wikipedia.org/wiki/Filename_mangling).

Read more about list of signatures for magic numbers at [Wikipedia - List of file signatures](https://en.wikipedia.org/wiki/List_of_file_signatures).

This PowerShell script will read in the given Filetype endings and their common signatures from the file **siglist.txt** in the directory \ps\ (This directory can be changed in the PowerShell source).

## siglist.txt layout
| Filetype | First bytes | Ending bytes | Common file endings
| ------ | ------ |  ------ | ------ |
| PE | 4D5A | |.exe,.cpl,.dll,.ocx,.sys,.scr,.drv
| JPEG | FFD8 | FFD9 |.jpg,.jpeg,.jpe,.jif,.jfif,.jfi |
| PDF | 25504446 | |.pdf |
| ZIP | 504B | |.zip, .zipx |
| DB3 | 53514C69 | |.db3|

 
# Remember

  - This was a school assignment during my time studying IT-Security and Software testing - this is not guaranteed to work 100%.
  - Do not copy and use this in your school assignments, instead learn from it and improve it.
  - This will not be maintained by me, this is uploaded for safekeeping online.

License
----

MIT


**Free Software, Hell Yeah!**
