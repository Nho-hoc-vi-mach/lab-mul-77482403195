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

