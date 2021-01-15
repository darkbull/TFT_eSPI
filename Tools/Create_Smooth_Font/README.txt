生成字体过程

1. 修改gb2312toUnicode.py，需要的汉字，按unicode码，连续的放在一起，生成数组元素
2. 将数据元素copy到 Create_font/Create_font.pde的 unicodeBlocks 数组中，根据需要删除该数组内其他的元素
3. 按需要修改Create_font.pde，例如：使用的字体文件,字体大小等
4. 使用Processing，运行Create_font.FontFiles vlw 文件 copy 到文件系统中加载
5. 如果使用 PROGMEM 的方式加载字体，使用vlw2array.py生成c头文件: 
    python3 vlw2array.py Create_font/FontFiles/NotoSansCJKsc-Regular16.vlw 
    执行上面指令生成NotoSansCJKscRegular16.h，在代码中加载该头文件即可。参考 examples/Smooth Fonts/FLASH_Array/Chinese_Font_Test