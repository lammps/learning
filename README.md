# Learning Molecular Dynamics with LAMMPS

## Overview

This is the source repository for the "Learning Molecular Dynamics
with LAMMPS" website and related documents.  This will allow you
to modify and re-build the website and derived documents from
the Makefile provided here.  The website is written in ReStructured
Text and created using the Sphinx tool in a very similar fashion
to the LAMMPS manual.

## License

![CC BY-SA 4.0](src/images/by-sa-small.png)

This content is provided under a Creative Commons Attribution-ShareAlike
license.  This basically means that you are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt - Adapt — remix, transform, and build upon the material for any
  purpose, even commercially

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the
  license, and indicate if changes were made.  You may do so in any
  reasonable manner, but not in any way that suggests the licensor
  endorses you or your use.

- ShareAlike — If you remix, transform, or build upon the material, you
  must distribute your contributions under the same license as the
  original.

- No additional restrictions — You may not apply legal terms or
  technological measures that legally restrict others from doing
  anything the license permits.

For more details, please refer to the [LICENSE.md file](LICENSE.md)

## Files and folders

Here is a list of the files and sub-directories with descriptions:

|              | Description                                  |
|--------------|----------------------------------------------|
| README.md    |   this file                                  |
| LICENSE.md   |   CC BY SA 4.0 License file                  |
| src          |   content files for the website              |
| html         |   HTML version after running "make html"     |
| latex        |   LaTeX source files for PDF version         |
| utils        |   utilities and settings for building        |
| doctree      |   temporary data                             |
| docenv       |   python virtual environment used for build  |
| .gitignore   |   list of file patterns to be ignored by git |

## Translating the source files

You can translate the source into HTML, PDF, EPUB, or MOBI format by
"make html", "make pdf", "make epub", or "make mobi", respectively.
This requires a few additional tools and files.  Some of them have to be
installed (more on that below).  For the rest the build process will
attempt to download and install into a python virtual environment and
local folders.

## Installing prerequisites for processing the documents

To run the HTML build toolchain, python 3.x, git, and the venv python
module have to be installed if not already available.  Also internet
access is initially required to download external files and tools.

Building the PDF file requires in addition a compatible LaTeX
installation with support for PDFLaTeX and several add-on LaTeX packages
installed.  This includes:

- amsmath
- anysize
- babel
- capt-of
- cmap
- fncychap
- framed
- geometry
- hyperref
- hypcap
- needspace
- pict2e
- times
- tabulary
- upquote
- wrapfig

Also the *latexmk* script is required to run PDFLaTeX and related tools.
the required number of times to have self-consistent output and include
updated bibliography and indices.

Building the EPUB format requires LaTeX installation with the same
packages as for the PDF format plus the 'dvipng' command to convert the
embedded math into images.  The MOBI format is generated from the EPUB
format file by using the tool 'ebook-convert' from the 'calibre' e-book
management software (https://calibre-ebook.com).

[modeline]: # ( vim: set tw=72: )
