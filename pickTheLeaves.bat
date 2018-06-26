@ECHO OFF

:: check there is at least one argument
IF [%1]==[] ECHO "failed" & GOTO Syntax

:: create extracted subfolder
SET OPDIR=%1\extracted
mkdir %OPDIR%

:: specify extensions for files we will decompress
SET EXTS=.zip .Z .7z

:: copy files to extracted folder
for %%e in (%EXTS%) do copy "%1\*%%e" "%1\extracted" > NUL

:: while there are any of the above types in OPDIR, 
:: extract then delete (safe to delete because using
:: autorename flag -aou)

:: safeguard against infinite loops
SET maxLevels=100
SET levelCounter=1

:Mywhileloop
SET DONE=TRUE
for %%e in (%EXTS%) do (IF EXIST "%OPDIR%\*%%e" (SET DONE=FALSE))
IF "%DONE%"=="FALSE" (
	for %%e in (%EXTS%) do (
		for %%f in ("%OPDIR%\*%%e") do (
			7z e %%f -o%OPDIR% -aou > NUL
			del /f %%f
		)
	)
	IF %levelCounter% LEQ %maxLevels% (
		SET /A levelCounter+=1
		GOTO :Mywhileloop
	)	
)

GOTO End



:Syntax
ECHO.
ECHO pickTheLeaves.bat, Version 0.1.0 for Windows 7
ECHO.
ECHO This  script takes a directory as an argument and uses
ECHO 7-Zip (www.7-zip.org) to recursively decompress all 
ECHO .zip, .Z, and .7z files in that directory, by which I 
ECHO mean that if a .zip file contains a .Z file, for 
ECHO example, then that .Z file will also be decompressed 
ECHO and so on. 7-Zip is capable of decompressing other 
ECHO formats but other formats are not addressed in this
ECHO version.
ECHO.
ECHO At the end of this process, the above specified 
ECHO directory ECHO will contain the original files and a 
ECHO subdirectory called "extracted". The latter will 
ECHO contain the leaves of the trees, i.e. the results of 
ECHO unzipping and unzipping until we finally get to 
ECHO something that isn't a .zip, .Z, or .7z.
ECHO.
ECHO Usage: pickTheLeaves [ directory ]
ECHO.
ECHO Example: pickTheLeaves .
ECHO.
ECHO Written by Amanda Hood
ECHO ahood @ github

:End



