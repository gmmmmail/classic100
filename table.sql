drop table if exists Music;
create table Music
(
ID integer primary key autoincrement  not null,
MusicID clob,
MusicName clob,
Mp3URL clob,
FilePath clob,
ImageURL clob,
isDownload varchar(1)
);
