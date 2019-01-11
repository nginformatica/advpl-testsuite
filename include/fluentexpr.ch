#xcommand Throw <cMsg> With <aValues> ;
    => ;
    __MSG__ := Format( <cMsg>, <aValues> ) ;;
    aAdd( aTestReport, { .F., __MSG__ } ) ;;
    UserException( __MSG__ ) ;;
    Return Self

#xcommand Passed <cMsg> With <aValues> ;
    => ;
    __MSG__ := Format( <cMsg>, <aValues> ) ;;
    aAdd( aTestReport, { .T., __MSG__ } ) ;;
    Return Self

#xcommand Expect <prm,...> to [<not>] be <expr,...> ;
     =>;
     ::Expect(<prm>):[<Not>():]ToBe(<expr>)

#xcommand Expect <prm,...> to [<not>] be a file ;
     =>;
     ::Expect(<prm>):[<Not>():]ToBeAFile()

#xcommand Expect <prm,...> to [<not>] be a file with contents <expr,...> ;
     =>;
     ::Expect(<prm>):[<Not>():]ToBeAFileWithContents(<expr>)

#xcommand Expect <prm,...> to [<not>] be a folder;
     =>;
     ::Expect(<prm>):[<Not>():]ToBeAFolder()

#xcommand Expect <prm,...> to [<not>] have type <expr,...> ;
     =>;
     ::Expect(<prm>):[<Not>():]ToHaveType(<expr>)

#xcommand Expect <prm,...> to [<not>] throw error;
     =>;
     ::Expect(<prm>):[<Not>():]ToThrowError(<expr>)