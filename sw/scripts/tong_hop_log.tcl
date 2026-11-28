#!/usr/bin/env tclsh
# =============================================================
# Lab 2 - Phan 5: tong hop ket qua cac log mo phong trong logs/.
# Chay tu goc repo:   tclsh sw/scripts/tong_hop_log.tcl
# (sau TODO 9 cua Makefile: make logs)
#
# Ket qua mong doi:
#   File         Commit    Ket qua  Sai
#   run_01.log   a1f3c09   TREO     -
#   run_02.log   5be2d14   FAIL     103
#   run_03.log   5be2d14   FAIL     88
#   run_04.log   c7e90aa   PASS     0
#   run_05.log   c7e90aa   PASS     0
#   Tong so phep nhan sai: 191
# =============================================================

# TODO 1: viet proc doc_log {file} tra ve list {commit ket_qua sai}
#   - mac dinh: commit "?", ket_qua "?", sai "-"
#   - mo file bang open, doc tung dong bang gets trong vong while, dong bang close
#   - dong dau co dang "... commit=5be2d14 ..."  -> regexp {commit=([0-9a-f]+)} $line -> commit
#   - dong "PASS: ..."                           -> ket_qua PASS, sai 0
#   - dong "FAIL: 103/206 phep nhan sai"         -> ket_qua FAIL, sai 103
#       goi y: regexp {^FAIL: ([0-9]+)/[0-9]+ phep nhan sai} $line -> n
#   - dong "FAIL: het thoi gian ..."             -> ket_qua TREO

# TODO 2: lay danh sach file: set files [lsort [glob -nocomplain logs/*.log]]
#         neu danh sach rong: in thong bao va "exit 1"

# TODO 3: in dong tieu de va moi file mot dong bang
#         format "%-12s %-9s %-8s %s"  (dung [file tail $f] de bo duong dan)

# TODO 4: cong don so phep sai (chi cong khi sai la so: string is integer -strict $sai)
#         va in "Tong so phep nhan sai: <tong>"
proc doc_log {file} {
    set commit "?"
    set ket_qua "?"
    set sai "-"

    set fp [open $file r]

    while {[gets $fp line] >= 0} {
        regexp {commit=([0-9a-f]+)} $line -> commit

        if {[regexp {^PASS:} $line]} {
            set ket_qua "PASS"
            set sai 0
        } elseif {[regexp {^FAIL: ([0-9]+)/[0-9]+ phep nhan sai} $line -> n]} {
            set ket_qua "FAIL"
            set sai $n
        } elseif {[regexp {^FAIL: het thoi gian} $line]} {
            set ket_qua "TREO"
        }
    }

    close $fp
    return [list $commit $ket_qua $sai]
}
set files [lsort [glob -nocomplain logs/*.log]]

if {[llength $files] == 0} {
    puts "Khong tim thay file log"
    exit 1
}
puts [format "%-12s %-9s %-8s %-6s %s" "File" "Commit" "Ket qua" "Sai" "Ty le"]

set tong 0

foreach f $files {
    lassign [doc_log $f] commit ket_qua sai

    set ty_le "-"

    if {[string is integer -strict $sai]} {
        incr tong $sai
        set ty_le [format "%.1f%%" [expr {$sai * 100.0 / 206}]]
    }

    puts [format "%-12s %-9s %-8s %-6s %s" [file tail $f] $commit $ket_qua $sai $ty_le]
}

puts "Tong so phep nhan sai: $tong"
