
CREATE TABLE user_tbl (
  user_id varchar2(10) NOT NULL PRIMARY KEY,
  user_pwd varchar2(10) NOT NULL,
  user_name varchar2(20) NOT NULL,
  user_birth varchar2(8) NOT NULL,
  user_addr varchar2(100) NOT NULL,
  user_tel varchar2(15),
  adm_check varchar2(1) default '0'
);


CREATE TABLE book_tbl (
  book_id varchar2(10) NOT NULL,
  book_code varchar2(2) not null,
  book_name varchar2(50) NOT NULL,
  book_author varchar2(30) NOT NULL,
  book_date varchar2(8) NOT NULL,
  book_pub  varchar2(100) NOT NULL,
  book_in_date date,
  book_imgPath varchar2(100),
  PRIMARY KEY (book_id)
);

CREATE TABLE rent_tbl (
  rent_no varchar2(12) NOT NULL,
  user_id varchar2(10) NOT NULL,
  book_id varchar2(10) not null,
  book_rent_date date NOT NULL,
  book_re_due_date date NOT NULL,
  book_re_date date,
  book_status varchar2(1) default '1',
  PRIMARY KEY (rent_no),
  foreign key(user_id) references user_tbl(user_id),
  foreign key(book_id) references book_tbl(book_id)
);


create or replace trigger user_id_tri
after update on user_tbl
for each row
begin
  update rent_tbl
  set user_id=:new.user_id
  where user_id=:old.user_id;
end;

create or replace trigger book_id_tri
after update on book_tbl
for each row
begin
  update rent_tbl
  set book_id=:new.book_id
  where book_id=:old.book_id;
end;



-- rent테이블과 book테이블과 join

select r.rent_no, r.book_id, b.book_name, r.book_rent_date, r.book_re_due_date, r.book_status 
    from rent_tbl r, book_tbl b
    where r.book_id = b.book_id
      and r.user_id = ''
      order by r.book_rent_date;
      
-- book table에서 book_name 얻어오는 function

create or replace function fun_getbook_name(book_id varchar2)
    return varchar2
is
    book_name varchar(100);
begin
    select 
        book_name into book_name
    from book_tbl
    where book_id = book_id;

    return book_name;
  
exception
    when others then
        dbms_output.put_line('exception occurred! (' || sqlcode || ') : ' || sqlerrm);
        return '';
end;

select rent_no, book_id,  fun_getbook_name(book_id), book_rent_date, book_re_due_date, book_status 
    from rent_tbl
    where user_id = ''
   order by book_rent_date; 

-- MAx값   
select to_char((decode(max(substr(book_id,3,6)),null,0,max(substr(book_id,3,6))))+1,'000000') 
from book_tbl where book_code = '01';  

INSERT  INTO BOOK_TBL VALUES ('0100000102','01','스프링','코딩단','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('1410000101','14','Spring','코딩단','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('1410000102','14','Spring','코딩단','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('1410000103','14','Spring','코딩단','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('2100000101','21','JSP','JSP','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('2100000102','21','JSP','JSP','20150816','남가람북스',sysdate,'');
INSERT  INTO BOOK_TBL VALUES ('2100000103','21','JSP','JSP','20150816','남가람북스',sysdate,'');

INSERT  INTO user_tbl VALUES ('mong','abc1234','김몽이','20090825','대한민국','010-0000-0000','');
INSERT  INTO user_tbl VALUES ('ppoyang','aaa','뽀양이','20090825','태양계 지구별 906호','010-2222-3333','');
INSERT  INTO user_tbl VALUES ('hj','1111','김현주','19900508','경기도 의왕시 오전로 63','031-452-0000','1');

commit;
