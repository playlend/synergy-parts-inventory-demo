;  Parts inventory repository schema
;
;  One structure (PART) and one file (PARTS). Build this project to
;  generate rpsmain/rpstext; the Traditional projects reference it and
;  include the record with  .include "PART" repository, record="part"

Structure PART   DBL ISAM
   Description "Part master record"

Field PARTNO   Type ALPHA   Size 6
   Description "Part number"

Field DESCR   Type ALPHA   Size 30
   Description "Description"

Field QTY   Type DECIMAL   Size 6
   Description "Quantity on hand"

Field REORDER   Type DECIMAL   Size 6
   Description "Reorder level"

Field PRICE   Type DECIMAL   Size 8   Precision 2
   Description "Unit price in dollars"

Key PARTNO   ACCESS   Order ASCENDING   Dups NO
   Segment FIELD   PARTNO

File PARTS   DBL ISAM   "DAT:parts.ism"
   Description "Parts master file"
   Assign PART
