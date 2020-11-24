# sources
#source ~/.gdb/printers/gdbinit
#source ~/.gdb/reverse_engineering
#source /home/kfunk/devel/src/kde-dev-scripts/gdb/load-qt5printers.py


# init
set multiple-symbols ask
set disassembly-flavor intel
set unwindonsignal on
# no need to run gdb-add-index manually anymore with this
set index-cache on
