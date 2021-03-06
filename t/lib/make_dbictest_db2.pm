package make_dbictest_db2;

use strict;
use warnings;
use DBI;

eval { require DBD::SQLite };
my $class = $@ ? 'SQLite2' : 'SQLite';

my $fn = './t/dbictest.db';

unlink($fn);
our $dsn = "dbi:$class:dbname=$fn";
my $dbh = DBI->connect($dsn);

$dbh->do($_) for (
    q|CREATE TABLE foos (
        fooid INTEGER PRIMARY KEY,
        footext TEXT
      )|,
    q|CREATE TABLE bar (
        barid INTEGER PRIMARY KEY,
        foo_id INTEGER NOT NULL REFERENCES foos (fooid)
      )|,
    q|CREATE TABLE bazs (
        bazid INTEGER PRIMARY KEY,
        baz_num INTEGER NOT NULL UNIQUE
      )|,
    q|CREATE TABLE quuxs (
        quuxid INTEGER PRIMARY KEY,
        baz_id INTEGER NOT NULL UNIQUE,
        FOREIGN KEY (baz_id) REFERENCES bazs (baz_num)
      )|,
    q|INSERT INTO foos VALUES (1,'Foos text for number 1')|,
    q|INSERT INTO foos VALUES (2,'Foos record associated with the Bar with barid 3')|,
    q|INSERT INTO foos VALUES (3,'Foos text for number 3')|,
    q|INSERT INTO foos VALUES (4,'Foos text for number 4')|,
    q|INSERT INTO bar VALUES (1,4)|,
    q|INSERT INTO bar VALUES (2,3)|,
    q|INSERT INTO bar VALUES (3,2)|,
    q|INSERT INTO bar VALUES (4,1)|,
    q|INSERT INTO bazs VALUES (1,20)|,
    q|INSERT INTO bazs VALUES (2,19)|,
    q|INSERT INTO quuxs VALUES (1,20)|,
    q|INSERT INTO quuxs VALUES (2,19)|,
);

END { unlink($fn); }

1;
