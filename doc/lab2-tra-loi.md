# LAB 2 - BAI THUC HANH

## PHAN 1 - LENH LINUX

### Q1. Phan tich cac commit

Lenh:
tail -n 1 logs/*.log
grep -h '^\[sim\]' logs/*.log | awk '{print $4}' | sort | uniq -c

Ket qua:
- a1f3c09: FAIL - timeout sau 0 phep nhan.
- 5be2d14: FAIL - 103 va 88 phep nhan sai.
- c7e90aa: PASS - 206/206 phep nhan dung.

Nhan xet:
Phien ban a1f3c09 co the bi loi req_ready
hoac resp_valid khong len 1.

### Q2. Tong so phep nhan sai

Lenh:
grep -h 'phep nhan sai' logs/*.log | awk '{s += $2} END {print s}'

Ket qua: 103 + 88 = 191 phep nhan sai.

Chi co 20 dong LOI vi testbench chi in toi da
10 loi dau tien trong moi lan mo phong.

### Q3. Tim quy luat loi

Lenh:
grep -h LOI logs/*.log | awk '{print $3}'
grep -oh 'b=0x[0-9a-f]' logs/*.log | sort | uniq -c

Ket qua:
20 loi duoc in ra deu co b >= 0x8000,
nghia la bit b[15] = 1.

Gia thuyet:
Bo nhan bo qua bit b[15], co the do FSM
chuyen tu CALC sang DONE qua som,
truoc khi xu ly bit cuoi.

### Q4. Kiem tra gia thuyet

Lenh:
python3 -c 'a=0x0003; b=0x8001; print(hex(a*(b%0x8000)))'

Ket qua: 0x3
Ket qua dung: 0x00018003
Ket qua sai trong log: 0x00000003

Nhan xet:
Ket qua khop voi gia thuyet bo qua bit b[15].

### Q5. Phan biet > va >>

Lenh 1:
grep -h LOI logs/*.log > doc/loi-mau.txt
wc -l doc/loi-mau.txt
Ket qua: 20 dong.

Lenh 2:
grep -h LOI logs/*.log >> doc/loi-mau.txt
wc -l doc/loi-mau.txt
Ket qua: 40 dong.

Nhan xet:
> ghi de noi dung cu.
>> ghi noi them vao cuoi file.

## PHAN 3 - GIT CO BAN

### Q9. Lich su commit

Lenh: git log --oneline --graph --all

Repo ca nhan:

```
* a93814e Sua 6 loi khai bao cong SystemVerilog
*   0eea9ba Merge nhanh readme
|\
| * 093400d Tran Minh Nho va 77482403195 vao README
|/
* bb75768 Khoi tao Lab 2 va luu ket qua Linux Q1-Q5
```

Repo Binh:

```
*   f589b9b Gop SUB va AND
|\
| * 3defd34 Binh them phep SUB
* | 012fca8 An them phep AND
|/
* 4108c66 An tao khung ALU
```

### Q10. Vi sao push cua An bi tu choi?

Binh da push commit them phep SUB len repository chung truoc.

An chua cap nhat thay doi cua Binh ma da commit them phep AND va push. Lich su commit cua An va repository chung bi phan nhanh.

Git tu choi push de tranh lam mat thay doi cua Binh.

An su dung git pull --no-rebase origin main, giai quyet merge conflict, sau do git add, git commit va git push.

### Q11. Vi sao khong commit sim/?

Thu muc sim/ chua cac file sinh ra trong qua trinh bien dich va mo phong. Cac file nay co the tao lai bang Makefile.

Khong commit sim/ de tranh tang dung luong repository va luu cac file khong can thiet.

Neu da commit sim/, su dung lenh:

```
git rm -r --cached sim/
git commit -m "Bo theo doi thu muc sim"
```

Lenh --cached chi bo theo doi trong Git, van giu file tren o dia.

Them sim/ vao .gitignore de tranh commit lai.
## PHAN 4 - MAKEFILE

### Q13. Vi sao make sim-icarus khong bien dich lai?

Lenh:
make sim-icarus
make sim-icarus
touch rtl/mul16.sv
make sim-icarus

Ket qua:
- Lan 1: bien dich bang iverilog va chay vvp.
- Lan 2: chi chay vvp, khong bien dich lai.
- Sau touch: bien dich lai va chay vvp.

Giai thich:
Make so sanh thoi gian cap nhat cua file dich
.vvp voi cac file nguon RTL va testbench.

Neu file nguon moi hon file dich, Make se
bien dich lai.

Target sim cua Verilator duoc khai bao .PHONY
nen moi lan goi deu chay lenh verilator.

### Q14. Tac dung cua .PHONY

Lenh:
touch clean
make clean
rm clean

Ket qua:
rm -rf sim/

Neu thieu .PHONY va co file ten clean,
Make co the coi target clean da cap nhat
va khong chay lenh don dep.

.PHONY giup target clean luon duoc thuc hien
khi goi make clean.

### Q15. Ghi de bien trong Makefile

Lenh:
make trace A=200 B=7 W=8

Ket qua:
W=8, a=200, b=7
p = 1400 (0x0578) -> DUNG

Lenh tren ghi de ba bien A, B va W.

Gia tri mac dinh:
A = 13
B = 11
W = 4

Toan tu ?= chi gan gia tri khi bien chua
duoc dinh nghia, cho phep nguoi dung thay
doi tham so tu dong lenh ma khong can
chinh sua Makefile.
## PHAN 5 - TCL SCRIPT

### Q16. Su khac nhau giua dau ngoac kep va ngoac nhon

Vi du:
set w 16
puts "W = $w"
puts {W = $w}

Ket qua:
W = 16
W = $w

Dau ngoac kep cho phep thay the gia tri bien.
Dau ngoac nhon giu nguyen noi dung ben trong.

Dieu kien cua if va bieu thuc cua expr nen
dat trong ngoac nhon de tranh thay the som
va giup Tcl danh gia bieu thuc dung luc.

### Q17. Tinh ty le phep nhan sai

Cong thuc:
Ty le = So phep sai * 100.0 / 206

Code:
set ty_le [format "%.1f%%" [expr {$sai * 100.0 / 206}]]

Lenh kiem tra:
make logs

Ket qua:
File         Commit    Ket qua  Sai    Ty le
run_01.log   a1f3c09   TREO     -      -
run_02.log   5be2d14   FAIL     103    50.0%
run_03.log   5be2d14   FAIL     88     42.7%
run_04.log   c7e90aa   PASS     0      0.0%
run_05.log   c7e90aa   PASS     0      0.0%

Tong so phep nhan sai: 191

Lan mo phong bi treo khong co ket qua
hop le nen khong tinh ty le.

### Q18. Vi sao nen su dung Tcl?

Tcl co the goi truc tiep cac lenh cua Yosys,
OpenSTA va OpenROAD.

Tcl ho tro bien, vong lap, dieu kien,
ham va xu ly file.

Su dung Tcl giup tu dong hoa qua trinh
tong hop RTL, phan tich timing va thiet ke
vat ly ma khong can go tung lenh thu cong.
