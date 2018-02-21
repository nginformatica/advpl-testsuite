# AdvPL TestSuite

> Mocha + Chai like test suite and light environment for AdvPL

AdvPL TestSuite is an awesome tool to write unit and feature-driven tests for AdvPL
programming language with a lot of utilities and resources to make testing and asserting
correctness less painful. It also provides a cute syntax and support for plugins to make
you happy.

![Example](./resources/example.png)

The tests of this tool are also written with itself. You can check it out yourself under
[tests/](./tests) directory.

## Example

```xbase
#include 'protheus.ch'
#include 'testsuite.ch'

TestSuite Files Description 'Having fun with files' Verbose
    Enable Environment 'T3' 'S SC 01'
    Enable Before
    Feature CreateFile Description 'We are able to create and read files'
EndTestSuite

Before TestSuite Files
    If File( '\love.txt' )
        FErase( '\love.txt' )
    EndIf
    Return

Feature CreateFile TestSuite Files
    Local nHandle

    nHandle := FCreate( '\love.txt' )
    FWrite( nHandle, 'I love you <3' )
    FClose( nHandle )

    ::Expect( nHandle ):Not():ToHaveType( 'C' )
    ::Expect( nHandle ):ToHaveType( 'N' )
    ::Expect( nHandle ):Not():ToBe( 0 )
    ::Expect( '\hate.txt' ):Not():ToBeAfile()
    ::Expect( '\love.txt' ):ToBeAFile()
    ::Expect( '\love.txt' ):Not():ToBeAFileWithContents( 'I hate you :@' )
    ::Expect( '\love.txt' ):ToBeAFileWithContents( 'I love you <3' )
    Return

CompileTestSuite Files
```

Run it with `U_FILES` and check your _AppServer_.

## Features

## Installation

Installing AdvPL TestSuite is quite simple!

- Download [include/testsuite.ch](./include/testsuite.ch) and move it to your _includes_ directory
- Download and compile all the files under [src/](./src/) directory

And you are done!
