function compileFLIMLib(Cpath)
% compileFLIMLib(Cpath) a function to compile the mxFLIMLib to use with
%   your installation of Matlab.
%
%       Cpath   Directory containing the FLIMLib source code.
%               [Default = '../main/c/']
%
%   The compileFLIMLib function EcfSingle.c, EcfUtil.c, Ecf.h, and 
%   EcfInternal.h from Cpath into its folder and deletes old compiled
%   binaries. Finally, mxFLIMLib is compiled to run in Matlab.
%
%   compileFLIMLib assumes that a functioning mex compiler in your Matlab
%   installation. If the compiler is installed, functional and compatible
%   with mxFLIMLib code, this function should run without any problem. If
%   if fails to compile, make sure a mex compiler is installed and run the
%   following command on the Matlab command line to select the compiler:
%   
%       mex -setup
%
%
%   The following compilers have been tested with mxFLIMLib:
%   Linux 64-bit:       gcc 4.7.2
%   Windows XP 32-bit:  Windows SDK 7.1
%                       gcc 4.7.1 (part of MinGW)
%
%   The following compilers are not compatible with mxFLIMLib:
%   Windows XP 32-bit:  Lcc-win32 2.4.1
%
%   Note for Linux users only: The function copies the mexopts.sh file 
%   from matlabroot directory and removes the instances of "-ansi" from it.
%   Otherwise, mxFLIMLib will fail to compile.
%
% GNU GPL license 3.0
% copyright 2013-2014 Jakub Nedbal



% Assume that C-files are in '../c/' if no folder has been provided
if ~exist('Cpath', 'var')
    Cpath = ['..' filesep 'main' filesep 'c' filesep];
end

% Check if source directory exists
if ~exist(Cpath, 'dir')
    error('Source directory %s for C-files does not exist', Cpath);
end

% Check if FLIMLib source files exist
files = {'EcfSingle.c', 'EcfUtil.c', 'Ecf.h', 'EcfInternal.h'};
for file = files
    if ~exist([Cpath file{1}], 'file')
        error('Cannot find %s in %s.', file{1}, Cpath);
    end
end


% Check is mxFLIMLib.c exists in the current folder.
if ~exist('mxFLIMLib.c', 'file')
    error('Cannot find mxFLIMLib.c.');
end

% On Linux machines:
% Copy mexopts.sh file from matlabroot and delete all instances of "-ansi"
% from it. Otherwise mxFLIMLib would not compile
if any(strcmpi(computer, {'GLNXA64', 'GLNX86'}))
    copyfile([matlabroot filesep 'bin' filesep 'mexopts.sh'], ...
             'mexopts.sh', 'f');
    perl('replace.pl', 'mexopts.sh', '-ansi', '');
end

% On MAC OS X machines:
% Copy mexopts.sh file from matlabroot and change instances of 10.7 to 10.8
% if the MAC OS X version is higher than 10.7. Otherwise mxFLIMLib would
% not compile.
if strcmpi(computer, 'MACI64')
    copyfile([matlabroot filesep 'bin' filesep 'mexopts.sh'], ...
             'mexopts.sh', 'f');
    perl('replace.pl', 'mexopts.sh', '10.7', '10.8');
end


% Copy all necessary FLIMLib source files into the current directory
files = {'EcfSingle.c', 'EcfUtil.c', 'Ecf.h', 'EcfInternal.h'};
for file = files
    copyfile([Cpath file{1}], '.', 'f');
end

% Delete old mxFLIMLib compiled binaries
if exist(['mxFLIMLib.' mexext], 'file')
    delete(['mxFLIMLib.' mexext]);
end

% Compile mxFLIMLib
com = computer;
switch com
    case {'GLNXA64', 'GLNX86', 'MACI64'}
        fprintf('Compiling mxFLIMLib for %s architecture...\n', com);
        mex -f ./mexopts.sh mxFLIMLib.c EcfUtil.c EcfSingle.c
    case {'PCWIN', 'PCWIN64'}
        fprintf('Compiling mxFLIMLib for %s architecture...\n', com);
        mex mxFLIMLib.c EcfUtil.c EcfSingle.c
    otherwise
        fprintf('Not sure how to compile mxFLIMLib on your computer ');
        fprintf('architecture: %s. Attempting...\n', com);
        mex mxFLIMLib.c EcfUtil.c EcfSingle.c
end

% Delete the temporary FLIMLib source files
for file = files
    delete(file{1});
end

% We need to clear mex after compiling. In Windows if we try to re-compile
% without having run `clear mex` we will get the following error:
%       mt : general error c101008d: Failed to write the updated manifest to the resource of
%       file "mxFLIMLib.mexw64". Access is denied.  
clear mex;

fprintf('Finished compiling mxFLIMLib.\n');
