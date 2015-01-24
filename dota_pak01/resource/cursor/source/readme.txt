CURSOR PUBLISHING GUIDELINES

Cursors have to be saved in two different formats to accommodate all platforms.

On Windows, cursors are simply .ani files, which contain all cursor data.

Under SDL (Linux/Mac/etc), .ani files are not supported. Instead, cursors are .bmp files. Whenever a cursor named e.g. abc.ani is saved, an equivalent abc.bmp should also be provided.

By default, SDL will assume the top-left most pixel of the cursor is the hotspot. However, if a cursor has a different hotspot, the cursor.res file can be edited to provide the cursor's hotspot. 
