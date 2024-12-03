IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO-WORLD.

ENVIRONMENT DIVISION.
    INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT INFILE ASSIGN TO 'input/Dec1Input.txt'
                ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
    FILE SECTION.
        FD INFILE.
        01 INPUT-REC.
           05 A-SIDE PIC 9(5).
           05 FILLER PIC X(3).
           05 B-SIDE PIC 9(5).

    WORKING-STORAGE SECTION.
        01 ARR-A PIC 9(5) OCCURS 1000 TIMES.
        01 ARR-B PIC 9(5) OCCURS 1000 TIMES.
        01 IND PIC 9(9) VALUE 1.
        01 IND2 PIC 9(9) VALUE 1.
        01 IND3 PIC 9(9) VALUE 1.
        01 TEMP PIC 9(5) VALUE 1.
        01 N PIC 9(9).
        01 EOF PIC A(1).
        01 TOTAL PIC 9(9).
        01 SIMILARITY PIC 9(9).

PROCEDURE DIVISION.
    OPEN INPUT INFILE.
    PERFORM READ-NUMS UNTIL EOF = 'Y'.
    COMPUTE N = IND - 1
    PERFORM SORT-NUMS.
    PERFORM CALC-TOTAL
    PERFORM CALC-SIMILARITY
    PERFORM PRINT-NUMS
    CLOSE INFILE
    STOP RUN.

    READ-NUMS.
       READ INFILE
           AT END MOVE 'Y' TO EOF
           NOT AT END PERFORM STORE-NUMS
       END-READ.

    STORE-NUMS.
       MOVE A-SIDE TO ARR-A(IND)
       MOVE B-SIDE TO ARR-B(IND)
       COMPUTE IND = IND + 1.

    SORT-NUMS.
       PERFORM VARYING IND FROM N BY -1
       UNTIL IND < 2
           PERFORM VARYING IND2 FROM 1 BY 1
           UNTIL IND2 = IND
               COMPUTE IND3 = IND2 + 1
               IF ARR-A(IND2) > ARR-A(IND3)
               THEN
                   MOVE ARR-A(IND2) TO TEMP
                   MOVE ARR-A(IND3) TO ARR-A(IND2)
                   MOVE TEMP TO ARR-A(IND3)
               END-IF
           END-PERFORM
       END-PERFORM.
       
       PERFORM VARYING IND FROM N BY -1
       UNTIL IND < 2
           PERFORM VARYING IND2 FROM 1 BY 1
           UNTIL IND2 = IND
               COMPUTE IND3 = IND2 + 1
               IF ARR-B(IND2) > ARR-B(IND3)
               THEN
                   MOVE ARR-B(IND2) TO TEMP
                   MOVE ARR-B(IND3) TO ARR-B(IND2)
                   MOVE TEMP TO ARR-B(IND3)
               END-IF
           END-PERFORM
       END-PERFORM.

    CALC-TOTAL.
       PERFORM VARYING IND FROM 1 BY 1 UNTIL IND > N
           COMPUTE TEMP = ARR-A(IND) - ARR-B(IND)
           IF TEMP < 0
               COMPUTE TEMP = 0 - TEMP
           END-IF
           COMPUTE TOTAL = TOTAL + TEMP
       END-PERFORM.
    
    CALC-SIMILARITY.
       PERFORM VARYING IND FROM 1 BY 1 UNTIL IND > N
           MOVE 0 TO TEMP
           PERFORM VARYING IND2 FROM 1 BY 1 UNTIL IND2 > N
               IF ARR-A (IND) = ARR-B (IND2)
                   COMPUTE TEMP = TEMP + 1
               END-IF
           END-PERFORM
           COMPUTE SIMILARITY = SIMILARITY + ARR-A (IND) * TEMP
       END-PERFORM.

    PRINT-NUMS.
       DISPLAY TOTAL.
       DISPLAY SIMILARITY.
       