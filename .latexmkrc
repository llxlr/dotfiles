## 工作路径 latexmk 配置文件
## 文件名：latexmkrc 或 .latexmkrc
## 文件目录：~

# 设置时区
$ENV{"TZ"}="Asia/Shanghai";

# 设置 pdflatex,xelatex,bibtex,biber 选项执行的命令
# %O, %S 是占位符;
# %O 代表选项，%S 代表对应命令的源文件
$pdflatex = "pdflatex -halt-on-error -file-line-error -synctex=1 -interaction=nonstopmode %O %S";
$lualatex = "lualatex -halt-on-error -file-line-error -synctex=1 -interaction=nonstopmode %O %S";
$xelatex = "xelatex -halt-on-error -file-line-error -synctex=1 -interaction=nonstopmode %O %S";
$xdvipdfmx = "xdvipdfmx -q -E -o %D %O %S";
$bibtex = "bibtex %O %S";
$biber = "biber %O %S";

# 生成后缀 fls 的文件，该文件包含程序读写时的文件列表，1 代表开启
$recorder = 1;

# 设置 pdf 预览器, 需要把下面的程序路径更换为自己电脑 pdf 阅读器的路径
# Windows 使用 SumatraPDF
# Linux 使用 Zathura/Okular
# MacOS 使用 Skim
if($^O eq "MSWin32" or $^O eq "msys"){
    $pdf_previewer = 'start "D:\\Program Files\\SumatraPDF\\SumatraPDF.exe" %O %S';
}elsif($^O eq "linux"){
    $pdf_previewer = "start zathura %O %S";
    #$pdf_previewer = "start okular --unique %O %S";
}elsif($^O eq "darwin"){
    $pvc_view_file_via_temporary = 0;
    $pdf_previewer = "open -a Skim %O %S";
}

# 执行 latexmk -c 或 latexmk -C 时会清空 latex 程序生成的文件（-C 更强，会清空 pdf）
# 除此之外, 可以设置额外的文件拓展，以进行清空
$clean_ext = "aux bbl blg idx ind ilg lof lot out toc acn acr alg glg glo gls ist fls log fdb_latexmk snm synctex(busy) synctex.gz synctex.gz(busy) nav run.xml hd xdv swp un~";

# 设置 pdf 生成模式，有 0 1 2 3 4 5
# 0 代表不生成 pdf
# 1 代表使用 $pdfltex 选项的命令，在系统 RC 文件已经设置
# 2 代表使用 $ps2pdf
# 3 代表使用 $dvipdf
# 4 代表使用 $lualatex；
# 5 代表使用 $xelatex，在系统 RC 文件已经设置
$pdf_mode = 5;

# 设置 bibtex 或 biber 的使用规则，有 0 1 1.5 2
# 0: 不使用 bibtex 或 biber； 清空的时候不会清空 .bbl 文件
# 1: 只有 bib 文件存在才使用 bibtex 或 biber；清空的时候不会清空 .bbl 文件
# 1.5: 只有 bib 文件存在才使用 bibtex 或 biber；当 bib 文件存在时会清空 bbl，否则不会清空
# 2: 有必要更新 bbl 文件时，运行 bibtex 或 biber，无需测试 bib 文件存在与否；清空删除 bbl
$bibtex_use = 1.5;

# 设置 latex 文件输出的目录
$out_dir = "out";

# 设置预览模式，相当于 -pv 选项，在编译结束会开启预览
# $view 设置预览的文件格式
$preview_mode = 1;
$view = "pdf";

# 设置 latexmk 编译的文件，和不需要编译的文件，可以时多个
@default_files = ("main.tex", "thesis.tex");
@default_excluded_files = ();

# 强制继续处理过去的错误，相当于 -f 选项
$force_mode = 1;

# 处理文件，不管时间戳如何，相当于 -g 选项
$go_mode = 0;

# 处理时更改为源文件的目录，相当于 -cd 选项
$do_cd = 1;

add_cus_dep("glo", "gls", 0, "glo2gls");
sub glo2gls {
    system("makeindex -s gglo.ist -o \"$_[0].gls\" \"$_[0].glo\"");
}
push @generated_exts, "glo", "gls";

add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
    system("makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"");
}
push @generated_exts, "nlo", "nls";